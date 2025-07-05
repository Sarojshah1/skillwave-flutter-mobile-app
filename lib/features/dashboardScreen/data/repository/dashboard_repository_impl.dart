import 'dart:io';
import 'package:injectable/injectable.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../../domin/repository/dashboard_repository.dart';
import '../models/post_dto.dart';
import '../../domin/entity/post_entity.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource datasource;

  DashboardRepositoryImpl(this.datasource);

  @override
  Future<PostsResponseEntity> getPosts(GetPostsDto dto) async {
    return await datasource.getPosts(dto);
  }

  @override
  Future<PostEntity> getPostById(String id) async {
    return await datasource.getPostById(id);
  }

  @override
  Future<void> createPost(CreatePostDto dto, {List<File>? images}) async {
    return await datasource.createPost(dto, images: images);
  }

  @override
  Future<PostEntity> updatePost(String id, UpdatePostDto dto) async {
    return await datasource.updatePost(id, dto);
  }

  @override
  Future<void> deletePost(String id) async {
    return await datasource.deletePost(id);
  }

  @override
  Future<void> likePost(String postId) async {
    return await datasource.likePost(postId);
  }

  @override
  Future<void> createComment(String postId, CreateCommentDto dto) async {
    return await datasource.createComment(postId, dto);
  }

  @override
  Future<void> createReply(
    String postId,
    String commentId,
    CreateReplyDto dto,
  ) async {
    return await datasource.createReply(postId, commentId, dto);
  }


}
