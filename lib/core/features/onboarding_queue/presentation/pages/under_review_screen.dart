import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
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
            child: BlocBuilder<OnboardingQueueBloc, OnboardingQueueState>(
              builder: (context, state) {
                // Check if an applicant is selected for review
                if (state.selectedApplicantForReview != null) {
                  return _ApplicantDetailsView(
                    applicant: state.selectedApplicantForReview!,
                  );
                }

                // Otherwise, show the table view
                return Column(
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
                );
              },
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

    // Dispatch event to select applicant for review
    context.read<OnboardingQueueBloc>().add(
      SelectApplicantForReviewEvent(applicant),
    );
  }
}

// Applicant Details View Widget (Placeholder)
class _ApplicantDetailsView extends StatelessWidget {
  final ApplicantModel applicant;

  const _ApplicantDetailsView({required this.applicant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar with back button and reject button
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<OnboardingQueueBloc>().add(
                  ClearSelectedApplicantEvent(),
                );
              },
              tooltip: 'Back to list',
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _handleReject(context),
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Reject Applicant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Applicant Details Title
        Text(
          'Applicant Details',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'December 4, 2025 at 7:49 am',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),

        // Applicant Information (Placeholder)
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Personal Information
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Name', applicant.fullName),
                          const SizedBox(height: 16),
                          _buildInfoRow('Profession', applicant.professionalTag ?? '---'),
                          const SizedBox(height: 16),
                          _buildInfoRow('Phone number', applicant.phone ?? '---'),
                          const SizedBox(height: 16),
                          _buildInfoRow('Email address', applicant.email ?? '---'),
                          const SizedBox(height: 16),
                          _buildInfoRow('Gender', applicant.gender ?? '---'),
                          const SizedBox(height: 16),
                          _buildInfoRow('Birthdate', applicant.birthDate ?? 'MM/DD/YYYY'),
                          const SizedBox(height: 16),
                          _buildInfoRow('Status', applicant.verificationStatus ?? 'Pending'),
                          const SizedBox(height: 16),
                          _buildInfoRow('Registered date', applicant.createdAt ?? 'MM/DD/YYYY'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // Right column - Document Placeholders
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Government ID Section
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Government ID',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Official Passport Document',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    'Document Preview Placeholder',
                                    style: GoogleFonts.inter(color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => _handleReturnForRevision(context, 'Government ID'),
                                      child: const Text('Return for revision'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _handleApprove(context, 'Government ID'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Approve'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Professional ID Section
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Professional ID',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Lawyer License',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    'Document Preview Placeholder',
                                    style: GoogleFonts.inter(color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => _handleReturnForRevision(context, 'Professional ID'),
                                      child: const Text('Return for revision'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _handleApprove(context, 'Professional ID'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Approve'),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _handleApprove(BuildContext context, String documentType) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Approve $documentType',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to approve this $documentType?',
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
                  SnackBar(
                    content: Text('$documentType approved (placeholder action)'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _handleReturnForRevision(BuildContext context, String documentType) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Return for Revision',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Request revision for this $documentType?',
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
                  SnackBar(
                    content: Text('$documentType returned for revision (placeholder action)'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
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
}
