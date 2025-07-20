import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';
import 'package:skillwave/features/study_groups/domain/repository/group_chat_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetGroupChatMessagesApiUseCase {
  final GroupChatRepository repository;
  GetGroupChatMessagesApiUseCase(this.repository);

  Future<List<GroupMessageEntity>> call(String groupId) {
    return repository.getGroupChatMessagesApi(groupId);
  }
}
