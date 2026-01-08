import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart';

@lazySingleton
class GetVerifiedApplicantsUseCase {
  final OnboardingQueueRepository _repository;

  GetVerifiedApplicantsUseCase(this._repository);

  Future<List<ApplicantModel>> call({
    String? searchQuery,
    String? professionId,
  }) {
    return _repository.getVerifiedApplicants(
      searchQuery: searchQuery,
      professionId: professionId,
    );
  }
}
