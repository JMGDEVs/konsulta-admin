import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/service/api_service/api_paths.dart';
import 'package:konsulta_admin/core/service/api_service/konsulta_admin_api.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';

@lazySingleton
class OnboardingQueueService {
  final KonsultaProApi api;

  OnboardingQueueService(this.api);

  Future<List<ApplicantModel>> getPendingApplicants({
    String? searchQuery,
    String? professionId,
    int? pageNumber,
    int? pageSize,
  }) async {
    final queryParams = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
      if (pageNumber != null) 'pageNumber': pageNumber,
      if (pageSize != null) 'pageSize': pageSize,
    };

    final result = await api.get(
      ApiPath.getPendingApplicants,
      queryParams: queryParams,
    );

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    final data = result.data;
    List<dynamic> applicants;

    if (data is Map && data.containsKey('data')) {
      final dataObj = data['data'];
      if (dataObj is Map && dataObj.containsKey('applicants')) {
        // Swagger API returns: { success, message, data: { applicants: [...] } }
        applicants = dataObj['applicants'] as List<dynamic>;
      } else if (dataObj is List) {
        // Fallback: data is directly a list
        applicants = dataObj as List<dynamic>;
      } else {
        applicants = [];
      }
    } else if (data is List) {
      // Fallback: response is directly a list
      applicants = data as List<dynamic>;
    } else {
      applicants = [];
    }

    return applicants.map((json) => ApplicantModel.fromJson(json)).toList();
  }

  Future<List<ApplicantModel>> getUnderReviewApplicants({
    String? searchQuery,
    String? professionId,
    int? adminUserId,
  }) async {
    final queryParams = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
      if (adminUserId != null) 'adminUserId': adminUserId,
    };

    final result = await api.get(
      ApiPath.getUnderReviewApplicants,
      queryParams: queryParams,
    );

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    final data = result.data;
    List<dynamic> applicants;

    if (data is Map && data.containsKey('data')) {
      final dataObj = data['data'];
      if (dataObj is Map && dataObj.containsKey('applicants')) {
        applicants = dataObj['applicants'] as List<dynamic>;
      } else if (dataObj is List) {
        applicants = dataObj as List<dynamic>;
      } else {
        applicants = [];
      }
    } else if (data is List) {
      applicants = data as List<dynamic>;
    } else {
      applicants = [];
    }

    return applicants.map((json) => ApplicantModel.fromJson(json)).toList();
  }

  Future<bool> startReview(String applicantId) async {
    final result = await api.post(
      ApiPath.startReview,
      body: {'applicantId': applicantId},
    );

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    return true;
  }

  Future<List<ApplicantModel>> getVerifiedApplicants({
    String? searchQuery,
    String? professionId,
    int? pageNumber,
    int? pageSize,
  }) async {
    final queryParams = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
      if (pageNumber != null) 'pageNumber': pageNumber,
      if (pageSize != null) 'pageSize': pageSize,
    };

    final result = await api.get(
      ApiPath.getVerifiedApplicants,
      queryParams: queryParams,
    );

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    final data = result.data;
    List<dynamic> applicants;

    if (data is Map && data.containsKey('data')) {
      final dataObj = data['data'];
      if (dataObj is Map && dataObj.containsKey('applicants')) {
        // Swagger API returns: { success, message, data: { applicants: [...] } }
        applicants = dataObj['applicants'] as List<dynamic>;
      } else if (dataObj is List) {
        // Fallback: data is directly a list
        applicants = dataObj as List<dynamic>;
      } else {
        applicants = [];
      }
    } else if (data is List) {
      // Fallback: response is directly a list
      applicants = data as List<dynamic>;
    } else {
      applicants = [];
    }

    return applicants.map((json) => ApplicantModel.fromJson(json)).toList();
  }

  Future<List<String>> getProfessionalTags() async {
    final result = await api.get(ApiPath.getProfessionalTags);

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    final data = result.data;
    List<dynamic> tags;

    if (data is Map && data.containsKey('data')) {
      final dataObj = data['data'];
      if (dataObj is List) {
        tags = dataObj as List<dynamic>;
      } else {
        tags = [];
      }
    } else if (data is List) {
      tags = data as List<dynamic>;
    } else {
      tags = [];
    }

    // Extract tag_name from each tag object
    return tags.map((tag) {
      if (tag is Map<String, dynamic>) {
        return tag['tag_name']?.toString() ?? tag.toString();
      }
      return tag.toString();
    }).toList();
  }
}
