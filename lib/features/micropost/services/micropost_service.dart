import 'package:dio/dio.dart';
import 'package:flutter_social_app/core/models/api_response.dart';
import 'package:flutter_social_app/core/services/api_service.dart';

class MicropostService {
  final ApiService _apiService = ApiService();

  Future<MicropostListResponse> getMicroposts({int? page}) async {
    final queryParams = <String, dynamic>{};
    
    if (page != null) {
      queryParams['page'] = page.toString();
    }
    
    final response = await _apiService.get<Map<String, dynamic>>(
      '',
      queryParameters: queryParams,
    );
    
    return MicropostListResponse.fromJson(response);
  }

  Future<MicropostResponse> createMicropost(FormData formData) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      'microposts',
      data: formData,
    );
    
    return MicropostResponse.fromJson(response);
  }

  Future<MicropostResponse> deleteMicropost(int id) async {
    final response = await _apiService.delete<Map<String, dynamic>>('microposts/$id');
    return MicropostResponse.fromJson(response);
  }
}
