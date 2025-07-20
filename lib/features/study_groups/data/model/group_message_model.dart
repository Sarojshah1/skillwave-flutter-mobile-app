import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';

part 'group_message_model.freezed.dart';
part 'group_message_model.g.dart';

@freezed
class GroupMessageModel with _$GroupMessageModel {
  const factory GroupMessageModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'context_type') required String contextType,
    @JsonKey(name: 'context_id') required String contextId,
    @JsonKey(name: 'sender_id') required SenderModel sender,
    @JsonKey(name: 'message_content') required String messageContent,
    @JsonKey(name: 'sent_at') required DateTime sentAt,
  }) = _GroupMessageModel;

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMessageModelFromJson(json);

  // Add a custom mapper for socket payloads
  static GroupMessageModel fromSocket(Map<String, dynamic> json) {
    // If the keys are from the socket event
    if (json.containsKey('group_id') &&
        json.containsKey('sender') &&
        json.containsKey('message')) {
      return GroupMessageModel(
        id: json['_id'] ?? '',
        contextType: 'group',
        contextId: json['group_id'] ?? '',
        sender: SenderModel(
          id: json['sender']['_id'] ?? '',
          name: json['sender']['name'] ?? '',
          email: json['sender']['email'] ?? '', // fallback if present
          profilePicture: json['sender']['profile_picture'] ?? '',
        ),
        messageContent: json['message'] ?? '',
        sentAt: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      );
    }
    // Otherwise, fallback to the default fromJson
    return GroupMessageModel.fromJson(json);
  }
}

@freezed
class SenderModel with _$SenderModel {
  const factory SenderModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    @JsonKey(name: 'profile_picture') required String profilePicture,
  }) = _SenderModel;

  factory SenderModel.fromJson(Map<String, dynamic> json) =>
      _$SenderModelFromJson(json);
}

extension GroupMessageMapper on GroupMessageModel {
  GroupMessageEntity toEntity() => GroupMessageEntity(
    id: id,
    contextType: contextType,
    contextId: contextId,
    sender: sender.toEntity(),
    messageContent: messageContent,
    sentAt: sentAt,
  );
}

extension SenderMapper on SenderModel {
  SenderEntity toEntity() => SenderEntity(
    id: id,
    name: name,
    email: email,
    profilePicture: profilePicture,
  );
}

// Reverse mapping (optional)
extension GroupMessageEntityMapper on GroupMessageEntity {
  GroupMessageModel toModel() => GroupMessageModel(
    id: id,
    contextType: contextType,
    contextId: contextId,
    sender: sender.toModel(),
    messageContent: messageContent,
    sentAt: sentAt,
  );
}

extension SenderEntityMapper on SenderEntity {
  SenderModel toModel() => SenderModel(
    id: id,
    name: name,
    email: email,
    profilePicture: profilePicture,
  );
}
