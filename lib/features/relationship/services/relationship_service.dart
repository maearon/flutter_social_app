import 'package:flutter_social_app/core/models/api_response.dart';
import 'package:flutter_social_app/core/services/api_service.dart';

class RelationshipService {
  final ApiService _apiService = ApiService();

  Future<CreateRelationshipResponse> followUser(String followedId) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      'relationships',
      data: {'followed_id': followedId},
    );
    
    return CreateRelationshipResponse.fromJson(response);
  }

  Future<DestroyRelationshipResponse> unfollowUser(String id) async {
    final response = await _apiService.delete<Map<String, dynamic>>('relationships/$id');
    return DestroyRelationshipResponse.fromJson(response);
  }
}
