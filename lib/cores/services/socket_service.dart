import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';
import 'package:skillwave/config/di/di.container.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  final Logger _logger = Logger();
  bool _isConnected = false;
  final UserSharedPrefs _userPrefs = getIt<UserSharedPrefs>();

  // Stream controllers for real-time updates
  final StreamController<Map<String, dynamic>> _newCommentController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _newReplyController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _newMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _newGroupMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _newDirectMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _userJoinedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _userLeftController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _audioToggledController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _videoToggledController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _screenShareToggledController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _userTypingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _userStoppedTypingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _callIncomingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _callAcceptedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _callRejectedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _callEndedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _offerController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _answerController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _iceCandidateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _joinedRoomController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _roomParticipantsController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _errorController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _pushTokenUpdatedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _pushTokenErrorController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _messageSentController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Getters for streams
  Stream<Map<String, dynamic>> get newCommentStream =>
      _newCommentController.stream;
  Stream<Map<String, dynamic>> get newReplyStream => _newReplyController.stream;
  Stream<Map<String, dynamic>> get newMessageStream =>
      _newMessageController.stream;
  Stream<Map<String, dynamic>> get newGroupMessageStream =>
      _newGroupMessageController.stream;
  Stream<Map<String, dynamic>> get newDirectMessageStream =>
      _newDirectMessageController.stream;
  Stream<Map<String, dynamic>> get userJoinedStream =>
      _userJoinedController.stream;
  Stream<Map<String, dynamic>> get userLeftStream => _userLeftController.stream;
  Stream<Map<String, dynamic>> get audioToggledStream =>
      _audioToggledController.stream;
  Stream<Map<String, dynamic>> get videoToggledStream =>
      _videoToggledController.stream;
  Stream<Map<String, dynamic>> get screenShareToggledStream =>
      _screenShareToggledController.stream;
  Stream<Map<String, dynamic>> get userTypingStream =>
      _userTypingController.stream;
  Stream<Map<String, dynamic>> get userStoppedTypingStream =>
      _userStoppedTypingController.stream;
  Stream<Map<String, dynamic>> get callIncomingStream =>
      _callIncomingController.stream;
  Stream<Map<String, dynamic>> get callAcceptedStream =>
      _callAcceptedController.stream;
  Stream<Map<String, dynamic>> get callRejectedStream =>
      _callRejectedController.stream;
  Stream<Map<String, dynamic>> get callEndedStream =>
      _callEndedController.stream;
  Stream<Map<String, dynamic>> get offerStream => _offerController.stream;
  Stream<Map<String, dynamic>> get answerStream => _answerController.stream;
  Stream<Map<String, dynamic>> get iceCandidateStream =>
      _iceCandidateController.stream;
  Stream<Map<String, dynamic>> get joinedRoomStream =>
      _joinedRoomController.stream;
  Stream<Map<String, dynamic>> get roomParticipantsStream =>
      _roomParticipantsController.stream;
  Stream<Map<String, dynamic>> get errorStream => _errorController.stream;
  Stream<Map<String, dynamic>> get pushTokenUpdatedStream =>
      _pushTokenUpdatedController.stream;
  Stream<Map<String, dynamic>> get pushTokenErrorStream =>
      _pushTokenErrorController.stream;
  Stream<Map<String, dynamic>> get messageSentStream =>
      _messageSentController.stream;

  bool get isConnected => _isConnected;

  // Initialize socket connection
  void initializeSocket(String baseUrl, String? token) {
    try {
      // Remove /api from baseUrl for socket connection
      final socketUrl = baseUrl.replaceAll('/api', '');

      _logger.i('🔌 Initializing socket connection to: $socketUrl');

      _socket = IO.io(socketUrl, <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'auth': {'token': token},
        'forceNew': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
      });

      _setupSocketListeners();
      _connect();
    } catch (e) {
      _logger.e('Error initializing socket: $e');
    }
  }

  void _setupSocketListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      _logger.i('✅ Socket connected successfully to backend');
      _isConnected = true;
    });

    _socket!.onDisconnect((_) {
      _logger.i('❌ Socket disconnected from backend');
      _isConnected = false;
    });

    _socket!.onConnectError((error) {
      _logger.e('🚨 Socket connection error: $error');
      _isConnected = false;
    });

    _socket!.onReconnect((_) {
      _logger.i('🔄 Socket reconnected to backend');
      _isConnected = true;
    });

    _socket!.onReconnectAttempt((attemptNumber) {
      _logger.i('🔄 Socket reconnection attempt: $attemptNumber');
    });

    _socket!.onReconnectError((error) {
      _logger.e('🚨 Socket reconnection error: $error');
      _isConnected = false;
    });

    _socket!.onReconnectFailed((_) {
      _logger.e('🚨 Socket reconnection failed');
      _isConnected = false;
    });

    // Room management events
    _socket!.on('joinedRoom', (data) {
      _logger.i('✅ Joined room: $data');
      _joinedRoomController.add(data);
    });

    _socket!.on('userJoined', (data) {
      _logger.i('👤 User joined: $data');
      _userJoinedController.add(data);
    });

    _socket!.on('userLeft', (data) {
      _logger.i('👤 User left: $data');
      _userLeftController.add(data);
    });

    // Media control events
    _socket!.on('audioToggled', (data) {
      _logger.i('🔊 Audio toggled: $data');
      _audioToggledController.add(data);
    });

    _socket!.on('videoToggled', (data) {
      _logger.i('📹 Video toggled: $data');
      _videoToggledController.add(data);
    });

    _socket!.on('screenShareToggled', (data) {
      _logger.i('🖥️ Screen share toggled: $data');
      _screenShareToggledController.add(data);
    });

    // Chat events
    _socket!.on('newMessage', (data) {
      _logger.i('💬 New message: $data');
      _newMessageController.add(data);
    });

    _socket!.on('newGroupMessage', (data) {
      _logger.i('💬 New group message: $data');
      _newGroupMessageController.add(data);
    });

    _socket!.on('newDirectMessage', (data) {
      _logger.i('💬 New direct message: $data');
      _newDirectMessageController.add(data);
    });

    _socket!.on('userTyping', (data) {
      _logger.i('⌨️ User typing: $data');
      _userTypingController.add(data);
    });

    _socket!.on('userStoppedTyping', (data) {
      _logger.i('⌨️ User stopped typing: $data');
      _userStoppedTypingController.add(data);
    });

    // Call events
    _socket!.on('callIncoming', (data) {
      _logger.i('📞 Call incoming: $data');
      _callIncomingController.add(data);
    });

    _socket!.on('callAccepted', (data) {
      _logger.i('📞 Call accepted: $data');
      _callAcceptedController.add(data);
    });

    _socket!.on('callRejected', (data) {
      _logger.i('📞 Call rejected: $data');
      _callRejectedController.add(data);
    });

    _socket!.on('callEnded', (data) {
      _logger.i('📞 Call ended: $data');
      _callEndedController.add(data);
    });

    // WebRTC signaling events
    _socket!.on('offer', (data) {
      _logger.i('📡 WebRTC offer: $data');
      _offerController.add(data);
    });

    _socket!.on('answer', (data) {
      _logger.i('📡 WebRTC answer: $data');
      _answerController.add(data);
    });

    _socket!.on('ice-candidate', (data) {
      _logger.i('📡 ICE candidate: $data');
      _iceCandidateController.add(data);
    });

    // Room participants
    _socket!.on('roomParticipants', (data) {
      _logger.i('👥 Room participants: $data');
      _roomParticipantsController.add(data);
    });

    // Push notification events
    _socket!.on('pushTokenUpdated', (data) {
      _logger.i('📱 Push token updated: $data');
      _pushTokenUpdatedController.add(data);
    });

    _socket!.on('pushTokenError', (data) {
      _logger.e('📱 Push token error: $data');
      _pushTokenErrorController.add(data);
    });

    // Message confirmation
    _socket!.on('messageSent', (data) {
      _logger.i('✅ Message sent: $data');
      _messageSentController.add(data);
    });

    // Forum events (keeping for backward compatibility)
    _socket!.on('new-comment', (data) {
      _logger.i('💬 New comment received: $data');
      _newCommentController.add(data);
    });

    _socket!.on('new-reply', (data) {
      _logger.i('💬 New reply received: $data');
      _newReplyController.add(data);
    });

    // Error handling
    _socket!.onError((error) {
      _logger.e('Socket error: $error');
      _errorController.add({'error': error.toString()});
    });

    _socket!.on('error', (data) {
      _logger.e('Server error: $data');
      _errorController.add(data);
    });
  }

  void _connect() {
    if (_socket != null && !_isConnected) {
      _logger.i('🔌 Attempting to connect to socket...');
      try {
        _socket!.connect();
      } catch (e) {
        _logger.e('Error connecting to socket: $e');
      }
    }
  }

  // Check if socket is ready for operations
  bool get isReady => _socket != null && _isConnected;

  // Attempt to reconnect if disconnected
  void attemptReconnect() {
    if (_socket != null && !_isConnected) {
      _logger.i('🔄 Attempting to reconnect socket...');
      _connect();
    }
  }

  void disconnect() {
    if (_socket != null) {
      try {
        _logger.i('🔌 Disconnecting socket...');
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
        _isConnected = false;
        _logger.i('🔌 Socket disconnected successfully');
      } catch (e) {
        _logger.e('Error disconnecting socket: $e');
        _socket = null;
        _isConnected = false;
      }
    }
  }

  // ========== ROOM MANAGEMENT ==========

  // Join a room
  Future<void> joinRoom(String contextId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('joinRoom', {'context_id': contextId, 'userId': userId});
        _logger.i('Joined room: $contextId with userId: $userId');
      } catch (e) {
        _logger.e('Error joining room: $e');
      }
    } else {
      _logger.w('⚠️ Cannot join room: Socket not connected');
    }
  }

  // Leave a room
  Future<void> leaveRoom(String contextId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('leaveRoom', {'context_id': contextId, 'userId': userId});
        _logger.i('Left room: $contextId with userId: $userId');
      } catch (e) {
        _logger.e('Error leaving room: $e');
      }
    } else {
      _logger.w('⚠️ Cannot leave room: Socket not connected');
    }
  }

  // Get room participants
  Future<void> getRoomParticipants(String contextId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('getRoomParticipants', {
          'context_id': contextId,
          'userId': userId,
        });
        _logger.i('Getting participants for room: $contextId');
      } catch (e) {
        _logger.e('Error getting room participants: $e');
      }
    } else {
      _logger.w('⚠️ Cannot get room participants: Socket not connected');
    }
  }

  // ========== WEBRTC SIGNALING ==========

  // Send WebRTC offer
  Future<void> sendOffer(
    Map<String, dynamic> offer,
    String contextId,
    String userId, {
    String? targetSocketId,
  }) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('offer', {
          'offer': offer,
          'context_id': contextId,
          'userId': userId,
          if (targetSocketId != null) 'targetSocketId': targetSocketId,
        });
        _logger.i('Sent WebRTC offer to ${targetSocketId ?? 'room'}');
      } catch (e) {
        _logger.e('Error sending offer: $e');
      }
    } else {
      _logger.w('⚠️ Cannot send offer: Socket not connected');
    }
  }

  // Send WebRTC answer
  Future<void> sendAnswer(
    Map<String, dynamic> answer,
    String contextId,
    String userId, {
    String? targetSocketId,
  }) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('answer', {
          'answer': answer,
          'context_id': contextId,
          'userId': userId,
          if (targetSocketId != null) 'targetSocketId': targetSocketId,
        });
        _logger.i('Sent WebRTC answer to ${targetSocketId ?? 'room'}');
      } catch (e) {
        _logger.e('Error sending answer: $e');
      }
    } else {
      _logger.w('⚠️ Cannot send answer: Socket not connected');
    }
  }

  // Send ICE candidate
  Future<void> sendIceCandidate(
    Map<String, dynamic> candidate,
    String contextId,
    String userId, {
    String? targetSocketId,
  }) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('ice-candidate', {
          'candidate': candidate,
          'context_id': contextId,
          'userId': userId,
          if (targetSocketId != null) 'targetSocketId': targetSocketId,
        });
        _logger.i('Sent ICE candidate to ${targetSocketId ?? 'room'}');
      } catch (e) {
        _logger.e('Error sending ICE candidate: $e');
      }
    } else {
      _logger.w('⚠️ Cannot send ICE candidate: Socket not connected');
    }
  }

  // ========== MEDIA CONTROLS ==========

  // Toggle audio
  Future<void> toggleAudio(
    String contextId,
    String userId,
    bool isMuted,
  ) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('toggleAudio', {
          'context_id': contextId,
          'userId': userId,
          'isMuted': isMuted,
        });
        _logger.i('Toggled audio: ${isMuted ? 'muted' : 'unmuted'}');
      } catch (e) {
        _logger.e('Error toggling audio: $e');
      }
    } else {
      _logger.w('⚠️ Cannot toggle audio: Socket not connected');
    }
  }

  // Toggle video
  Future<void> toggleVideo(
    String contextId,
    String userId,
    bool isVideoOff,
  ) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('toggleVideo', {
          'context_id': contextId,
          'userId': userId,
          'isVideoOff': isVideoOff,
        });
        _logger.i('Toggled video: ${isVideoOff ? 'off' : 'on'}');
      } catch (e) {
        _logger.e('Error toggling video: $e');
      }
    } else {
      _logger.w('⚠️ Cannot toggle video: Socket not connected');
    }
  }

  // Toggle screen share
  Future<void> toggleScreenShare(
    String contextId,
    String userId,
    bool isScreenSharing,
  ) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('toggleScreenShare', {
          'context_id': contextId,
          'userId': userId,
          'isScreenSharing': isScreenSharing,
        });
        _logger.i(
          'Toggled screen share: ${isScreenSharing ? 'started' : 'stopped'}',
        );
      } catch (e) {
        _logger.e('Error toggling screen share: $e');
      }
    } else {
      _logger.w('⚠️ Cannot toggle screen share: Socket not connected');
    }
  }

  // ========== CHAT EVENTS ==========

  // Send message to room
  Future<void> sendMessage(
    String contextId,
    String userId,
    String message, {
    String messageType = 'text',
  }) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('sendMessage', {
          'context_id': contextId,
          'userId': userId,
          'message': message,
          'messageType': messageType,
        });
        _logger.i('Sent message to room: $contextId');
      } catch (e) {
        _logger.e('Error sending message: $e');
      }
    } else {
      _logger.w('⚠️ Cannot send message: Socket not connected');
    }
  }

  // Send direct message
  Future<void> sendDirectMessage(
    String recipientId,
    String userId,
    String message, {
    String messageType = 'text',
  }) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('sendDirectMessage', {
          'recipientId': recipientId,
          'userId': userId,
          'message': message,
          'messageType': messageType,
        });
        _logger.i('Sent direct message to: $recipientId');
      } catch (e) {
        _logger.e('Error sending direct message: $e');
      }
    } else {
      _logger.w('⚠️ Cannot send direct message: Socket not connected');
    }
  }

  // Send group message
  Future<void> sendGroupMessage(
    String groupId,
    String userId,
    String message, {
    String messageType = 'text',
  }) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('sendGroupMessage', {
          'groupId': groupId,
          'userId': userId,
          'message': message,
          'messageType': messageType,
        });
        _logger.i('Sent group message to: $groupId');
      } catch (e) {
        _logger.e('Error sending group message: $e');
      }
    } else {
      _logger.w('⚠️ Cannot send group message: Socket not connected');
    }
  }

  // Send typing indicator
  Future<void> sendTyping(String contextId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('typing', [contextId, userId]);
        _logger.i('Sent typing indicator');
      } catch (e) {
        _logger.e('Error sending typing indicator: $e');
      }
    } else {
      _logger.w('⚠️ Cannot send typing indicator: Socket not connected');
    }
  }

  // Stop typing indicator
  Future<void> stopTyping(String contextId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('stopTyping', {
          'context_id': contextId,
          'userId': userId,
        });
        _logger.i('Stopped typing indicator');
      } catch (e) {
        _logger.e('Error stopping typing indicator: $e');
      }
    } else {
      _logger.w('⚠️ Cannot stop typing indicator: Socket not connected');
    }
  }

  // ========== CALL EVENTS ==========

  // Incoming call
  Future<void> callIncoming(
    String contextId,
    String userId,
    String targetUserId,
  ) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('callIncoming', {
          'context_id': contextId,
          'userId': userId,
          'targetUserId': targetUserId,
        });
        _logger.i('Incoming call to: $targetUserId');
      } catch (e) {
        _logger.e('Error initiating call: $e');
      }
    } else {
      _logger.w('⚠️ Cannot initiate call: Socket not connected');
    }
  }

  // Accept call
  Future<void> callAccepted(
    String contextId,
    String userId,
    String callerId,
  ) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('callAccepted', {
          'context_id': contextId,
          'userId': userId,
          'callerId': callerId,
        });
        _logger.i('Call accepted from: $callerId');
      } catch (e) {
        _logger.e('Error accepting call: $e');
      }
    } else {
      _logger.w('⚠️ Cannot accept call: Socket not connected');
    }
  }

  // Reject call
  Future<void> callRejected(
    String contextId,
    String userId,
    String callerId,
  ) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('callRejected', {
          'context_id': contextId,
          'userId': userId,
          'callerId': callerId,
        });
        _logger.i('Call rejected from: $callerId');
      } catch (e) {
        _logger.e('Error rejecting call: $e');
      }
    } else {
      _logger.w('⚠️ Cannot reject call: Socket not connected');
    }
  }

  // End call
  Future<void> callEnded(String contextId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('callEnded', {'context_id': contextId, 'userId': userId});
        _logger.i('Call ended');
      } catch (e) {
        _logger.e('Error ending call: $e');
      }
    } else {
      _logger.w('⚠️ Cannot end call: Socket not connected');
    }
  }

  // Missed call
  Future<void> callMissed(
    String contextId,
    String userId,
    String targetUserId,
  ) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('callMissed', {
          'context_id': contextId,
          'userId': userId,
          'targetUserId': targetUserId,
        });
        _logger.i('Call missed by: $targetUserId');
      } catch (e) {
        _logger.e('Error reporting missed call: $e');
      }
    } else {
      _logger.w('⚠️ Cannot report missed call: Socket not connected');
    }
  }

  // ========== PUSH NOTIFICATION EVENTS ==========

  // Update push token
  Future<void> updatePushToken(String userId, String pushToken) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('updatePushToken', {
          'userId': userId,
          'pushToken': pushToken,
        });
        _logger.i('Updated push token for user: $userId');
      } catch (e) {
        _logger.e('Error updating push token: $e');
      }
    } else {
      _logger.w('⚠️ Cannot update push token: Socket not connected');
    }
  }

  // ========== FORUM EVENTS (Backward Compatibility) ==========

  // Join forum post room
  Future<void> joinForumPost(String postId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('joinForumPost', {'postId': postId, 'userId': userId});
        _logger.i('Joined forum post room: $postId with userId: $userId');
      } catch (e) {
        _logger.e('Error joining forum post room: $e');
      }
    } else {
      _logger.w('⚠️ Cannot join forum post room: Socket not connected');
    }
  }

  // Leave forum post room
  Future<void> leaveForumPost(String postId, String userId) async {
    if (_socket != null && _isConnected) {
      try {
        _socket!.emit('leaveForumPost', {'postId': postId, 'userId': userId});
        _logger.i('Left forum post room: $postId with userId: $userId');
      } catch (e) {
        _logger.e('Error leaving forum post room: $e');
      }
    } else {
      _logger.w('⚠️ Cannot leave forum post room: Socket not connected');
    }
  }

  // Emit new comment
  void emitNewComment(String postId, Map<String, dynamic> commentData) {
    if (_socket != null && _isConnected) {
      _socket!.emit('new-comment', {'postId': postId, 'comment': commentData});
    }
  }

  // Emit new reply
  void emitNewReply(
    String postId,
    String commentId,
    Map<String, dynamic> replyData,
  ) {
    if (_socket != null && _isConnected) {
      _socket!.emit('new-reply', {
        'postId': postId,
        'commentId': commentId,
        'reply': replyData,
      });
    }
  }

  // Dispose resources
  void dispose() {
    disconnect();
    _newCommentController.close();
    _newReplyController.close();
    _newMessageController.close();
    _newGroupMessageController.close();
    _newDirectMessageController.close();
    _userJoinedController.close();
    _userLeftController.close();
    _audioToggledController.close();
    _videoToggledController.close();
    _screenShareToggledController.close();
    _userTypingController.close();
    _userStoppedTypingController.close();
    _callIncomingController.close();
    _callAcceptedController.close();
    _callRejectedController.close();
    _callEndedController.close();
    _offerController.close();
    _answerController.close();
    _iceCandidateController.close();
    _joinedRoomController.close();
    _roomParticipantsController.close();
    _errorController.close();
    _pushTokenUpdatedController.close();
    _pushTokenErrorController.close();
    _messageSentController.close();
  }
}
