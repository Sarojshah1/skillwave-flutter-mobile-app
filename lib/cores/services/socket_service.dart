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

  // Getters for streams
  Stream<Map<String, dynamic>> get newCommentStream =>
      _newCommentController.stream;
  Stream<Map<String, dynamic>> get newReplyStream => _newReplyController.stream;

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

    // Real-time events
    _socket!.on('new-comment', (data) {
      _logger.i('💬 New comment received: $data');
      _newCommentController.add(data);
    });

    _socket!.on('new-reply', (data) {
      _logger.i('💬 New reply received: $data');
      _newReplyController.add(data);
    });

    // Forum post specific events
    _socket!.on('joinedForumPost', (data) {
      _logger.i('Joined forum post: $data');
    });

    _socket!.on('leftForumPost', (data) {
      _logger.i('Left forum post: $data');
    });

    _socket!.on('userCommentTyping', (data) {
      _logger.i('User typing comment: $data');
    });

    _socket!.on('userReplyTyping', (data) {
      _logger.i('User typing reply: $data');
    });

    // Error handling
    _socket!.onError((error) {
      _logger.e('Socket error: $error');
    });
  }

  void _connect() {
    if (_socket != null && !_isConnected) {
      _logger.i('🔌 Attempting to connect to socket...');
      _socket!.connect();
    }
  }

  void disconnect() {
    if (_socket != null) {
      _logger.i('🔌 Disconnecting socket...');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
  }

  // Join a specific post room to listen for updates
  Future<void> joinPostRoom(String postId) async {
    if (_socket != null && _isConnected) {
      final userIdResult = await _userPrefs.getUserId();
      final userId = userIdResult.fold(
        (_) => 'anonymous',
        (id) => id ?? 'anonymous',
      );

      _socket!.emit('joinForumPost', {'postId': postId, 'userId': userId});
      _logger.i('Joined forum post room: $postId with userId: $userId');
    } else {
      _logger.w('⚠️ Cannot join post room: Socket not connected');
    }
  }

  // Leave a specific post room
  Future<void> leavePostRoom(String postId) async {
    if (_socket != null && _isConnected) {
      final userIdResult = await _userPrefs.getUserId();
      final userId = userIdResult.fold(
        (_) => 'anonymous',
        (id) => id ?? 'anonymous',
      );

      _socket!.emit('leaveForumPost', {'postId': postId, 'userId': userId});
      _logger.i('Left forum post room: $postId with userId: $userId');
    } else {
      _logger.w('⚠️ Cannot leave post room: Socket not connected');
    }
  }

  // Emit events (for testing or manual updates)
  void emitNewComment(String postId, Map<String, dynamic> commentData) {
    if (_socket != null && _isConnected) {
      _socket!.emit('new-comment', {'postId': postId, 'comment': commentData});
    }
  }

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
  }
}
