import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/constants/under_review_layout_constants.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/widgets/file_item_widget.dart';

/// A reusable document card widget for displaying Government ID or Professional ID
///
/// This widget replaces the duplicated code for:
/// - Government ID Card (lines 739-883)
/// - Professional ID Card (lines 887-1031)
class DocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, String>> files; // List of {filename, filesize}
  final VoidCallback onApprove;
  final VoidCallback onReturnForRevision;

  const DocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.files,
    required this.onApprove,
    required this.onReturnForRevision,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: kScreenHorizontalMargin),
      height: kDocumentCardHeight,
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
              title,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.25,
                letterSpacing: -0.48,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.25,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            // File list items
            ...files.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return Column(
                children: [
                  if (index > 0) const SizedBox(height: 10),
                  FileItemWidget(
                    filename: file['filename'] ?? '',
                    filesize: file['filesize'] ?? '',
                  ),
                ],
              );
            }),

            const SizedBox(height: 21),

            // Divider line
            Container(
              height: 2,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: kDividerGray,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Action buttons
            Row(
              children: [
                // Return for revision button
                Expanded(
                  child: SizedBox(
                    height: kReturnButtonHeight,
                    child: OutlinedButton(
                      onPressed: onReturnForRevision,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: kLightGray,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        minimumSize: const Size(261, 50),
                      ),
                      child: Text(
                        'Return for revision',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          letterSpacing: -0.32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: kButtonGap),

                // Approve button
                Expanded(
                  child: SizedBox(
                    height: kApproveButtonHeight,
                    child: ElevatedButton(
                      onPressed: onApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreenButton,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        minimumSize: const Size(261, 50),
                        elevation: 0,
                      ),
                      child: Text(
                        'Approve',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          letterSpacing: -0.32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
