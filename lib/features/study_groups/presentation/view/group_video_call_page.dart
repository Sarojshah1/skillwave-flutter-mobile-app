import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:skillwave/cores/services/socket_service.dart';

class GroupVideoCallPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatarUrl;

  const GroupVideoCallPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatarUrl,
  }) : super(key: key);

  @override
  State<GroupVideoCallPage> createState() => _GroupVideoCallPageState();
}

class _GroupVideoCallPageState extends State<GroupVideoCallPage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, RTCPeerConnection> _peerConnections = {};
  MediaStream? _localStream;
  bool _micOn = true;
  bool _videoOn = true;
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _initRenderers();
    _startLocalStream();
    _setupSignaling();
    _joinRoom();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
  }

  Future<void> _startLocalStream() async {
    final mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user', 'width': 720, 'height': 1280},
    };
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
  }

  void _joinRoom() {
    _socketService.joinGroupRoomAfterConnect(
      widget.groupId,
      widget.currentUserId,
    );
  }

  void _setupSignaling() {
    _socketService.offerStream.listen((data) async {
      final fromUserId = data['userId'];
      if (fromUserId == widget.currentUserId) return;
      final offer = data['offer'];
      final senderSocketId = data['socketId'];
      await _handleOffer(offer, fromUserId, senderSocketId);
    });

    _socketService.answerStream.listen((data) async {
      final fromUserId = data['userId'];
      if (fromUserId == widget.currentUserId) return;
      final answer = data['answer'];
      await _handleAnswer(answer, fromUserId);
    });

    _socketService.iceCandidateStream.listen((data) async {
      final fromUserId = data['userId'];
      if (fromUserId == widget.currentUserId) return;
      final candidate = data['candidate'];
      await _handleIceCandidate(candidate, fromUserId);
    });

    _socketService.userJoinedStream.listen((data) async {
      final userId = data['userId'];
      final socketId = data['socketId'];
      if (userId == widget.currentUserId) return;
      await _createOffer(userId, socketId);
    });
  }

  Future<RTCPeerConnection> _createPeerConnection(String remoteUserId) async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };
    final pc = await createPeerConnection(config);
    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    pc.onTrack = (event) {
      if (event.track.kind == 'video') {
        if (!_remoteRenderers.containsKey(remoteUserId)) {
          final renderer = RTCVideoRenderer();
          renderer.initialize().then((_) {
            renderer.srcObject = event.streams.isNotEmpty ? event.streams[0] : null;
            setState(() {
              _remoteRenderers[remoteUserId] = renderer;
            });
          });
        } else {
          _remoteRenderers[remoteUserId]?.srcObject =
          event.streams.isNotEmpty ? event.streams[0] : null;
        }
      }
    };

    pc.onIceCandidate = (candidate) {
      _socketService.sendIceCandidate(
        {'candidate': candidate.toMap()},
        widget.groupId,
        widget.currentUserId,
        targetSocketId: null,
      );
    };

    _peerConnections[remoteUserId] = pc;
    return pc;
  }

  Future<void> _createOffer(String remoteUserId, String? targetSocketId) async {
    final pc = await _createPeerConnection(remoteUserId);
    final offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    _socketService.sendOffer(
      offer.toMap(),
      widget.groupId,
      widget.currentUserId,
      targetSocketId: targetSocketId,
    );
  }

  Future<void> _handleOffer(
      dynamic offer, String remoteUserId, String? senderSocketId) async {
    final pc = await _createPeerConnection(remoteUserId);
    await pc.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );
    final answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    _socketService.sendAnswer(
      answer.toMap(),
      widget.groupId,
      widget.currentUserId,
      targetSocketId: senderSocketId,
    );
  }

  Future<void> _handleAnswer(dynamic answer, String remoteUserId) async {
    final pc = _peerConnections[remoteUserId];
    if (pc != null) {
      await pc.setRemoteDescription(
        RTCSessionDescription(answer['sdp'], answer['type']),
      );
    }
  }

  Future<void> _handleIceCandidate(dynamic candidate, String remoteUserId) async {
    final pc = _peerConnections[remoteUserId];
    if (pc != null && candidate != null) {
      await pc.addCandidate(
        RTCIceCandidate(
          candidate['candidate'],
          candidate['sdpMid'],
          candidate['sdpMLineIndex'],
        ),
      );
    }
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    for (final renderer in _remoteRenderers.values) {
      renderer.dispose();
    }
    for (final pc in _peerConnections.values) {
      pc.close();
    }
    super.dispose();
  }

  Widget _buildControlsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(_micOn ? Icons.mic : Icons.mic_off, () => setState(() => _micOn = !_micOn)),
          const SizedBox(width: 16),
          _buildIconButton(_videoOn ? Icons.videocam : Icons.videocam_off, () => setState(() => _videoOn = !_videoOn)),
          const SizedBox(width: 16),
          _buildIconButton(Icons.screen_share, () {}),
          const SizedBox(width: 16),
          _buildIconButton(Icons.call_end, () => Navigator.pop(context), color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color color = Colors.white}) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.grey.shade900,
      child: IconButton(
        icon: Icon(icon, color: color, size: 28),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildVideoTile(RTCVideoRenderer renderer, String label, {bool isLocal = false}) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black87,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RTCVideoView(renderer, mirror: isLocal, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTiles = <Widget>[
      _buildVideoTile(_localRenderer, widget.currentUserName, isLocal: true),
      ..._remoteRenderers.entries.map((e) => _buildVideoTile(e.value, e.key)),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: allTiles.length <= 2 ? 1 : 2,
            children: allTiles,
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(widget.currentUserAvatarUrl)),
                const SizedBox(width: 12),
                Text(widget.groupName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('${_remoteRenderers.length + 1} in call', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(child: _buildControlsBar()),
          ),
        ],
      ),
    );
  }
}
