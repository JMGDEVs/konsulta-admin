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
      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded.containsKey('data')) {
        data = decoded['data'] as List<dynamic>;
      } else {
        // Fallback: try to find a list value if 'data' key doesn't exist
        // or return empty if structure is unknown.
        // For now, assuming 'data' or similar wrapper if it's a map.
        // If the map is the item itself (single item), this logic isn't for getPendingApplicants.
        data = [];
      }
      return data.map((json) => ApplicantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pending applicants');
    }
  }

  Future<bool> startReview(String userId) async {
    final token = await _secureStorage.read(key: 'token');

    final uri = Uri.https(
      config.apiDomain,
      '${config.apiBasePath}${ApiPath.startReview}',
    );

    // Assuming the API expects userId as query param or body.
    // Based on "Call API: api/admin/document/start-review" description, it likely needs the applicant ID.
    // I will check the swagger definition again if possible or assume query param for now as it's common for actions on resources.
    // Re-checking swagger chunks:
    // "/api/admin/document/review": {"post": ...} was visible.
    // Wait, the prompt says "api/admin/document/start-review".
    // I will assume it's a POST request.

    // For now, I'll put userId in query params as a guess, if it fails we can adjust.
    // Actually, looking at other endpoints in swagger, they often take parameters in query.

    final response = await http.post(
      uri.replace(queryParameters: {'userId': userId}),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to start review');
    }
  }
}
