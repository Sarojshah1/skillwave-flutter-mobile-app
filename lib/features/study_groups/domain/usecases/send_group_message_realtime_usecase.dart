import 'package:skillwave/features/study_groups/domain/repository/group_chat_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SendGroupMessageRealtimeUseCase {
  final GroupChatRepository repository;
  SendGroupMessageRealtimeUseCase(this.repository);

  Future<void> call({
    required String groupId,
    required String userId,
    required String messageContent,
    String messageType = 'text',
  }) {
    return repository.sendGroupMessageRealtime(
      groupId: groupId,
      userId: userId,
      messageContent: messageContent,
      messageType: messageType,
    );
  }
}
