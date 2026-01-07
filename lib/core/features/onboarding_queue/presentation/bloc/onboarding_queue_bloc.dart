import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/mock_applicants.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_pending_applicants_usecase.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_under_review_applicants_usecase.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/start_review_usecase.dart';

part 'onboarding_queue_event.dart';
part 'onboarding_queue_state.dart';

@injectable
class OnboardingQueueBloc
    extends Bloc<OnboardingQueueEvent, OnboardingQueueState> {
  final GetPendingApplicantsUseCase getPendingApplicantsUseCase;
  final GetUnderReviewApplicantsUseCase getUnderReviewApplicantsUseCase;
  final StartReviewUseCase startReviewUseCase;

  OnboardingQueueBloc(
    this.getPendingApplicantsUseCase,
    this.getUnderReviewApplicantsUseCase,
    this.startReviewUseCase,
  ) : super(OnboardingQueueState()) {
    on<SetActiveScreenEvent>(_onSetActiveScreen);
    on<GetPendingApplicantsEvent>(_onGetPendingApplicants);
    on<GetUnderReviewApplicantsEvent>(_onGetUnderReviewApplicants);
    on<StartReviewEvent>(_onStartReview);
    on<UpdateSearchEvent>(_onUpdateSearch);
    on<UpdateProfessionalTagEvent>(_onUpdateProfessionalTag);
    on<SortApplicantsEvent>(_onSortApplicants);
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

      final applicants = await getPendingApplicantsUseCase(
        search: searchQuery,
        professionalTag: professionId,
      );

      // Default sort: Newest first (descending by created_at)
      applicants.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
        final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
        return dateB.compareTo(dateA);
      });

      emit(state.copyWith(
        isLoading: false,
        applicants: applicants,
        pendingSearchQuery: searchQuery,
        pendingProfessionId: professionId,
      ));
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
          search: searchQuery,
          professionalTag: professionId,
        );
      }

      // Default sort: Newest first (descending by created_at)
      applicants.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
        final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
        return dateB.compareTo(dateA);
      });

      emit(state.copyWith(
        isUnderReviewLoading: false,
        underReviewApplicants: applicants,
        underReviewSearchQuery: searchQuery,
        underReviewProfessionId: professionId,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUnderReviewLoading: false,
        errorMessage: e.toString(),
      ));
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
    if (state.activeScreen == ActiveScreen.underReview) {
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
    if (state.activeScreen == ActiveScreen.underReview) {
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
    final isUnderReview = state.activeScreen == ActiveScreen.underReview;
    final sourceList = isUnderReview ? state.underReviewApplicants : state.applicants;
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
    if (isUnderReview) {
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
}
