import 'package:equatable/equatable.dart';

class GroupMessageEntity extends Equatable {
  final String id;
  final String contextType;
  final String contextId;
  final SenderEntity sender;
  final String messageContent;
  final DateTime sentAt;

  const GroupMessageEntity({
    required this.id,
    required this.contextType,
    required this.contextId,
    required this.sender,
    required this.messageContent,
    required this.sentAt,
  });

  @override
  List<Object> get props => [id, contextType, contextId, sender, messageContent, sentAt];
}

class SenderEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profilePicture;

  const SenderEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  @override
  List<Object> get props => [id, name, email, profilePicture];
}
