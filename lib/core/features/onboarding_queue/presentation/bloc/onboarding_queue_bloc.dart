import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/get_pending_applicants_usecase.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/domain/usecases/start_review_usecase.dart';

part 'onboarding_queue_event.dart';
part 'onboarding_queue_state.dart';

@injectable
class OnboardingQueueBloc
    extends Bloc<OnboardingQueueEvent, OnboardingQueueState> {
  final GetPendingApplicantsUseCase getPendingApplicantsUseCase;
  final StartReviewUseCase startReviewUseCase;

  OnboardingQueueBloc(this.getPendingApplicantsUseCase, this.startReviewUseCase)
    : super(OnboardingQueueState()) {
    on<GetPendingApplicantsEvent>(_onGetPendingApplicants);
    on<StartReviewEvent>(_onStartReview);
    on<UpdateSearchEvent>(_onUpdateSearch);
    on<UpdateProfessionalTagEvent>(_onUpdateProfessionalTag);
    on<SortApplicantsEvent>(_onSortApplicants);
  }

  Future<void> _onGetPendingApplicants(
    GetPendingApplicantsEvent event,
    Emitter<OnboardingQueueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final applicants = await getPendingApplicantsUseCase(
        searchQuery: event.searchQuery ?? state.searchQuery,
        professionId: event.professionId ?? state.professionId,
      );

      // Default sort: Newest first (descending by created_at)
      applicants.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
        final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
        return dateB.compareTo(dateA);
      });

      emit(state.copyWith(isLoading: false, applicants: applicants));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
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
    emit(state.copyWith(searchQuery: event.searchQuery));
    add(GetPendingApplicantsEvent(searchQuery: event.searchQuery));
  }

  void _onUpdateProfessionalTag(
    UpdateProfessionalTagEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    emit(state.copyWith(professionId: event.professionId));
    add(GetPendingApplicantsEvent(professionId: event.professionId));
  }

  void _onSortApplicants(
    SortApplicantsEvent event,
    Emitter<OnboardingQueueState> emit,
  ) {
    final sortedApplicants = List<ApplicantModel>.from(state.applicants);
    final ascending = event.ascending;

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

    emit(
      state.copyWith(
        applicants: sortedApplicants,
        sortAscending: ascending,
        sortColumnIndex: event.columnIndex,
      ),
    );
  }
}
