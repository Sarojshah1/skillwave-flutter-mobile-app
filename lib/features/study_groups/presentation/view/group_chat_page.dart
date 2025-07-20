import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:intl/intl.dart';
import 'package:skillwave/features/study_groups/presentation/view_model/group_chat_bloc.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'package:skillwave/cores/services/socket_service.dart';
import 'package:skillwave/features/study_groups/presentation/view/group_video_call_page.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatarUrl;
  const GroupChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatarUrl,
  }) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _controller = TextEditingController();
  bool _initialized = false;
  final SocketService _socketService = SocketService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final bloc = context.read<GroupChatBloc>();
      // Ensure joining the group room after socket connect
      _socketService.joinGroupRoomAfterConnect(
        widget.groupId,
        widget.currentUserId,
      );
      bloc.add(LoadGroupChatMessages(widget.groupId));
      bloc.add(const SubscribeToRealtimeMessages());
      _initialized = true;
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<GroupChatBloc>().add(
        SendGroupMessageApi(groupId: widget.groupId, messageContent: text),
      );
      context.read<GroupChatBloc>().add(
        SendGroupMessageRealtime(
          groupId: widget.groupId,
          userId: widget.currentUserId,
          messageContent: text,
        ),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/194/194938.png',
              ),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.groupName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: SkillWaveAppColors.primary,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            tooltip: 'Start Video Call',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GroupVideoCallPage(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    currentUserId: widget.currentUserId,
                    currentUserName: widget.currentUserName,
                    currentUserAvatarUrl: widget.currentUserAvatarUrl,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE9EBEE),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<GroupChatBloc, GroupChatState>(
              builder: (context, state) {
                print('[UI] Bloc state: $state');
                if (state is GroupChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GroupChatLoaded) {
                  final messages = state.messages;
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[messages.length - 1 - index];
                      return _ChatBubble(
                        msg: msg,
                        isMe: msg.sender.id == widget.currentUserId,
                        currentUserAvatarUrl: widget.currentUserAvatarUrl,
                      );
                    },
                  );
                } else if (state is GroupChatTypingState) {
                  final messages = state.messages;
                  print(
                    '[UI] Typing indicator should show for userId: ${state.typingUserId}',
                  );
                  // Always show 'Someone is typing...' if not the current user
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[messages.length - 1 - index];
                            return _ChatBubble(
                              msg: msg,
                              isMe: msg.sender.id == widget.currentUserId,
                              currentUserAvatarUrl: widget.currentUserAvatarUrl,
                            );
                          },
                        ),
                      ),
                      if (state.typingUserId != widget.currentUserId)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            bottom: 10,
                            right: 80,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _BeautifulTypingIndicator(),
                          ),
                        ),
                    ],
                  );
                } else if (state is GroupChatError) {
                  return Center(child: Text('Error: \\${state.message}'));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          _ChatInputBar(
            controller: _controller,
            onSend: _sendMessage,
            onTyping: () {
              print('[UI] User is typing...');
              _socketService.sendTyping(widget.groupId);
            },
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final GroupMessageEntity msg;
  final bool isMe;
  final String currentUserAvatarUrl;
  const _ChatBubble({
    required this.msg,
    required this.isMe,
    required this.currentUserAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm a').format(msg.sentAt);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(
                  "${ApiEndpoints.baseUrlForImage}/profile/${msg.sender.profilePicture}",
                ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 2),
                    child: Text(
                      msg.sender.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? SkillWaveAppColors.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.messageContent,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                  child: Text(
                    timeStr,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(
                  "${ApiEndpoints.baseUrlForImage}/profile/${msg.sender.profilePicture}",
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onTyping;
  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    this.onTyping,
  });

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  bool get _hasText => widget.controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.transparent,
                  ), // No visible border
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey[400],
                      size: 26,
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.attach_file, color: Colors.grey[400], size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: widget.controller,
                          minLines: 1,
                          maxLines: 5,
                          style: theme.textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          cursorColor: SkillWaveAppColors.primary,
                          onChanged: (_) {
                            if (widget.onTyping != null) widget.onTyping!();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            AnimatedScale(
              scale: _hasText ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: GestureDetector(
                onTap: _hasText ? widget.onSend : null,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        SkillWaveAppColors.primary,
                        SkillWaveAppColors.secondary.withOpacity(0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: SkillWaveAppColors.primary.withOpacity(0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Icon(Icons.send, color: Colors.white, size: 26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeautifulTypingIndicator extends StatelessWidget {
  const _BeautifulTypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: SkillWaveAppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SkillWaveAppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            color: SkillWaveAppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            'Someone is typing...',
            style: TextStyle(
              color: SkillWaveAppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const AnimatedEllipsis(),
        ],
      ),
    );
  }
}

class AnimatedEllipsis extends StatefulWidget {
  const AnimatedEllipsis({Key? key}) : super(key: key);

  @override
  State<AnimatedEllipsis> createState() => _AnimatedEllipsisState();
}

class _AnimatedEllipsisState extends State<AnimatedEllipsis>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(opacity: _animation.value, child: child);
      },
      child: const Text('.'),
    );
  }
}
