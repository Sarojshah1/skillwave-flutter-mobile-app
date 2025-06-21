import 'package:equatable/equatable.dart';
import 'package:skillwave/features/profileScreen/data/models/user_model.dart';


class BlogEntity extends Equatable {
  final String id;
  final UserModel userId;
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;

  const BlogEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId,title,tags,createdAt,content];
}