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
  bool _inCall = true;
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
      'video': {'facingMode': 'user', 'width': 640, 'height': 480},
    };
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
  }

  void _joinRoom() {
    // Ensure socket is connected and join the group room
    _socketService.joinGroupRoomAfterConnect(
      widget.groupId,
      widget.currentUserId,
    );
  }

  void _setupSignaling() {
    // Listen for offers
    _socketService.offerStream.listen((data) async {
      final fromUserId = data['userId'];
      if (fromUserId == widget.currentUserId) return;
      final offer = data['offer'];
      final senderSocketId = data['socketId'];
      await _handleOffer(offer, fromUserId, senderSocketId);
    });
    // Listen for answers
    _socketService.answerStream.listen((data) async {
      final fromUserId = data['userId'];
      if (fromUserId == widget.currentUserId) return;
      final answer = data['answer'];
      await _handleAnswer(answer, fromUserId);
    });
    // Listen for ICE candidates
    _socketService.iceCandidateStream.listen((data) async {
      final fromUserId = data['userId'];
      if (fromUserId == widget.currentUserId) return;
      final candidate = data['candidate'];
      await _handleIceCandidate(candidate, fromUserId);
    });
    // Listen for new participants (userJoined)
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
      debugPrint(
        '[WebRTC] onTrack for $remoteUserId: kind=${event.track.kind}, streams=${event.streams.length}',
      );
      if (event.track.kind == 'video') {
        if (!_remoteRenderers.containsKey(remoteUserId)) {
          final renderer = RTCVideoRenderer();
          renderer
              .initialize()
              .then((_) {
                renderer.srcObject = event.streams.isNotEmpty
                    ? event.streams[0]
                    : null;
                setState(() {
                  _remoteRenderers[remoteUserId] = renderer;
                });
                debugPrint(
                  '[WebRTC] Remote renderer initialized for $remoteUserId',
                );
              })
              .catchError((e) {
                debugPrint('[WebRTC] Error initializing remote renderer: $e');
              });
        } else {
          _remoteRenderers[remoteUserId]?.srcObject = event.streams.isNotEmpty
              ? event.streams[0]
              : null;
        }
      }
    };
    pc.onIceCandidate = (candidate) {
      _socketService.sendIceCandidate(
        {'candidate': candidate.toMap()},
        widget.groupId,
        widget.currentUserId,
        targetSocketId: null, // For group, broadcast
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
    dynamic offer,
    String remoteUserId,
    String? senderSocketId,
  ) async {
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

  Future<void> _handleIceCandidate(
    dynamic candidate,
    String remoteUserId,
  ) async {
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

  @override
  Widget build(BuildContext context) {
    final allTiles = <Widget>[
      _buildVideoTile(_localRenderer, widget.currentUserName, isMe: true),
      ..._remoteRenderers.entries.map(
        (entry) => _buildVideoTile(entry.value, entry.key),
      ),
    ];
    while (allTiles.length < 4) {
      allTiles.add(_buildPlaceholderTile());
    }
    if (_remoteRenderers.isEmpty) {
      allTiles[1] = Center(
        child: Text(
          'Waiting for others to join...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.groupName} Video Call'),
        backgroundColor: Colors.blue.shade700,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: GridView.count(crossAxisCount: 2, children: allTiles),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildVideoTile(
    RTCVideoRenderer renderer,
    String name, {
    bool isMe = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RTCVideoView(renderer, mirror: isMe),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isMe ? Icons.person : Icons.people,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isMe ? 'You' : name,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTile() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(Icons.person_outline, size: 48, color: Colors.white70),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(_micOn ? Icons.mic : Icons.mic_off, color: Colors.blue),
            onPressed: () {
              setState(() => _micOn = !_micOn);
              // TODO: Mute/unmute local audio track
            },
          ),
          IconButton(
            icon: Icon(
              _videoOn ? Icons.videocam : Icons.videocam_off,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() => _videoOn = !_videoOn);
              // TODO: Enable/disable local video track
            },
          ),
          IconButton(
            icon: const Icon(Icons.screen_share, color: Colors.blue),
            onPressed: () {
              // TODO: Implement screen sharing
            },
          ),
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: () {
              setState(() => _inCall = false);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
