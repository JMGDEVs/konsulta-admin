import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart';

@lazySingleton
class GetProfessionalTagsUseCase {
  final OnboardingQueueRepository _repository;

  GetProfessionalTagsUseCase(this._repository);

  Future<List<String>> call() {
    return _repository.getProfessionalTags();
  }
}
