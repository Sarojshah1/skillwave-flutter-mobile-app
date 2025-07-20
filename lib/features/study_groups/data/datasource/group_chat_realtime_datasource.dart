import 'package:dio/dio.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/cores/services/socket_service.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/features/study_groups/data/model/group_message_model.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';

@LazySingleton()
class GroupChatRealtimeDatasource {
  final SocketService _socketService;
  final Dio _dio;
  final UserSharedPrefs _userSharedPrefs;

  GroupChatRealtimeDatasource(
    this._socketService,
    this._dio,
    this._userSharedPrefs,
  );

  // Join a group chat room (realtime)
  Future<void> joinGroupRoom(String groupId) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User ID not found in shared prefs');
    await _socketService.joinRoom(groupId, userId);
  }

  // Leave a group chat room (realtime)
  Future<void> leaveGroupRoom(String groupId) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User ID not found in shared prefs');
    await _socketService.leaveRoom(groupId, userId);
  }

  // Send a message to the group chat room (realtime)
  Future<void> sendGroupMessageRealtime({
    required String groupId,
    required String userId,
    required String messageContent,
    String messageType = 'text',
  }) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User ID not found in shared prefs');
    await _socketService.sendGroupMessage(
      groupId,
      userId,
      messageContent,
      messageType: messageType,
    );
  }

  // Send a message to the group chat room (HTTP API)
  Future<GroupMessageEntity> sendGroupMessageApi({
    required String groupId,
    required String messageContent,
  }) async {
    try {
      final data = {
        'context_type': 'GroupStudy',
        'context_id': groupId,
        'message_content': messageContent,
      };
      final response = await _dio.post(
        ApiEndpoints.sendChatMessage,
        data: data,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return GroupMessageModel.fromJson(response.data).toEntity();
      } else {
        throw Exception(
          'Failed to send message via API. Status code: \\${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: \\${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Fetch chat messages for a group (HTTP API)
  Future<List<GroupMessageEntity>> getGroupChatMessagesApi(
    String groupId,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getChatMessagesByContext(groupId),
      );
      print('Response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => GroupMessageModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          'Failed to load messages. Status code: \\${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: \\${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Listen for new group messages in real time
  Stream<GroupMessageEntity> get newGroupMessageStream =>
      _socketService.newGroupMessageStream;

  Future<String?> _getUserId() async {
    final result = await _userSharedPrefs.getUserId();
    return result.fold((l) => null, (r) => r);
  }
}
