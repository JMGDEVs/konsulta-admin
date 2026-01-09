import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dialog for returning an application for revision
///
/// Allows admin to select a reason from dropdown and optionally provide
/// additional details in the text field
class ReturnApplicationDialog extends StatefulWidget {
  const ReturnApplicationDialog({super.key});

  @override
  State<ReturnApplicationDialog> createState() => _ReturnApplicationDialogState();
}

class _ReturnApplicationDialogState extends State<ReturnApplicationDialog> {
  final TextEditingController _otherController = TextEditingController();
  String? _selectedReason;

  final List<String> _reasons = [
    'Incomplete information',
    'Invalid documents',
    'Poor image quality',
    'Expired credentials',
    'Other',
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: 413,
        height: 461,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0x33000000),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Title - TOP: 39, LEFT: 108, RIGHT: 107, BOTTOM: 395
            Positioned(
              top: 39,
              left: 108,
              right: 107,
              bottom: 395,
              child: Text(
                'Return Application',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                ),
              ),
            ),
            // Reason for returning container (label + dropdown) - TOP: 86, LEFT: 20, RIGHT: 20, BOTTOM: 307
            Positioned(
              top: 86,
              left: 20,
              right: 20,
              bottom: 307,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reason for returning:',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  PopupMenuButton<String>(
                    offset: const Offset(0, 49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFFBABABA)),
                    ),
                    color: Colors.white,
                    elevation: 8,
                    constraints: const BoxConstraints(minWidth: 373),
                    child: Container(
                      height: 39,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFBABABA)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedReason ?? 'Choose reason',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _selectedReason == null
                                  ? const Color(0xFF6F6F6F)
                                  : Colors.black,
                              height: 1.0,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context) {
                      // Add reset option at the top, then the actual reasons
                      final List<PopupMenuItem<String>> items = [];

                      // Reset option - sets selection back to null
                      items.add(
                        PopupMenuItem<String>(
                          value: '__RESET__', // Sentinel value for reset
                          height: 48,
                          child: Text(
                            '-- Choose reason --',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              height: 1.0,
                              color: const Color(0xFF6F6F6F),
                            ),
                          ),
                        ),
                      );

                      // Add all the actual reasons
                      items.addAll(
                        _reasons.map((String reason) {
                          return PopupMenuItem<String>(
                            value: reason,
                            height: 48,
                            child: Text(
                              reason,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                              ),
                            ),
                          );
                        }),
                      );

                      return items;
                    },
                    onSelected: (String newValue) {
                      setState(() {
                        // If reset option is selected, set to null
                        if (newValue == '__RESET__') {
                          _selectedReason = null;
                        } else {
                          _selectedReason = newValue;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            // Other container (label + text field) - TOP: 174, LEFT: 20, RIGHT: 20, BOTTOM: 108
            Positioned(
              top: 174,
              left: 20,
              right: 20,
              bottom: 108,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Other (Optional):',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFBABABA)),
                      ),
                      child: TextField(
                        controller: _otherController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(10),
                          hintText: '',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF6F6F6F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Cancel button - TOP: 393, LEFT: 20, RIGHT: 213, BOTTOM: 20
            Positioned(
              top: 393,
              left: 20,
              right: 213,
              bottom: 20,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9E9E9),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
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
            // Continue button - TOP: 393, LEFT: 213, RIGHT: 20, BOTTOM: 20
            Positioned(
              top: 393,
              left: 213,
              right: 20,
              bottom: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Placeholder for future API integration
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0BC43C),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                child: Text(
                  'Continue',
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
    );
  }
}
