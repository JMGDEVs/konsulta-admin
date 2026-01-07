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
    String? searchQuery,
    String? professionId,
    int? pageNumber,
    int? pageSize,
  }) async {
    final token = await _secureStorage.read(key: 'token');

    final queryParameters = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionId': professionId,
      if (pageNumber != null) 'pageNumber': pageNumber.toString(),
      if (pageSize != null) 'pageSize': pageSize.toString(),
    };

    final uri = Uri.https(
      config.apiDomain,
      '${config.apiBasePath}${ApiPath.getPendingApplicants}',
      queryParameters,
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

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
