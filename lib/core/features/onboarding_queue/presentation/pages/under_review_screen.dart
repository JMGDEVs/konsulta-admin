import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
import 'package:konsulta_admin/core/service/dependency_injection/injection.dart';
import 'package:konsulta_admin/core/widgets/layout/layout_container.dart';
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
    return Layout(
      child: BlocBuilder<OnboardingQueueBloc, OnboardingQueueState>(
        builder: (context, state) {
          // Check if an applicant is selected for review
          if (state.selectedApplicantForReview != null) {
            // Render ApplicantDetailsView with top padding only to show curved corners
            return _ApplicantDetailsView(
              applicant: state.selectedApplicantForReview!,
            );
          }

          // Otherwise, show the table view with top padding only
          return Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
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
          );
        },
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

    // Dispatch event to select applicant for review
    context.read<OnboardingQueueBloc>().add(
      SelectApplicantForReviewEvent(applicant),
    );
  }
}

// Applicant Details View Widget (Minimal Placeholder)
class _ApplicantDetailsView extends StatelessWidget {
  final ApplicantModel applicant;

  const _ApplicantDetailsView({required this.applicant});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Top bar with back button and reject button
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 80.0, top: 16.0),
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
            Container(
              margin: const EdgeInsets.only(right: 80.0, top: 16.0),
              child: SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _handleReject(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA4335),
                    foregroundColor: const Color(0xFFFFFFFF),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    minimumSize: const Size(170, 50),
                  ),
                  child: Text(
                    'Reject Applicant',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25, // 125% line height
                      letterSpacing: -0.32, // -2% of 16px
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Split Column Layout
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Applicant Details
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 80.0),
                  height: 526,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1A000000), // #0000001A
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
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
                          _formatDateTime(applicant.createdAt),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            color: const Color(0xFF6F6F6F),
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
                          applicant.birthDate != null ? _formatDate(applicant.birthDate) : 'MM/DD/YYYY',
                        ),
                        const SizedBox(height: 38),

                        // Status | Registered date
                        _buildFieldRow(
                          'Status',
                          applicant.verificationStatus ?? '---',
                          'Registered date',
                          applicant.createdAt != null ? _formatDate(applicant.createdAt) : 'MM/DD/YYYY',
                          isLeftStatus: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Gap between columns

              // Right Column - Document Cards
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Government ID Card
                      Container(
                        margin: const EdgeInsets.only(right: 80.0),
                        height: 420,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x1A000000), // #0000001A
                              offset: const Offset(0, 4),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                'Government ID',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25, // 125% line height
                                  letterSpacing: -0.48, // -2% of 24px
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Subtitle
                              Text(
                                'Official Passport Document',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25, // 125% line height
                                  letterSpacing: 0,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 15),

                              // File list items
                              _buildFileItem('GovernmentIdforkonsultagroup.png', '5.3 mb'),
                              const SizedBox(height: 10),
                              _buildFileItem('GovernmentIdforkonsultagroup.png', '5.3 mb'),

                              const SizedBox(height: 25),

                              // Divider line
                              Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFFF6F6F6),
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
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () => _handleReturnForRevision(context),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Color(0xFFE9E9E9),
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
                                            letterSpacing: -0.32, // -2% of 16px
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // Approve button
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () => _handleApproveGovernmentId(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0BC43C),
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
                                            letterSpacing: -0.32, // -2% of 16px
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
                      ),
                      const SizedBox(height: 20), // Gap between cards

                      // Professional ID Card
                      Container(
                        margin: const EdgeInsets.only(right: 80.0),
                        height: 420,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x1A000000), // #0000001A
                              offset: const Offset(0, 4),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                'Professional ID',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25, // 125% line height
                                  letterSpacing: -0.48, // -2% of 24px
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Subtitle
                              Text(
                                'Lawyer License',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25, // 125% line height
                                  letterSpacing: 0,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 15),

                              // File list items
                              _buildFileItem('ProfessionalIDforkonsultagroup.png', '5.3 mb'),
                              const SizedBox(height: 10),
                              _buildFileItem('ProfessionalIDforkonsultagroup.png', '5.3 mb'),

                              const SizedBox(height: 25),

                              // Divider line
                              Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFFF6F6F6),
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
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () => _handleReturnForRevision(context),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Color(0xFFE9E9E9),
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
                                            letterSpacing: -0.32, // -2% of 16px
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // Approve button
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () => _handleApproveProfessionalId(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0BC43C),
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
                                            letterSpacing: -0.32, // -2% of 16px
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

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy \'at\' h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'MM/DD/YYYY';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MM/dd/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
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
            letterSpacing: isStatus ? -0.32 : 0, // -2% of 16px for status
            color: isStatus ? const Color(0xFFFFC107) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldRow(String leftLabel, String leftValue, String rightLabel, String rightValue, {bool isLeftStatus = false}) {
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

  void _handleReject(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Reject Applicant',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to reject this applicant? This action cannot be undone.',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFileItem(String filename, String filesize) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFF5F5F5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000), // #00000040
            offset: const Offset(0, 4),
            blurRadius: 25,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // File icon
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              'assets/icons/material-symbols_file-open-outline-rounded.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 15), // Gap between icon and text

          // Filename and size
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
                    height: 1.25, // 125% line height
                    letterSpacing: -0.32, // -2% of 16px
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
                    height: 1.25, // 125% line height
                    letterSpacing: -0.28, // -2% of 14px
                    color: const Color(0xFF6F6F6F),
                  ),
                ),
              ],
            ),
          ),

          // View button
          Container(
            width: 57,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFFFC107),
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
                  letterSpacing: -0.28, // -2% of 14px
                  color: const Color(0xFFFFC107),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReturnForRevision(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Return for Revision',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to return this document for revision?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Government ID returned for revision (placeholder action)'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Return'),
            ),
          ],
        );
      },
    );
  }

  void _handleApproveGovernmentId(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Approve Government ID',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to approve this Government ID document?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Government ID approved (placeholder action)'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0BC43C),
                foregroundColor: Colors.white,
              ),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _handleApproveProfessionalId(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Approve Professional ID',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to approve this Professional ID document?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Professional ID approved (placeholder action)'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0BC43C),
                foregroundColor: Colors.white,
              ),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }
}
