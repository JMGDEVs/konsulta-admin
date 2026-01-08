import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/theme/custom_theme.dart';

class ApplicationReviewScreen extends StatefulWidget {
  const ApplicationReviewScreen({super.key});

  @override
  State<ApplicationReviewScreen> createState() =>
      _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState extends State<ApplicationReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Application Review',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Applicant Details Placeholder',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _showRejectDialog(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reject',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _showApproveDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Approve',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showApproveDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 407,
          height: 211,
          child: Stack(
            children: [
              // Title - TOP: 29, LEFT: 20, RIGHT: 20
              Positioned(
                top: 29,
                left: 20,
                right: 20,
                child: Text(
                  'Approve Application',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
              // Body text - TOP: 66, LEFT: 63, RIGHT: 63
              Positioned(
                top: 66,
                left: 63,
                right: 63,
                child: Text(
                  'Are you sure you want to approve this application',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
              // Cancel button - TOP: 143, LEFT: 28, BOTTOM: 20, RIGHT: 209
              Positioned(
                top: 143,
                left: 28,
                right: 209,
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9E9E9),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              // Approve button - TOP: 143, LEFT: 209, RIGHT: 28, BOTTOM: 20
              Positioned(
                top: 143,
                left: 209,
                right: 28,
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Call approve API (future)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0BC43C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Approve',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 407,
          height: 211,
          child: Stack(
            children: [
              // Title - TOP: 29, LEFT: 20, RIGHT: 20
              Positioned(
                top: 29,
                left: 20,
                right: 20,
                child: Text(
                  'Reject Application',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
              // Body text - TOP: 66, LEFT: 63, RIGHT: 63
              Positioned(
                top: 66,
                left: 63,
                right: 63,
                child: Text(
                  'Are you sure you want to reject this application',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
              // Cancel button - TOP: 143, LEFT: 28, BOTTOM: 20, RIGHT: 209
              Positioned(
                top: 143,
                left: 28,
                right: 209,
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9E9E9),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              // Reject button - TOP: 143, LEFT: 209, RIGHT: 28, BOTTOM: 20
              Positioned(
                top: 143,
                left: 209,
                right: 28,
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Call reject API (future)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB4545),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Reject',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
