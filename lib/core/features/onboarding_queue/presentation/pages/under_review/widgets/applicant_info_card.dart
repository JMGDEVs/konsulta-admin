import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/constants/under_review_layout_constants.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/utils/date_formatters.dart';

/// Widget for displaying applicant information in a card
///
/// Shows applicant details including name, profession, contact info, etc.
class ApplicantInfoCard extends StatelessWidget {
  final ApplicantModel applicant;

  const ApplicantInfoCard({
    super.key,
    required this.applicant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kScreenHorizontalMargin),
      height: kApplicantCardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: kCardShadowColor,
            offset: Offset(0, kCardShadowOffsetY),
            blurRadius: kCardShadowBlurRadius,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(kCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Applicant Details',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Timestamp
            Text(
              DateFormatters.formatDateTime(applicant.createdAt),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.0,
                color: kTextGray,
              ),
            ),
            const SizedBox(height: 49),

            // Name | Profession
            _buildFieldRow(
              'Name',
              applicant.fullName.isNotEmpty ? applicant.fullName : '---',
              'Profession',
              applicant.professionalTag ?? '---',
            ),
            const SizedBox(height: 38),

            // Phone number | Email address
            _buildFieldRow(
              'Phone number',
              applicant.phone ?? '---',
              'Email address',
              applicant.email ?? '---',
            ),
            const SizedBox(height: 38),

            // Gender | Birthdate
            _buildFieldRow(
              'Gender',
              applicant.gender ?? '---',
              'Birthdate',
              applicant.birthDate != null
                  ? DateFormatters.formatDate(applicant.birthDate)
                  : 'MM/DD/YYYY',
            ),
            const SizedBox(height: 38),

            // Status | Registered date
            _buildFieldRow(
              'Status',
              applicant.verificationStatus ?? '---',
              'Registered date',
              applicant.createdAt != null
                  ? DateFormatters.formatDate(applicant.createdAt)
                  : 'MM/DD/YYYY',
              isLeftStatus: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.3,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: isStatus ? FontWeight.w600 : FontWeight.w500,
            height: 1.3,
            letterSpacing: isStatus ? -0.32 : 0,
            color: isStatus ? kAmberColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldRow(
    String leftLabel,
    String leftValue,
    String rightLabel,
    String rightValue, {
    bool isLeftStatus = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildField(leftLabel, leftValue, isStatus: isLeftStatus),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _buildField(rightLabel, rightValue),
        ),
      ],
    );
  }
}
