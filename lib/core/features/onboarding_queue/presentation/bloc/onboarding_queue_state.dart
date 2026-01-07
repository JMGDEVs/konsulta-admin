part of 'onboarding_queue_bloc.dart';

class OnboardingQueueState {
  final bool isLoading;
  final List<ApplicantModel> applicants;
  final bool isUnderReviewLoading;
  final List<ApplicantModel> underReviewApplicants;
  final String? errorMessage;

  // Screen context tracking
  final ActiveScreen activeScreen;

  // Pending Applications filter state
  final String pendingSearchQuery;
  final String? pendingProfessionId;
  final bool pendingSortAscending;
  final int pendingSortColumnIndex;

  // Under Review filter state
  final String underReviewSearchQuery;
  final String? underReviewProfessionId;
  final bool underReviewSortAscending;
  final int underReviewSortColumnIndex;

  final bool isReviewLoading;

  OnboardingQueueState({
    this.isLoading = false,
    this.applicants = const [],
    this.isUnderReviewLoading = false,
    this.underReviewApplicants = const [],
    this.errorMessage,
    this.activeScreen = ActiveScreen.pending,
    this.pendingSearchQuery = '',
    this.pendingProfessionId,
    this.pendingSortAscending = false,
    this.pendingSortColumnIndex = 7,
    this.underReviewSearchQuery = '',
    this.underReviewProfessionId,
    this.underReviewSortAscending = false,
    this.underReviewSortColumnIndex = 7,
    this.isReviewLoading = false,
  });

  OnboardingQueueState copyWith({
    bool? isLoading,
    List<ApplicantModel>? applicants,
    bool? isUnderReviewLoading,
    List<ApplicantModel>? underReviewApplicants,
    String? errorMessage,
    ActiveScreen? activeScreen,
    String? pendingSearchQuery,
    String? pendingProfessionId,
    bool? pendingSortAscending,
    int? pendingSortColumnIndex,
    String? underReviewSearchQuery,
    String? underReviewProfessionId,
    bool? underReviewSortAscending,
    int? underReviewSortColumnIndex,
    bool? isReviewLoading,
  }) {
    return OnboardingQueueState(
      isLoading: isLoading ?? this.isLoading,
      applicants: applicants ?? this.applicants,
      isUnderReviewLoading: isUnderReviewLoading ?? this.isUnderReviewLoading,
      underReviewApplicants: underReviewApplicants ?? this.underReviewApplicants,
      errorMessage: errorMessage ?? this.errorMessage,
      activeScreen: activeScreen ?? this.activeScreen,
      pendingSearchQuery: pendingSearchQuery ?? this.pendingSearchQuery,
      pendingProfessionId: pendingProfessionId ?? this.pendingProfessionId,
      pendingSortAscending: pendingSortAscending ?? this.pendingSortAscending,
      pendingSortColumnIndex: pendingSortColumnIndex ?? this.pendingSortColumnIndex,
      underReviewSearchQuery: underReviewSearchQuery ?? this.underReviewSearchQuery,
      underReviewProfessionId: underReviewProfessionId ?? this.underReviewProfessionId,
      underReviewSortAscending: underReviewSortAscending ?? this.underReviewSortAscending,
      underReviewSortColumnIndex: underReviewSortColumnIndex ?? this.underReviewSortColumnIndex,
      isReviewLoading: isReviewLoading ?? this.isReviewLoading,
    );
  }
}
