part of 'onboarding_queue_bloc.dart';

class OnboardingQueueState {
  final bool isLoading;
  final List<ApplicantModel> applicants;
  final String? errorMessage;
  final String search;
  final String? professionalTag;
  final bool isReviewLoading;
  final bool sortAscending;
  final int sortColumnIndex;

  OnboardingQueueState({
    this.isLoading = false,
    this.applicants = const [],
    this.errorMessage,
    this.search = '',
    this.professionalTag,
    this.isReviewLoading = false,
    this.sortAscending =
        false, // Default Newest first (descending date usually, but depends on logic)
    this.sortColumnIndex = 7, // Registered date column index
  });

  OnboardingQueueState copyWith({
    bool? isLoading,
    List<ApplicantModel>? applicants,
    String? errorMessage,
    String? search,
    String? professionalTag,
    bool? isReviewLoading,
    bool? sortAscending,
    int? sortColumnIndex,
  }) {
    return OnboardingQueueState(
      isLoading: isLoading ?? this.isLoading,
      applicants: applicants ?? this.applicants,
      errorMessage: errorMessage ?? this.errorMessage,
      search: search ?? this.search,
      professionalTag: professionalTag ?? this.professionalTag,
      isReviewLoading: isReviewLoading ?? this.isReviewLoading,
      sortAscending: sortAscending ?? this.sortAscending,
      sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
    );
  }
}
