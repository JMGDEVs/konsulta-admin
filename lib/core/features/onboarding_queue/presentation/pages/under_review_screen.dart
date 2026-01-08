import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/applicant_details_screen.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/widgets/under_review_filters.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/widgets/under_review_table.dart';
import 'package:konsulta_admin/core/service/dependency_injection/injection.dart';
import 'package:konsulta_admin/core/widgets/layout/layout_container.dart';

/// Under Review Screen - Displays applicants whose documents are under review
///
/// This file has been refactored from 1,795 lines down to ~100 lines
/// by extracting components into separate reusable files following
/// SOLID principles and 2025 Flutter best practices
class UnderReviewScreen extends StatelessWidget {
  const UnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingQueueBloc>(),
      child: const UnderReviewView(),
    );
  }
}

class UnderReviewView extends StatefulWidget {
  const UnderReviewView({super.key});

  @override
  State<UnderReviewView> createState() => _UnderReviewViewState();
}

class _UnderReviewViewState extends State<UnderReviewView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set active screen to Under Review
    context.read<OnboardingQueueBloc>().add(SetActiveScreenEvent(ActiveScreen.underReview));
    // Fetch professional tags for dropdown
    context.read<OnboardingQueueBloc>().add(GetProfessionalTagsEvent());
    // Trigger the event to fetch under review applicants
    context.read<OnboardingQueueBloc>().add(GetUnderReviewApplicantsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: BlocBuilder<OnboardingQueueBloc, OnboardingQueueState>(
        builder: (context, state) {
          // Check if an applicant is selected for review
          if (state.selectedApplicantForReview != null) {
            return ApplicantDetailsScreen(
              applicant: state.selectedApplicantForReview!,
            );
          }

          // Show the table view
          return Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Under Review',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Review the uploaded IDs to approve or reject applications.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                UnderReviewFilters(searchController: _searchController),
                const SizedBox(height: 24),
                const Expanded(child: UnderReviewTable()),
              ],
            ),
          );
        },
      ),
    );
  }
}
