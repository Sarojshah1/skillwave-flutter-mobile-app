import 'package:skillwave/features/study_groups/data/datasource/group_chat_realtime_datasource.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';
import 'package:skillwave/features/study_groups/domain/repository/group_chat_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GroupChatRepository)
class GroupChatRepositoryImpl implements GroupChatRepository {
  final GroupChatRealtimeDatasource datasource;

  GroupChatRepositoryImpl(this.datasource);

  @override
  Future<GroupMessageEntity> sendGroupMessageApi({
    required String groupId,
    required String messageContent,
  }) {
    return datasource.sendGroupMessageApi(
      groupId: groupId,
      messageContent: messageContent,
    );
  }

  @override
  Future<List<GroupMessageEntity>> getGroupChatMessagesApi(String groupId) {
    return datasource.getGroupChatMessagesApi(groupId);
  }

  @override
  Future<void> sendGroupMessageRealtime({
    required String groupId,
    required String userId,
    required String messageContent,
    String messageType = 'text',
  }) {
    return datasource.sendGroupMessageRealtime(
      groupId: groupId,
      userId: userId,
      messageContent: messageContent,
      messageType: messageType,
    );
  }

  @override
  Stream<GroupMessageEntity> get newGroupMessageStream =>
      datasource.newGroupMessageStream;
}
