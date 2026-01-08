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

  // Verified Applications filter state
  final String verifiedSearchQuery;
  final String? verifiedProfessionId;
  final bool verifiedSortAscending;
  final int verifiedSortColumnIndex;
  final bool isVerifiedLoading;
  final List<ApplicantModel> verifiedApplicants;

  final bool isReviewLoading;

  // Selected applicant for detail view
  final ApplicantModel? selectedApplicantForReview;

  // Professional tags from API
  final List<String> professionalTags;
  final bool isLoadingProfessionalTags;

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
    this.selectedApplicantForReview,
    this.professionalTags = const [],
    this.isLoadingProfessionalTags = false,
    this.verifiedSearchQuery = '',
    this.verifiedProfessionId,
    this.verifiedSortAscending = false,
    this.verifiedSortColumnIndex = 7,
    this.isVerifiedLoading = false,
    this.verifiedApplicants = const [],
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
    ApplicantModel? selectedApplicantForReview,
    List<String>? professionalTags,
    bool? isLoadingProfessionalTags,
    String? verifiedSearchQuery,
    String? verifiedProfessionId,
    bool? verifiedSortAscending,
    int? verifiedSortColumnIndex,
    bool? isVerifiedLoading,
    List<ApplicantModel>? verifiedApplicants,
  }) {
    return OnboardingQueueState(
      isLoading: isLoading ?? this.isLoading,
      applicants: applicants ?? this.applicants,
      isUnderReviewLoading: isUnderReviewLoading ?? this.isUnderReviewLoading,
      underReviewApplicants:
          underReviewApplicants ?? this.underReviewApplicants,
      errorMessage: errorMessage ?? this.errorMessage,
      activeScreen: activeScreen ?? this.activeScreen,
      pendingSearchQuery: pendingSearchQuery ?? this.pendingSearchQuery,
      pendingProfessionId: pendingProfessionId ?? this.pendingProfessionId,
      pendingSortAscending: pendingSortAscending ?? this.pendingSortAscending,
      pendingSortColumnIndex:
          pendingSortColumnIndex ?? this.pendingSortColumnIndex,
      underReviewSearchQuery:
          underReviewSearchQuery ?? this.underReviewSearchQuery,
      underReviewProfessionId:
          underReviewProfessionId ?? this.underReviewProfessionId,
      underReviewSortAscending:
          underReviewSortAscending ?? this.underReviewSortAscending,
      underReviewSortColumnIndex:
          underReviewSortColumnIndex ?? this.underReviewSortColumnIndex,
      isReviewLoading: isReviewLoading ?? this.isReviewLoading,
      selectedApplicantForReview:
          selectedApplicantForReview ?? this.selectedApplicantForReview,
      professionalTags: professionalTags ?? this.professionalTags,
      isLoadingProfessionalTags:
          isLoadingProfessionalTags ?? this.isLoadingProfessionalTags,
      verifiedSearchQuery: verifiedSearchQuery ?? this.verifiedSearchQuery,
      verifiedProfessionId: verifiedProfessionId ?? this.verifiedProfessionId,
      verifiedSortAscending:
          verifiedSortAscending ?? this.verifiedSortAscending,
      verifiedSortColumnIndex:
          verifiedSortColumnIndex ?? this.verifiedSortColumnIndex,
      isVerifiedLoading: isVerifiedLoading ?? this.isVerifiedLoading,
      verifiedApplicants: verifiedApplicants ?? this.verifiedApplicants,
    );
  }
}
