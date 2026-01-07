import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/datasources/onboarding_queue_service.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart';

@LazySingleton(as: OnboardingQueueRepository)
class OnboardingQueueRepositoryImpl implements OnboardingQueueRepository {
  final OnboardingQueueService _service;

  OnboardingQueueRepositoryImpl(this._service);

  @override
  Future<List<ApplicantModel>> getPendingApplicants({
    String? search,
    String? professionalTag,
  }) {
    return _service.getPendingApplicants(
      search: search,
      professionalTag: professionalTag,
    );
  }

  @override
  Future<List<ApplicantModel>> getUnderReviewApplicants({
    String? search,
    String? professionalTag,
    int? adminUserId,
  }) {
    return _service.getUnderReviewApplicants(
      search: search,
      professionalTag: professionalTag,
      adminUserId: adminUserId,
    );
  }

  @override
  Future<bool> startReview(String applicantId) {
    return _service.startReview(applicantId);
  }
}
