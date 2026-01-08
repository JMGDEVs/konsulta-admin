import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart';

@lazySingleton
class GetPendingApplicantsUseCase {
  final OnboardingQueueRepository _repository;

  GetPendingApplicantsUseCase(this._repository);

  Future<List<ApplicantModel>> call({
    String? searchQuery,
    String? professionId,
  }) {
    return _repository.getPendingApplicants(
      searchQuery: searchQuery,
      professionId: professionId,
    );
  }
}
