import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

// Sentinel value for "ALL" option in profession dropdown
const String kAllProfessionsFilter = '__ALL__';

/// Widget for the filters section of the Under Review screen
///
/// Contains search bar, profession dropdown, and sort button
class UnderReviewFilters extends StatelessWidget {
  final TextEditingController searchController;

  const UnderReviewFilters({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Bar
        SizedBox(
          width: 400,
          height: 45,
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              context.read<OnboardingQueueBloc>().add(UpdateSearchEvent(value));
            },
            decoration: InputDecoration(
              hintText: 'Search name, number, or email...',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF000000),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.3,
                letterSpacing: -0.32,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20,
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.3,
              letterSpacing: -0.32,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Profession Dropdown
        SizedBox(
          width: 254,
          height: 45,
          child: PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            color: Colors.white,
            elevation: 8,
            constraints: const BoxConstraints(minWidth: 254),
            child: Container(
              width: 254,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.select(
                      (OnboardingQueueBloc bloc) {
                        final profId = bloc.state.underReviewProfessionId;
                        return (profId == null || profId == kAllProfessionsFilter)
                            ? 'ALL'
                            : profId;
                      },
                    ),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.32,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
            ),
            itemBuilder: (context) {
              final state = context.read<OnboardingQueueBloc>().state;
              final professionOptions = ['ALL', ...state.professionalTags];

              return professionOptions
                  .map(
                    (role) => PopupMenuItem<String>(
                      value: role == 'ALL' ? kAllProfessionsFilter : role,
                      height: 48,
                      child: Text(
                        role,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                          letterSpacing: -0.32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) {
              final professionId = (value == kAllProfessionsFilter) ? null : value;
              context.read<OnboardingQueueBloc>().add(
                    UpdateProfessionalTagEvent(professionId),
                  );
            },
          ),
        ),
        const Spacer(),

        // Sort By Button
        SizedBox(
          width: 117,
          height: 45,
          child: PopupMenuButton<bool>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.white,
            elevation: 4,
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Container(
              height: 45,
              padding: const EdgeInsets.only(left: 15, right: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Symbols.sort, size: 24, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    'Sort by',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.32,
                    ),
                  ),
                ],
              ),
            ),
            itemBuilder: (context) {
              final state = context.read<OnboardingQueueBloc>().state;
              final isNewest = state.underReviewSortColumnIndex == 7 && !state.underReviewSortAscending;
              final isOldest = state.underReviewSortColumnIndex == 7 && state.underReviewSortAscending;

              return [
                PopupMenuItem(
                  value: false, // Newest
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        isNewest
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 24,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Updated (Newest)',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                          letterSpacing: -0.32,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: true, // Oldest
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        isOldest
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 24,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Updated (Oldest)',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                          letterSpacing: -0.32,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (ascending) {
              context.read<OnboardingQueueBloc>().add(
                    SortApplicantsEvent(ascending, 7),
                  );
            },
          ),
        ),
      ],
    );
  }
}
