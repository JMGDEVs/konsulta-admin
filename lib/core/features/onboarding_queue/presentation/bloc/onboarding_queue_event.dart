part of 'onboarding_queue_bloc.dart';

enum ActiveScreen { pending, underReview }

abstract class OnboardingQueueEvent {}

class SetActiveScreenEvent extends OnboardingQueueEvent {
  final ActiveScreen screen;

  SetActiveScreenEvent(this.screen);
}

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

class GetUnderReviewApplicantsEvent extends OnboardingQueueEvent {
  final String? searchQuery;
  final String? professionId;
  final bool isRefresh;

  GetUnderReviewApplicantsEvent({
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

class SelectApplicantForReviewEvent extends OnboardingQueueEvent {
  final ApplicantModel applicant;

  SelectApplicantForReviewEvent(this.applicant);
}

class ClearSelectedApplicantEvent extends OnboardingQueueEvent {}
