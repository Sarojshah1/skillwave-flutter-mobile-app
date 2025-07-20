import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';



abstract class GroupChatRepository {
  Future<GroupMessageEntity> sendGroupMessageApi({
    required String groupId,
    required String messageContent,
  });
  Future<List<GroupMessageEntity>> getGroupChatMessagesApi(String groupId);
  Future<void> sendGroupMessageRealtime({
    required String groupId,
    required String userId,
    required String messageContent,
    String messageType,
  });
  Stream<GroupMessageEntity> get newGroupMessageStream;
}
