import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/applicant_details_screen.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/rejected/widgets/rejected_filters.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/rejected/widgets/rejected_table.dart';
import 'package:konsulta_admin/core/service/dependency_injection/injection.dart';
import 'package:konsulta_admin/core/widgets/layout/layout_container.dart';

/// Rejected Applications Screen - Displays rejected professionals
///
/// This screen follows the same clean architecture pattern as Under Review screen
/// Shows only rejected applicants with profession filter and sort capabilities
class RejectedApplicationsScreen extends StatelessWidget {
  const RejectedApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingQueueBloc>(),
      child: const RejectedApplicationsView(),
    );
  }
}

class RejectedApplicationsView extends StatefulWidget {
  const RejectedApplicationsView({super.key});

  @override
  State<RejectedApplicationsView> createState() => _RejectedApplicationsViewState();
}

class _RejectedApplicationsViewState extends State<RejectedApplicationsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set active screen to Rejected
    context.read<OnboardingQueueBloc>().add(SetActiveScreenEvent(ActiveScreen.rejected));
    // Fetch professional tags for dropdown
    context.read<OnboardingQueueBloc>().add(GetProfessionalTagsEvent());
    // Trigger the event to fetch rejected applicants
    context.read<OnboardingQueueBloc>().add(GetRejectedApplicantsEvent());
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
                  'Rejected Applications',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'View all rejected professional applications.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                RejectedFilters(searchController: _searchController),
                const SizedBox(height: 24),
                const Expanded(child: RejectedTable()),
              ],
            ),
          );
        },
      ),
    );
  }
}
