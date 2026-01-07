part of 'onboarding_queue_bloc.dart';

class OnboardingQueueState {
  final bool isLoading;
  final List<ApplicantModel> applicants;
  final String? errorMessage;
  final String searchQuery;
  final String? professionId;
  final bool isReviewLoading;
  final bool sortAscending;
  final int sortColumnIndex;

  OnboardingQueueState({
    this.isLoading = false,
    this.applicants = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.professionId,
    this.isReviewLoading = false,
    this.sortAscending =
        false, // Default Newest first (descending date usually, but depends on logic)
    this.sortColumnIndex = 7, // Registered date column index
  });

  OnboardingQueueState copyWith({
    bool? isLoading,
    List<ApplicantModel>? applicants,
    String? errorMessage,
    String? searchQuery,
    String? professionId,
    bool? isReviewLoading,
    bool? sortAscending,
    int? sortColumnIndex,
  }) {
    return OnboardingQueueState(
      isLoading: isLoading ?? this.isLoading,
      applicants: applicants ?? this.applicants,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      professionId: professionId ?? this.professionId,
      isReviewLoading: isReviewLoading ?? this.isReviewLoading,
      sortAscending: sortAscending ?? this.sortAscending,
      sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
    );
  }
}
