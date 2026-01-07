import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';

abstract class OnboardingQueueRepository {
  Future<List<ApplicantModel>> getPendingApplicants({
    String? search,
    String? professionalTag,
  });
  Future<List<ApplicantModel>> getUnderReviewApplicants({
    String? search,
    String? professionalTag,
    int? adminUserId,
  });
  Future<bool> startReview(String applicantId);
}
