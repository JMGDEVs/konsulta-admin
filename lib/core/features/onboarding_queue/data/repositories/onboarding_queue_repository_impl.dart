import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/service/api_service/api_paths.dart';
import 'package:konsulta_admin/core/service/api_service/konsulta_admin_api.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart';

@LazySingleton(as: OnboardingQueueRepository)
class OnboardingQueueRepositoryImpl implements OnboardingQueueRepository {
  final KonsultaProApi _api;

  OnboardingQueueRepositoryImpl(this._api);

  void _logApiCall(String endpoint, APIResult result) {
    debugPrint('[API] $endpoint - ${result.isSuccess ? 'SUCCESS' : 'FAILED'} (${result.statusCode})');
  }

  @override
  Future<List<ApplicantModel>> getPendingApplicants({
    String? searchQuery,
    String? professionId,
  }) async {
    final queryParams = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
    };

    final result = await _api.get(
      ApiPath.getPendingApplicants,
      queryParams: queryParams,
    );

    _logApiCall('Get Pending Applicants API', result);

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

  @override
  Future<List<ApplicantModel>> getUnderReviewApplicants({
    String? searchQuery,
    String? professionId,
    int? adminUserId,
  }) async {
    final queryParams = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'search': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
      if (adminUserId != null) 'admin_user_id': adminUserId,
    };

    final result = await _api.get(
      ApiPath.getUnderReviewApplicants,
      queryParams: queryParams,
    );

    _logApiCall('Get Under Review Applicants API', result);

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    final data = result.data;
    List<dynamic> applicants;

    // Handle multiple API response formats: {data: {applicants: []}} or direct []
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

  @override
  Future<List<ApplicantModel>> getVerifiedApplicants({
    String? searchQuery,
    String? professionId,
  }) async {
    final queryParams = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
    };

    final result = await _api.get(
      ApiPath.getVerifiedApplicants,
      queryParams: queryParams,
    );

    _logApiCall('Get Verified Applicants API', result);

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

  @override
  Future<List<ApplicantModel>> getRejectedApplicants({
    String? searchQuery,
    String? professionId,
    int? adminUserId,
  }) async {
    final queryParams = {
      if (searchQuery != null && searchQuery.isNotEmpty)
        'search': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
      if (adminUserId != null) 'admin_user_id': adminUserId,
    };

    final result = await _api.get(
      ApiPath.getRejectedApplicants,
      queryParams: queryParams,
    );

    _logApiCall('Get Rejected Applicants API', result);

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    final data = result.data;
    List<dynamic> applicants;

    // Handle multiple API response formats: {data: {applicants: []}} or direct []
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

  @override
  Future<bool> startReview(String applicantId) async {
    final result = await _api.post(
      ApiPath.startReview,
      body: {'applicantId': applicantId},
    );

    _logApiCall('Start Review API', result);

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    return true;
  }

  @override
  Future<List<String>> getProfessionalTags() async {
    final result = await _api.get(ApiPath.getProfessionalTags);

    _logApiCall('Get Professional Tags API', result);

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

    return tags.map((tag) {
      if (tag is Map<String, dynamic>) {
        return tag['tag_name']?.toString() ?? tag.toString();
      }
      return tag.toString();
    }).toList();
  }
}
