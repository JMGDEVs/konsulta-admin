import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/constants/under_review_dialog_constants.dart';

/// A reusable confirmation dialog for approve/reject actions
///
/// This dialog replaces three duplicate dialogs:
/// - Reject Application dialog
/// - Approve Government ID dialog
/// - Approve Professional ID dialog
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final Color confirmButtonColor;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.confirmButtonColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDialogBorderRadius),
      ),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: kDialogWidth,
        height: kDialogHeight,
        child: Stack(
          children: [
            // Title
            Positioned(
              top: kDialogTitleTop,
              left: kDialogTitleLeft,
              right: kDialogTitleRight,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: kDialogTitleFontSize,
                  fontWeight: kDialogTitleFontWeight,
                  height: kDialogTitleLineHeight,
                ),
              ),
            ),
            // Body text
            Positioned(
              top: kDialogBodyTop,
              left: kDialogBodyLeft,
              right: kDialogBodyRight,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: kDialogBodyFontSize,
                  fontWeight: kDialogBodyFontWeight,
                  height: kDialogBodyLineHeight,
                ),
              ),
            ),
            // Cancel button
            Positioned(
              top: kDialogButtonTop,
              left: kDialogButtonLeft,
              right: kDialogButtonRight,
              bottom: kDialogButtonBottom,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kCancelButtonColor,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: kDialogButtonFontSize,
                    fontWeight: FontWeight.w500,
                    height: kDialogButtonLineHeight,
                  ),
                ),
              ),
            ),
            // Confirm button
            Positioned(
              top: kDialogButtonTop,
              left: kDialogButtonRight,
              right: kDialogButtonLeft,
              bottom: kDialogButtonBottom,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmButtonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  confirmButtonText,
                  style: GoogleFonts.inter(
                    fontSize: kDialogButtonFontSize,
                    fontWeight: kDialogButtonFontWeight,
                    height: kDialogButtonLineHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
