import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:intl/intl.dart';

class GroupChatPage extends StatefulWidget {
  final String groupName;
  const GroupChatPage({Key? key, required this.groupName}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _ChatMessage {
  final String sender;
  final String text;
  final bool isMe;
  final DateTime time;
  final String avatarUrl;
  _ChatMessage({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.time,
    required this.avatarUrl,
  });
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: 'Alice',
      text: 'Hey everyone!',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      avatarUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    ),
    _ChatMessage(
      sender: 'Me',
      text: 'Hi Alice!',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 4)),
      avatarUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
    ),
    _ChatMessage(
      sender: 'Bob',
      text: 'Hello!',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 3)),
      avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
    ),
    _ChatMessage(
      sender: 'Me',
      text: 'How are you all?',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      avatarUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
    ),
    _ChatMessage(
      sender: 'Alice',
      text: 'Doing great!',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 1)),
      avatarUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    ),
    _ChatMessage(
      sender: 'Bob',
      text: 'Same here!',
      isMe: false,
      time: DateTime.now().subtract(const Duration(seconds: 30)),
      avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(
          _ChatMessage(
            sender: 'Me',
            text: text,
            isMe: true,
            time: DateTime.now(),
            avatarUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
          ),
        );
        _controller.clear();
      });
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
      ),
      backgroundColor: const Color(0xFFE9EBEE),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
                return _ChatBubble(msg: msg);
              },
            ),
          ),
          _ChatInputBar(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage msg;
  const _ChatBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm a').format(msg.time);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        mainAxisAlignment: msg.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(msg.avatarUrl),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!msg.isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 2),
                    child: Text(
                      msg.sender,
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
                    color: msg.isMe ? SkillWaveAppColors.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
                      bottomRight: Radius.circular(msg.isMe ? 4 : 18),
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
                    msg.text,
                    style: TextStyle(
                      color: msg.isMe ? Colors.white : Colors.black87,
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
          if (msg.isMe)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(msg.avatarUrl),
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
  const _ChatInputBar({required this.controller, required this.onSend});

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
