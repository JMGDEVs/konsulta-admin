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
import 'package:konsulta_admin/core/widgets/layout/layout_container.dart';
import 'package:material_symbols_icons/symbols.dart';

class PendingApplicationsScreen extends StatelessWidget {
  const PendingApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingQueueBloc>(),
      child: const PendingApplicationsView(),
    );
  }
}

class PendingApplicationsView extends StatefulWidget {
  const PendingApplicationsView({super.key});

  @override
  State<PendingApplicationsView> createState() =>
      _PendingApplicationsViewState();
}

class _PendingApplicationsViewState extends State<PendingApplicationsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set active screen to Pending
    context.read<OnboardingQueueBloc>().add(
      SetActiveScreenEvent(ActiveScreen.pending),
    );
    // Trigger the event to fetch pending applicants
    context.read<OnboardingQueueBloc>().add(GetPendingApplicantsEvent());
    // Fetch professional tags from API
    context.read<OnboardingQueueBloc>().add(GetProfessionalTagsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Applications',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select an application to move it under your review',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _buildFilters(context),
            const SizedBox(height: 24),
            Expanded(child: _buildTable(context)),
          ],
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
                          bloc.state.pendingProfessionId ?? 'Profession',
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
              return state.professionalTags
                  .map(
                    (tag) => PopupMenuItem<String>(
                      value: tag,
                      height: 48,
                      child: Text(
                        tag,
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
              final isNewest =
                  state.pendingSortColumnIndex == 7 &&
                  !state.pendingSortAscending;
              final isOldest =
                  state.pendingSortColumnIndex == 7 &&
                  state.pendingSortAscending;

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
        if (state.isLoading && state.applicants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load applications',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
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
            sortColumnIndex: state.pendingSortColumnIndex,
            sortAscending: state.pendingSortAscending,
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
            rows: state.applicants.map((applicant) {
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
                          horizontal: 12,
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
                              Symbols.tab_move,
                              size: 16,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Handle',
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

    context.read<OnboardingQueueBloc>().add(
      StartReviewEvent(
        applicantId: applicant.id!,
        onSuccess: () {
          // Show dialog "Application moved"
          showDialog(
            context: context,
            barrierColor: Colors.black54,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(24),
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Symbols.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Application moved',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Symbols.close,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: 'You can now review it in '),
                            TextSpan(
                              text: 'Under Review',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).then((_) {
            if (context.mounted) {
              context.push(RoutePaths.underReview);
            }
          });
        },
      ),
    );
  }
}
