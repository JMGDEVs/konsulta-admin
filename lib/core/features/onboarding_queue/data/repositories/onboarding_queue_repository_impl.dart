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

    debugPrint('=== Get Pending Applicants API ===');
    debugPrint('Status Code: ${result.statusCode}');
    debugPrint('Response Body: ${result.body}');
    debugPrint('Is Success: ${result.isSuccess}');
    debugPrint('=====================================');

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
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
      if (adminUserId != null) 'adminUserId': adminUserId,
    };

    debugPrint('=== Get Under Review Applicants API ===');
    debugPrint('Query Params: searchQuery=$searchQuery, professionalTag=$professionId');

    final result = await _api.get(
      ApiPath.getUnderReviewApplicants,
      queryParams: queryParams,
    );

    debugPrint('Status Code: ${result.statusCode}');
    debugPrint('Response Body: ${result.body}');
    debugPrint('Is Success: ${result.isSuccess}');
    if (!result.isSuccess) {
      debugPrint('Error Message: ${result.errorMessage}');
    }
    debugPrint('========================================');

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

    debugPrint('=== Get Verified Applicants API ===');
    debugPrint('Status Code: ${result.statusCode}');
    debugPrint('Response Body: ${result.body}');
    debugPrint('Is Success: ${result.isSuccess}');
    if (!result.isSuccess) {
      debugPrint('Error Message: ${result.errorMessage}');
    }
    debugPrint('====================================');

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
        'searchQuery': searchQuery,
      if (professionId != null && professionId.isNotEmpty)
        'professionalTag': professionId,
      if (adminUserId != null) 'adminUserId': adminUserId,
    };

    debugPrint('=== Get Rejected Applicants API ===');
    debugPrint('Query Params: searchQuery=$searchQuery, professionalTag=$professionId');

    final result = await _api.get(
      ApiPath.getRejectedApplicants,
      queryParams: queryParams,
    );

    debugPrint('Status Code: ${result.statusCode}');
    debugPrint('Response Body: ${result.body}');
    debugPrint('Is Success: ${result.isSuccess}');
    if (!result.isSuccess) {
      debugPrint('Error Message: ${result.errorMessage}');
    }
    debugPrint('========================================');

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

    debugPrint('=== Start Review API ===');
    debugPrint('Applicant ID: $applicantId');
    debugPrint('Status Code: ${result.statusCode}');
    debugPrint('Response Body: ${result.body}');
    debugPrint('Is Success: ${result.isSuccess}');
    if (!result.isSuccess) {
      debugPrint('Error Message: ${result.errorMessage}');
    }
    debugPrint('==========================');

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    return true;
  }

  @override
  Future<List<String>> getProfessionalTags() async {
    final result = await _api.get(ApiPath.getProfessionalTags);

    debugPrint('=== Get Professional Tags API ===');
    debugPrint('Status Code: ${result.statusCode}');
    debugPrint('Response Body: ${result.body}');
    debugPrint('Is Success: ${result.isSuccess}');
    if (!result.isSuccess) {
      debugPrint('Error Message: ${result.errorMessage}');
    }
    debugPrint('==================================');

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
