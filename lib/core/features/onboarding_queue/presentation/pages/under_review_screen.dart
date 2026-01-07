import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
import 'package:konsulta_admin/core/features/router/route_paths.dart';
import 'package:konsulta_admin/core/service/dependency_injection/injection.dart';
import 'package:material_symbols_icons/symbols.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0.5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                _buildFilters(context),
                const SizedBox(height: 24),
                Expanded(child: _buildTable(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Row(
      children: [
        // Search Bar
        SizedBox(
          width: 400,
          height: 45,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              // Immediate update as requested
              context.read<OnboardingQueueBloc>().add(UpdateSearchEvent(value));
            },
            // Removed search button as per task requirements
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
                      (OnboardingQueueBloc bloc) =>
                        bloc.state.underReviewProfessionId ?? 'Profession',
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
              return ['Doctor', 'Nurse', 'Psychologist', 'Midwife']
                  .map(
                    (role) => PopupMenuItem<String>(
                      value: role,
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
              context.read<OnboardingQueueBloc>().add(
                UpdateProfessionalTagEvent(value),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        // Search Button
        SizedBox(
          width: 117,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              // Search button action
              context.read<OnboardingQueueBloc>().add(
                GetUnderReviewApplicantsEvent(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.only(left: 15, right: 20),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  'Search',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    letterSpacing: -0.32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
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
            // Default check logic: Sort by 'Registered date' (index 7)
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

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<OnboardingQueueBloc, OnboardingQueueState>(
      builder: (context, state) {
        if (state.isUnderReviewLoading && state.underReviewApplicants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 1200,
            headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
            sortColumnIndex: state.underReviewSortColumnIndex,
            sortAscending: state.underReviewSortAscending,
            columns: [
              DataColumn2(
                label: _buildColumnHeader('Name'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              DataColumn2(
                label: _buildColumnHeader('Profession'),
                size: ColumnSize.M,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              DataColumn2(
                label: _buildColumnHeader('Phone number'),
                size: ColumnSize.M,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              DataColumn2(
                label: _buildColumnHeader('Email address'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              DataColumn2(
                label: _buildColumnHeader('Status'),
                size: ColumnSize.S,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              DataColumn2(
                label: _buildColumnHeader('Gender'),
                size: ColumnSize.S,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              DataColumn2(
                label: _buildColumnHeader('Birthdate'),
                size: ColumnSize.M,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              DataColumn2(
                label: _buildColumnHeader('Registered date'),
                size: ColumnSize.M,
                onSort: (columnIndex, ascending) =>
                    _onSort(context, columnIndex, ascending),
              ),
              const DataColumn2(label: Text(''), size: ColumnSize.S),
            ],
            rows: state.underReviewApplicants.map((applicant) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      applicant.fullName,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Text(
                      applicant.professionalTag ?? '---',
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  DataCell(
                    Text(applicant.phone ?? '---', style: GoogleFonts.inter()),
                  ),
                  DataCell(
                    Text(applicant.email ?? '---', style: GoogleFonts.inter()),
                  ),
                  DataCell(
                    Text(
                      applicant.verificationStatus ?? 'Pending',
                      style: GoogleFonts.inter(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(applicant.gender ?? '---', style: GoogleFonts.inter()),
                  ),
                  DataCell(
                    Text(
                      _formatDate(applicant.birthDate),
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  DataCell(
                    Text(
                      _formatDate(applicant.createdAt),
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  DataCell(
                    InkWell(
                      onTap: () => _handleReview(context, applicant),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Symbols.exit_to_app,
                              size: 16,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Review',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildColumnHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '---';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _onSort(BuildContext context, int columnIndex, bool ascending) {
    context.read<OnboardingQueueBloc>().add(
      SortApplicantsEvent(ascending, columnIndex),
    );
  }

  void _handleReview(BuildContext context, ApplicantModel applicant) {
    if (applicant.id == null) return;

    // Navigate directly to application review screen
    if (context.mounted) {
      context.push(RoutePaths.applicationReview);
    }
  }
}
