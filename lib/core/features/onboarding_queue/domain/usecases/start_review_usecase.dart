import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/repositories/onboarding_queue_repository.dart';

@lazySingleton
class StartReviewUseCase {
  final OnboardingQueueRepository _repository;

  StartReviewUseCase(this._repository);

  Future<bool> call(String userId) {
    return _repository.startReview(userId);
  }
}
