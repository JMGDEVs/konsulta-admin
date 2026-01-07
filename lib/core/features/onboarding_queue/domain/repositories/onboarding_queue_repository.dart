import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';

abstract class OnboardingQueueRepository {
  Future<List<ApplicantModel>> getPendingApplicants({
    String? searchQuery,
    String? professionId,
  });
  Future<bool> startReview(String applicantId);
}
