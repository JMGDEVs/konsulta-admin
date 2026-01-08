import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart';

@lazySingleton
class GetUnderReviewApplicantsUseCase {
  final OnboardingQueueRepository _repository;

  GetUnderReviewApplicantsUseCase(this._repository);

  Future<List<ApplicantModel>> call({
    String? searchQuery,
    String? professionId,
    int? adminUserId,
  }) {
    return _repository.getUnderReviewApplicants(
      searchQuery: searchQuery,
      professionId: professionId,
      adminUserId: adminUserId,
    );
  }
}
