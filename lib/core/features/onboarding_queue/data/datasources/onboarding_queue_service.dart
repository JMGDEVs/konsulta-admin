import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:konsulta_admin/core/service/api_service/api_paths.dart';
import 'package:konsulta_admin/core/service/config/config_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@lazySingleton
class OnboardingQueueService {
  final Config config;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  OnboardingQueueService(@Named('devConfig') this.config);

  Future<List<ApplicantModel>> getPendingApplicants({
    String? search,
    String? professionalTag,
  }) async {
    final token = await _secureStorage.read(key: 'token');

    final queryParameters = {
      if (search != null && search.isNotEmpty) 'search': search,
      if (professionalTag != null && professionalTag.isNotEmpty)
        'professionalTag': professionalTag,
    };

    final uri = Uri.https(
      config.apiDomain,
      '${config.apiBasePath}${ApiPath.getPendingApplicants}',
      queryParameters,
    );

    // Debug logging
    print('🔹 [GET Pending] $uri');
    print('🔸 Query Parameters: $queryParameters');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Debug logging
    print('🔹 [HTTP ${response.statusCode}] Pending Response');
    final responsePreview = response.body.length > 200
        ? '${response.body.substring(0, 200)}...'
        : response.body;
    print('🔸 Response Body: $responsePreview');

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      List<dynamic> data;

      if (decoded is Map && decoded.containsKey('data')) {
        final dataObj = decoded['data'];
        if (dataObj is Map && dataObj.containsKey('applicants')) {
          // Swagger API returns: { success, message, data: { applicants: [...] } }
          data = dataObj['applicants'] as List<dynamic>;
        } else if (dataObj is List) {
          // Fallback: data is directly a list
          data = dataObj;
        } else {
          data = [];
        }
      } else if (decoded is List) {
        // Fallback: response is directly a list
        data = decoded;
      } else {
        data = [];
      }

      return data.map((json) => ApplicantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pending applicants');
    }
  }

  Future<List<ApplicantModel>> getUnderReviewApplicants({
    String? search,
    String? professionalTag,
    int? adminUserId,
  }) async {
    final token = await _secureStorage.read(key: 'token');

    final queryParameters = {
      if (search != null && search.isNotEmpty) 'search': search,
      if (professionalTag != null && professionalTag.isNotEmpty)
        'professionalTag': professionalTag,
      if (adminUserId != null) 'admin_user_id': adminUserId.toString(),
    };

    final uri = Uri.https(
      config.apiDomain,
      '${config.apiBasePath}${ApiPath.getUnderReviewApplicants}',
      queryParameters,
    );

    // Debug logging
    print('🔹 [GET Under Review] $uri');
    print('🔸 Query Parameters: $queryParameters');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Debug logging
    print('🔹 [HTTP ${response.statusCode}] Under Review Response');
    final responsePreview = response.body.length > 200
        ? '${response.body.substring(0, 200)}...'
        : response.body;
    print('🔸 Response Body: $responsePreview');

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      List<dynamic> data;

      if (decoded is Map && decoded.containsKey('data')) {
        final dataObj = decoded['data'];
        if (dataObj is Map && dataObj.containsKey('applicants')) {
          // Swagger API returns: { success, message, data: { applicants: [...] } }
          data = dataObj['applicants'] as List<dynamic>;
        } else if (dataObj is List) {
          // Fallback: data is directly a list
          data = dataObj;
        } else {
          data = [];
        }
      } else if (decoded is List) {
        // Fallback: response is directly a list
        data = decoded;
      } else {
        data = [];
      }

      return data.map((json) => ApplicantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load under review applicants');
    }
  }

  Future<bool> startReview(String applicantId) async {
    final token = await _secureStorage.read(key: 'token');

    final uri = Uri.https(
      config.apiDomain,
      '${config.apiBasePath}${ApiPath.startReview}',
    );

    // Swagger API expects POST request body with applicantId
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'applicantId': applicantId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to start review');
    }
  }
}
