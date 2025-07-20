import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';
import 'package:skillwave/features/study_groups/domain/repository/group_chat_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GroupChatRealtimeStreamUseCase {
  final GroupChatRepository repository;
  GroupChatRealtimeStreamUseCase(this.repository);

  Stream<GroupMessageEntity> call() => repository.newGroupMessageStream;
}
