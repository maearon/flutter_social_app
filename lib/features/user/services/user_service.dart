// lib/features/user/services/user_service.dart

import 'package:flutter_social_app/core/models/api_response.dart';
import 'package:flutter_social_app/core/models/user.dart';
import 'package:flutter_social_app/core/models/user_request.dart';
import 'package:flutter_social_app/core/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<UserListResponse> getUsers({ListParams params = const ListParams()}) async {
    final queryParams = <String, dynamic>{};

    if (params.page != null) {
      queryParams['page'] = params.page.toString();
    }

    queryParams.addAll(params.additionalParams);

    final apiResponse = await _apiService.get<ApiResponse<UserListResponse>>(
      'users',
      queryParameters: queryParams,
      fromJson: (json) => ApiResponse<UserListResponse>.fromJson(
        json,
        (data) => UserListResponse.fromJson(data),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to fetch users: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }

  Future<UserShowResponse> getUser(String id, UserRequest request) async {
    final queryParams = request.toJson();

    final apiResponse = await _apiService.get<ApiResponse<UserShowResponse>>(
      'users/$id',
      queryParameters: queryParams,
      fromJson: (json) => ApiResponse<UserShowResponse>.fromJson(
        json,
        (data) => UserShowResponse.fromJson(data),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to fetch user: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }

  Future<UserEditResponse> editUser(String id) async {
    final apiResponse = await _apiService.get<ApiResponse<UserEditResponse>>(
      'users/$id/edit',
      fromJson: (json) => ApiResponse<UserEditResponse>.fromJson(
        json,
        (data) => UserEditResponse.fromJson(data),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to fetch edit user: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }

  Future<UserUpdateResponse> updateUser(String id, UserUpdateParams params) async {
    final apiResponse = await _apiService.patch<ApiResponse<UserUpdateResponse>>(
      'users/$id',
      data: {'user': params.toJson()},
      fromJson: (json) => ApiResponse<UserUpdateResponse>.fromJson(
        json,
        (data) => UserUpdateResponse.fromJson(data),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to update user: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }

  Future<UserCreateResponse> createUser(UserCreateParams params) async {
    final apiResponse = await _apiService.post<ApiResponse<UserCreateResponse>>(
      'users',
      data: {'user': params.toJson()},
      fromJson: (json) => ApiResponse<UserCreateResponse>.fromJson(
        json,
        (data) => UserCreateResponse.fromJson(data),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to create user: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }

  Future<Map<String, dynamic>> deleteUser(String id) async {
    final apiResponse = await _apiService.delete<ApiResponse<Map<String, dynamic>>>(
      'users/$id',
      fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (data) => data,
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to delete user: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }

  Future<FollowResponse> getFollowers(String id, int page) async {
    final apiResponse = await _apiService.get<ApiResponse<FollowResponse>>(
      'users/$id/followers',
      queryParameters: {'page': page.toString()},
      fromJson: (json) => ApiResponse<FollowResponse>.fromJson(
        json,
        (data) => FollowResponse.fromJson(data),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to fetch followers: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }

  Future<FollowResponse> getFollowing(String id, int page) async {
    final apiResponse = await _apiService.get<ApiResponse<FollowResponse>>(
      'users/$id/following',
      queryParameters: {'page': page.toString()},
      fromJson: (json) => ApiResponse<FollowResponse>.fromJson(
        json,
        (data) => FollowResponse.fromJson(data),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to fetch following: ${apiResponse.error ?? 'Unknown error'}');
    }

    return apiResponse.data!;
  }
}
