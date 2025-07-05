import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/cores/failure/failure.dart';
import '../models/post_model.dart';
import '../models/post_dto.dart';
import '../../domin/entity/post_entity.dart';

@LazySingleton()
class DashboardRemoteDatasource {
  final Dio dio;
  DashboardRemoteDatasource({required this.dio});

  Future<PostsResponseEntity> getPosts(GetPostsDto dto) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getPost,
        queryParameters: dto.toJson(),
      );
      return PostsResponseModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }

  Future<PostEntity> getPostById(String id) async {
    try {
      final response = await dio.get("${ApiEndpoints.getPost}/$id");
      return PostModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }

  Future<void> createPost(CreatePostDto dto, {List<File>? images}) async {
    try {
      FormData formData;

      if (images != null && images.isNotEmpty) {
        // Create FormData with images
        Map<String, dynamic> fields = {
          'title': dto.title,
          'content': dto.content,
          'tags': dto.tags.join(','),
          'category': dto.category,
        };

        // Add images to FormData
        List<MultipartFile> imageFiles = [];
        for (int i = 0; i < images.length; i++) {
          imageFiles.add(
            await MultipartFile.fromFile(
              images[i].path,
              filename: images[i].path.split('/').last,
            ),
          );
        }
        fields['images'] = imageFiles;

        formData = FormData.fromMap(fields);
      } else {
        // Create FormData without images
        formData = FormData.fromMap({
          'title': dto.title,
          'content': dto.content,
          'tags': dto.tags.join(','),
          'category': dto.category,
        });
      }
      print(formData.fields);

      final response = await dio.post(
        ApiEndpoints.createPost,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }

  Future<PostEntity> updatePost(String id, UpdatePostDto dto) async {
    try {
      final response = await dio.put(
        "${ApiEndpoints.getPost}/$id",
        data: dto.toJson(),
      );
      return PostModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await dio.delete("${ApiEndpoints.getPost}/$id");
    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await dio.post(ApiEndpoints.getpostlikeUrl(postId));
    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }

  Future<void> createComment(String postId, CreateCommentDto dto) async {
    print(dto.toJson());
    try {
      await dio.post(
        ApiEndpoints.getpostcommentUrl(postId),
        data: dto.toJson(),
      );
    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }

  Future<void> createReply(
    String postId,
    String commentId,
    CreateReplyDto dto,
  ) async {
    try {
      await dio.post(
        ApiEndpoints.getpostcommentReplyUrl(postId, commentId),
        data: dto.toJson(),
      );
    } on DioException catch (e) {
      throw ApiFailure(message: e.message.toString());
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }
}
