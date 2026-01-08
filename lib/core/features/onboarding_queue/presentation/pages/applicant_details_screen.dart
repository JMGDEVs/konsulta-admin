import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/constants/under_review_dialog_constants.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/constants/under_review_layout_constants.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/dialogs/confirmation_dialog.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/dialogs/return_application_dialog.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/widgets/applicant_info_card.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/widgets/document_card.dart';

/// Screen for displaying detailed applicant information and documents
///
/// This screen was extracted from the 996-line God Class `_ApplicantDetailsView`
/// to follow Single Responsibility Principle and improve maintainability
class ApplicantDetailsScreen extends StatelessWidget {
  final ApplicantModel applicant;

  const ApplicantDetailsScreen({
    super.key,
    required this.applicant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with back button and reject button
          _buildTopBar(context),
          const SizedBox(height: 24),

          // Split Column Layout
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Applicant Details
                Expanded(
                  flex: 1,
                  child: ApplicantInfoCard(applicant: applicant),
                ),
                const SizedBox(width: kCardGap),

                // Right Column - Document Cards
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Government ID Card
                        DocumentCard(
                          title: 'Government ID',
                          subtitle: 'Official Passport Document',
                          files: const [
                            {'filename': 'GovernmentIdforkonsultagroup.png', 'filesize': '5.3 mb'},
                            {'filename': 'GovernmentIdforkonsultagroup.png', 'filesize': '5.3 mb'},
                          ],
                          onApprove: () => _handleApproveGovernmentId(context),
                          onReturnForRevision: () => _handleReturnForRevision(context),
                        ),
                        const SizedBox(height: kCardVerticalGap),

                        // Professional ID Card
                        DocumentCard(
                          title: 'Professional ID',
                          subtitle: 'Lawyer License',
                          files: const [
                            {'filename': 'ProfessionalIDforkonsultagroup.png', 'filesize': '5.3 mb'},
                            {'filename': 'ProfessionalIDforkonsultagroup.png', 'filesize': '5.3 mb'},
                          ],
                          onApprove: () => _handleApproveProfessionalId(context),
                          onReturnForRevision: () => _handleReturnForRevision(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Back button
        Container(
          margin: const EdgeInsets.only(left: kScreenHorizontalMargin, top: 16.0),
          child: SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset('assets/icons/lets-icons_back.png'),
              ),
              onPressed: () {
                context.read<OnboardingQueueBloc>().add(
                      ClearSelectedApplicantEvent(),
                    );
              },
              tooltip: 'Back to list',
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        const Spacer(),

        // Reject button
        Container(
          margin: const EdgeInsets.only(right: kScreenHorizontalMargin, top: 16.0),
          child: SizedBox(
            width: kRejectButtonWidth,
            height: kRejectButtonHeight,
            child: ElevatedButton(
              onPressed: () => _handleReject(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kRedButton,
                foregroundColor: const Color(0xFFFFFFFF),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                minimumSize: Size(kRejectButtonWidth, kRejectButtonHeight),
              ),
              child: Text(
                'Reject Applicant',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  letterSpacing: -0.32,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleReject(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: 'Reject Application',
          message: 'Are you sure you want to reject this application',
          confirmButtonText: 'Reject',
          confirmButtonColor: kRejectButtonColor,
          onConfirm: () {
            // Clear selection and go back to list
            context.read<OnboardingQueueBloc>().add(
                  ClearSelectedApplicantEvent(),
                );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Applicant rejected (placeholder action)'),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
    );
  }

  void _handleReturnForRevision(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return const ReturnApplicationDialog();
      },
    );
  }

  void _handleApproveGovernmentId(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: 'Approve Application',
          message: 'Are you sure you want to approve this application',
          confirmButtonText: 'Approve',
          confirmButtonColor: kApproveButtonColor,
          onConfirm: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Government ID approved (placeholder action)'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }

  void _handleApproveProfessionalId(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: 'Approve Application',
          message: 'Are you sure you want to approve this application',
          confirmButtonText: 'Approve',
          confirmButtonColor: kApproveButtonColor,
          onConfirm: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Professional ID approved (placeholder action)'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }
}
