import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/mock_applicants.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_pending_applicants_usecase.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_under_review_applicants_usecase.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_verified_applicants_usecase.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/start_review_usecase.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_professional_tags_usecase.dart';

part 'onboarding_queue_event.dart';
part 'onboarding_queue_state.dart';

@injectable
class OnboardingQueueBloc
    extends Bloc<OnboardingQueueEvent, OnboardingQueueState> {
  final GetPendingApplicantsUseCase getPendingApplicantsUseCase;
  final GetUnderReviewApplicantsUseCase getUnderReviewApplicantsUseCase;
  final GetVerifiedApplicantsUseCase getVerifiedApplicantsUseCase;
  final StartReviewUseCase startReviewUseCase;
  final GetProfessionalTagsUseCase getProfessionalTagsUseCase;

  OnboardingQueueBloc(
    this.getPendingApplicantsUseCase,
    this.getUnderReviewApplicantsUseCase,
    this.getVerifiedApplicantsUseCase,
    this.startReviewUseCase,
    this.getProfessionalTagsUseCase,
  ) : super(OnboardingQueueState()) {
    on<SetActiveScreenEvent>(_onSetActiveScreen);
    on<GetPendingApplicantsEvent>(_onGetPendingApplicants);
    on<GetUnderReviewApplicantsEvent>(_onGetUnderReviewApplicants);
    on<GetVerifiedApplicantsEvent>(_onGetVerifiedApplicants);
    on<StartReviewEvent>(_onStartReview);
    on<UpdateSearchEvent>(_onUpdateSearch);
    on<UpdateProfessionalTagEvent>(_onUpdateProfessionalTag);
    on<SortApplicantsEvent>(_onSortApplicants);
    on<SelectApplicantForReviewEvent>(_onSelectApplicantForReview);
    on<ClearSelectedApplicantEvent>(_onClearSelectedApplicant);
    on<GetProfessionalTagsEvent>(_onGetProfessionalTags);
  }

  void _onSetActiveScreen(
    SetActiveScreenEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    emit(state.copyWith(activeScreen: event.screen));
  }

  Future<void> _onGetPendingApplicants(
    GetPendingApplicantsEvent event,
    Emitter<OnboardingQueueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final searchQuery = event.searchQuery ?? state.pendingSearchQuery;
      final professionId = event.professionId ?? state.pendingProfessionId;

      // Fetch from API, but still apply filtering locally because the backend
      // may not support these query params yet.
      var applicants = await getPendingApplicantsUseCase(
        searchQuery: searchQuery,
        professionId: professionId,
      );

      // Local search filter
      if (searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        applicants = applicants.where((applicant) {
          return applicant.fullName.toLowerCase().contains(lowerQuery) ||
              (applicant.phone ?? '').contains(lowerQuery) ||
              (applicant.email ?? '').toLowerCase().contains(lowerQuery);
        }).toList();
      }

      // Local profession filter
      if (professionId != null && professionId.isNotEmpty) {
        applicants = applicants.where((applicant) {
          return applicant.professionalTag == professionId;
        }).toList();
      }

      // Apply current sort settings (default: Registered date, newest first)
      final sortColumnIndex = state.pendingSortColumnIndex;
      final sortAscending = state.pendingSortAscending;
      applicants.sort((a, b) {
        int compareResult = 0;
        switch (sortColumnIndex) {
          case 0:
            compareResult = (a.fullName).compareTo(b.fullName);
            break;
          case 1:
            compareResult = (a.professionalTag ?? '').compareTo(
              b.professionalTag ?? '',
            );
            break;
          case 2:
            compareResult = (a.phone ?? '').compareTo(b.phone ?? '');
            break;
          case 3:
            compareResult = (a.email ?? '').compareTo(b.email ?? '');
            break;
          case 4:
            compareResult = (a.verificationStatus ?? '').compareTo(
              b.verificationStatus ?? '',
            );
            break;
          case 5:
            compareResult = (a.gender ?? '').compareTo(b.gender ?? '');
            break;
          case 6:
            final dateA = DateTime.tryParse(a.birthDate ?? '') ?? DateTime(0);
            final dateB = DateTime.tryParse(b.birthDate ?? '') ?? DateTime(0);
            compareResult = dateA.compareTo(dateB);
            break;
          case 7:
          default:
            final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
            final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
            compareResult = dateA.compareTo(dateB);
        }
        return sortAscending ? compareResult : -compareResult;
      });

      emit(
        state.copyWith(
          isLoading: false,
          applicants: applicants,
          pendingSearchQuery: searchQuery,
          pendingProfessionId: professionId,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onGetUnderReviewApplicants(
    GetUnderReviewApplicantsEvent event,
    Emitter<OnboardingQueueState> emit,
  ) async {
    emit(state.copyWith(isUnderReviewLoading: true, errorMessage: null));

    try {
      final searchQuery = event.searchQuery ?? state.underReviewSearchQuery;
      final professionId = event.professionId ?? state.underReviewProfessionId;

      List<ApplicantModel> applicants;

      // TODO: REMOVE MOCK DATA WHEN REAL DATA IS AVAILABLE
      // Check if mock data should be used
      if (USE_MOCK_UNDER_REVIEW_DATA) {
        // Return mock data instead of API call
        applicants = List.from(mockUnderReviewApplicants);

        // Apply search filter if provided
        if (searchQuery.isNotEmpty) {
          final lowerQuery = searchQuery.toLowerCase();
          applicants = applicants.where((applicant) {
            return applicant.fullName.toLowerCase().contains(lowerQuery) ||
                (applicant.phone ?? '').contains(lowerQuery) ||
                (applicant.email ?? '').toLowerCase().contains(lowerQuery);
          }).toList();
        }

        // Apply profession filter if provided
        if (professionId != null && professionId.isNotEmpty) {
          applicants = applicants.where((applicant) {
            return applicant.professionalTag == professionId;
          }).toList();
        }
      } else {
        // Original API call (keep this intact)
        applicants = await getUnderReviewApplicantsUseCase(
          searchQuery: searchQuery,
          professionId: professionId,
        );
      }

      // Default sort: Newest first (descending by created_at)
      applicants.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
        final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
        return dateB.compareTo(dateA);
      });

      emit(
        state.copyWith(
          isUnderReviewLoading: false,
          underReviewApplicants: applicants,
          underReviewSearchQuery: searchQuery,
          underReviewProfessionId: professionId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isUnderReviewLoading: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onGetVerifiedApplicants(
    GetVerifiedApplicantsEvent event,
    Emitter<OnboardingQueueState> emit,
  ) async {
    emit(state.copyWith(isVerifiedLoading: true, errorMessage: null));

    try {
      final searchQuery = event.searchQuery ?? state.verifiedSearchQuery;
      final professionId = event.professionId ?? state.verifiedProfessionId;

      // Fetch from API, but still apply filtering locally because the backend
      // may not support these query params yet.
      var applicants = await getVerifiedApplicantsUseCase(
        searchQuery: searchQuery,
        professionId: professionId,
      );

      // Local search filter
      if (searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        applicants = applicants.where((applicant) {
          return applicant.fullName.toLowerCase().contains(lowerQuery) ||
              (applicant.phone ?? '').contains(lowerQuery) ||
              (applicant.email ?? '').toLowerCase().contains(lowerQuery);
        }).toList();
      }

      // Local profession filter
      if (professionId != null && professionId.isNotEmpty) {
        applicants = applicants.where((applicant) {
          return applicant.professionalTag == professionId;
        }).toList();
      }

      // Apply current sort settings (default: Registered date, newest first)
      final sortColumnIndex = state.verifiedSortColumnIndex;
      final sortAscending = state.verifiedSortAscending;
      applicants.sort((a, b) {
        int compareResult = 0;
        switch (sortColumnIndex) {
          case 0:
            compareResult = (a.fullName).compareTo(b.fullName);
            break;
          case 1:
            compareResult = (a.professionalTag ?? '').compareTo(
              b.professionalTag ?? '',
            );
            break;
          case 2:
            compareResult = (a.phone ?? '').compareTo(b.phone ?? '');
            break;
          case 3:
            compareResult = (a.email ?? '').compareTo(b.email ?? '');
            break;
          case 4:
            compareResult = (a.verificationStatus ?? '').compareTo(
              b.verificationStatus ?? '',
            );
            break;
          case 5:
            compareResult = (a.gender ?? '').compareTo(b.gender ?? '');
            break;
          case 6:
            final dateA = DateTime.tryParse(a.birthDate ?? '') ?? DateTime(0);
            final dateB = DateTime.tryParse(b.birthDate ?? '') ?? DateTime(0);
            compareResult = dateA.compareTo(dateB);
            break;
          case 7:
          default:
            final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
            final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
            compareResult = dateA.compareTo(dateB);
        }
        return sortAscending ? compareResult : -compareResult;
      });

      emit(
        state.copyWith(
          isVerifiedLoading: false,
          verifiedApplicants: applicants,
          verifiedSearchQuery: searchQuery,
          verifiedProfessionId: professionId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isVerifiedLoading: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onStartReview(
    StartReviewEvent event,
    Emitter<OnboardingQueueState> emit,
  ) async {
    emit(state.copyWith(isReviewLoading: true));
    try {
      final success = await startReviewUseCase(event.applicantId);
      if (success) {
        event.onSuccess();
        // Refresh list after successful review start
        add(GetPendingApplicantsEvent(isRefresh: true));
      }
    } catch (e) {
      // Handle error
    } finally {
      emit(state.copyWith(isReviewLoading: false));
    }
  }

  void _onUpdateSearch(
    UpdateSearchEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    // Dispatch correct event based on active screen
    if (state.activeScreen == ActiveScreen.verified) {
      emit(state.copyWith(verifiedSearchQuery: event.searchQuery));
      add(GetVerifiedApplicantsEvent(searchQuery: event.searchQuery));
    } else if (state.activeScreen == ActiveScreen.underReview) {
      emit(state.copyWith(underReviewSearchQuery: event.searchQuery));
      add(GetUnderReviewApplicantsEvent(searchQuery: event.searchQuery));
    } else {
      emit(state.copyWith(pendingSearchQuery: event.searchQuery));
      add(GetPendingApplicantsEvent(searchQuery: event.searchQuery));
    }
  }

  void _onUpdateProfessionalTag(
    UpdateProfessionalTagEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    // Dispatch correct event based on active screen
    if (state.activeScreen == ActiveScreen.verified) {
      emit(state.copyWith(verifiedProfessionId: event.professionId));
      add(GetVerifiedApplicantsEvent(professionId: event.professionId));
    } else if (state.activeScreen == ActiveScreen.underReview) {
      emit(state.copyWith(underReviewProfessionId: event.professionId));
      add(GetUnderReviewApplicantsEvent(professionId: event.professionId));
    } else {
      emit(state.copyWith(pendingProfessionId: event.professionId));
      add(GetPendingApplicantsEvent(professionId: event.professionId));
    }
  }

  void _onSortApplicants(
    SortApplicantsEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    final ascending = event.ascending;

    // Determine which list to sort based on active screen
    List<ApplicantModel> sourceList;
    if (state.activeScreen == ActiveScreen.verified) {
      sourceList = state.verifiedApplicants;
    } else if (state.activeScreen == ActiveScreen.underReview) {
      sourceList = state.underReviewApplicants;
    } else {
      sourceList = state.applicants;
    }
    final sortedApplicants = List<ApplicantModel>.from(sourceList);

    sortedApplicants.sort((a, b) {
      int compareResult = 0;

      switch (event.columnIndex) {
        case 0: // Name
          compareResult = (a.fullName).compareTo(b.fullName);
          break;
        case 1: // Profession
          compareResult = (a.professionalTag ?? '').compareTo(
            b.professionalTag ?? '',
          );
          break;
        case 2: // Phone
          compareResult = (a.phone ?? '').compareTo(b.phone ?? '');
          break;
        case 3: // Email
          compareResult = (a.email ?? '').compareTo(b.email ?? '');
          break;
        case 4: // Status
          compareResult = (a.verificationStatus ?? '').compareTo(
            b.verificationStatus ?? '',
          );
          break;
        case 5: // Gender
          compareResult = (a.gender ?? '').compareTo(b.gender ?? '');
          break;
        case 6: // Birthdate
          final dateA = DateTime.tryParse(a.birthDate ?? '') ?? DateTime(0);
          final dateB = DateTime.tryParse(b.birthDate ?? '') ?? DateTime(0);
          compareResult = dateA.compareTo(dateB);
          break;
        case 7: // Registered Date
          final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
          final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
          compareResult = dateA.compareTo(dateB);
          break;
        default:
          compareResult = 0;
      }

      return ascending ? compareResult : -compareResult;
    });

    // Update the correct list and sort state based on active screen
    if (state.activeScreen == ActiveScreen.verified) {
      emit(
        state.copyWith(
          verifiedApplicants: sortedApplicants,
          verifiedSortAscending: ascending,
          verifiedSortColumnIndex: event.columnIndex,
        ),
      );
    } else if (state.activeScreen == ActiveScreen.underReview) {
      emit(
        state.copyWith(
          underReviewApplicants: sortedApplicants,
          underReviewSortAscending: ascending,
          underReviewSortColumnIndex: event.columnIndex,
        ),
      );
    } else {
      emit(
        state.copyWith(
          applicants: sortedApplicants,
          pendingSortAscending: ascending,
          pendingSortColumnIndex: event.columnIndex,
        ),
      );
    }
  }

  void _onSelectApplicantForReview(
    SelectApplicantForReviewEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    emit(state.copyWith(selectedApplicantForReview: event.applicant));
  }

  void _onClearSelectedApplicant(
    ClearSelectedApplicantEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    // To clear nullable field, create new state with null explicitly
    emit(
      OnboardingQueueState(
        isLoading: state.isLoading,
        applicants: state.applicants,
        isUnderReviewLoading: state.isUnderReviewLoading,
        underReviewApplicants: state.underReviewApplicants,
        errorMessage: state.errorMessage,
        activeScreen: state.activeScreen,
        pendingSearchQuery: state.pendingSearchQuery,
        pendingProfessionId: state.pendingProfessionId,
        pendingSortAscending: state.pendingSortAscending,
        pendingSortColumnIndex: state.pendingSortColumnIndex,
        underReviewSearchQuery: state.underReviewSearchQuery,
        underReviewProfessionId: state.underReviewProfessionId,
        underReviewSortAscending: state.underReviewSortAscending,
        underReviewSortColumnIndex: state.underReviewSortColumnIndex,
        isReviewLoading: state.isReviewLoading,
        selectedApplicantForReview: null, // Explicitly set to null
        professionalTags: state.professionalTags,
        isLoadingProfessionalTags: state.isLoadingProfessionalTags,
        isVerifiedLoading: state.isVerifiedLoading,
        verifiedApplicants: state.verifiedApplicants,
        verifiedSearchQuery: state.verifiedSearchQuery,
        verifiedProfessionId: state.verifiedProfessionId,
        verifiedSortAscending: state.verifiedSortAscending,
        verifiedSortColumnIndex: state.verifiedSortColumnIndex,
      ),
    );
  }

  Future<void> _onGetProfessionalTags(
    GetProfessionalTagsEvent event,
    Emitter<OnboardingQueueState> emit,
  ) async {
    emit(state.copyWith(isLoadingProfessionalTags: true));
    try {
      final tags = await getProfessionalTagsUseCase();
      emit(
        state.copyWith(
          isLoadingProfessionalTags: false,
          professionalTags: tags,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingProfessionalTags: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
