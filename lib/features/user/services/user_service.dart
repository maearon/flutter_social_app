// lib/features/user/services/user_service.dart

import 'package:flutter_social_app/core/models/api_response.dart';
import 'package:flutter_social_app/core/models/user.dart';
import 'package:flutter_social_app/core/models/user_request.dart'; // ✅ Import mới
import 'package:flutter_social_app/core/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<UserListResponse> getUsers({ListParams params = const ListParams()}) async {
    final queryParams = <String, dynamic>{};

    if (params.page != null) {
      queryParams['page'] = params.page.toString();
    }

    queryParams.addAll(params.additionalParams);

    final response = await _apiService.get<Map<String, dynamic>>(
      'users',
      queryParameters: queryParams,
    );

    return UserListResponse.fromJson(response);
  }

  // ✅ Sửa hàm getUser để dùng UserRequest thay vì ListParams hoặc Map
  Future<UserShowResponse> getUser(String id, UserRequest request) async {
    final queryParams = request.toJson();

    final response = await _apiService.get<Map<String, dynamic>>(
      'users/$id',
      queryParameters: queryParams,
    );

    return UserShowResponse.fromJson(response);
  }

  Future<UserEditResponse> editUser(String id) async {
    final response = await _apiService.get<Map<String, dynamic>>('users/$id/edit');
    return UserEditResponse.fromJson(response);
  }

  Future<UserUpdateResponse> updateUser(String id, UserUpdateParams params) async {
    final response = await _apiService.patch<Map<String, dynamic>>(
      'users/$id',
      data: {'user': params.toJson()},
    );

    return UserUpdateResponse.fromJson(response);
  }

  Future<UserCreateResponse> createUser(UserCreateParams params) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      'users',
      data: {'user': params.toJson()},
    );

    return UserCreateResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> deleteUser(String id) async {
    return await _apiService.delete<Map<String, dynamic>>('users/$id');
  }

  Future<FollowResponse> getFollowers(String id, int page) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      'users/$id/followers',
      queryParameters: {'page': page.toString()},
    );

    return FollowResponse.fromJson(response);
  }

  Future<FollowResponse> getFollowing(String id, int page) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      'users/$id/following',
      queryParameters: {'page': page.toString()},
    );

    return FollowResponse.fromJson(response);
  }
}
