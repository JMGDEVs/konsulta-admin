part of 'onboarding_queue_bloc.dart';

abstract class OnboardingQueueEvent {}

class GetPendingApplicantsEvent extends OnboardingQueueEvent {
  final String? search;
  final String? professionalTag;
  final bool isRefresh;

  GetPendingApplicantsEvent({
    this.search,
    this.professionalTag,
    this.isRefresh = false,
  });
}

class StartReviewEvent extends OnboardingQueueEvent {
  final String userId;
  final Function() onSuccess;

  StartReviewEvent({required this.userId, required this.onSuccess});
}

class UpdateSearchEvent extends OnboardingQueueEvent {
  final String search;

  UpdateSearchEvent(this.search);
}

class UpdateProfessionalTagEvent extends OnboardingQueueEvent {
  final String? professionalTag;

  UpdateProfessionalTagEvent(this.professionalTag);
}

class SortApplicantsEvent extends OnboardingQueueEvent {
  final bool ascending;
  final int columnIndex;

  SortApplicantsEvent(this.ascending, this.columnIndex);
}
