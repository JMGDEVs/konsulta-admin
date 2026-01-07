part of 'onboarding_queue_bloc.dart';

abstract class OnboardingQueueEvent {}

class GetPendingApplicantsEvent extends OnboardingQueueEvent {
  final String? searchQuery;
  final String? professionId;
  final bool isRefresh;

  GetPendingApplicantsEvent({
    this.searchQuery,
    this.professionId,
    this.isRefresh = false,
  });
}

class StartReviewEvent extends OnboardingQueueEvent {
  final String applicantId;
  final Function() onSuccess;

  StartReviewEvent({required this.applicantId, required this.onSuccess});
}

class UpdateSearchEvent extends OnboardingQueueEvent {
  final String searchQuery;

  UpdateSearchEvent(this.searchQuery);
}

class UpdateProfessionalTagEvent extends OnboardingQueueEvent {
  final String? professionId;

  UpdateProfessionalTagEvent(this.professionId);
}

class SortApplicantsEvent extends OnboardingQueueEvent {
  final bool ascending;
  final int columnIndex;

  SortApplicantsEvent(this.ascending, this.columnIndex);
}
