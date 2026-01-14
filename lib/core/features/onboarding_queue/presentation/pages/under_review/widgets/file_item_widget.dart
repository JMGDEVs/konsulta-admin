import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/constants/under_review_layout_constants.dart';

/// A reusable widget for displaying file items with icon, filename, size, and view button
///
/// Used in Government ID and Professional ID document cards
class FileItemWidget extends StatelessWidget {
  final String filename;
  final String filesize;
  final VoidCallback? onView;

  const FileItemWidget({
    super.key,
    required this.filename,
    required this.filesize,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kFileItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: kBorderGray,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(kFileItemBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: kFileShadowColor,
            offset: Offset(0, 1),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: kFileItemIconSize,
            height: kFileItemIconSize,
            child: Image.asset(
              'assets/icons/material-symbols_file-open-outline-rounded.png',
              width: kFileItemIconSize,
              height: kFileItemIconSize,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  filename,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    letterSpacing: -0.32,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  filesize,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    letterSpacing: -0.28,
                    color: kTextGray,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onView,
            child: Container(
              width: kFileItemViewButtonWidth,
              height: kFileItemViewButtonHeight,
              decoration: BoxDecoration(
                border: Border.all(
                  color: kAmberColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'View',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    letterSpacing: -0.28,
                    color: kAmberColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
