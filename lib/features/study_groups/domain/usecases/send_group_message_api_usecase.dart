import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';
import 'package:skillwave/features/study_groups/domain/repository/group_chat_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SendGroupMessageApiUseCase {
  final GroupChatRepository repository;
  SendGroupMessageApiUseCase(this.repository);

  Future<GroupMessageEntity> call({
    required String groupId,
    required String messageContent,
  }) {
    return repository.sendGroupMessageApi(
      groupId: groupId,
      messageContent: messageContent,
    );
  }
}
