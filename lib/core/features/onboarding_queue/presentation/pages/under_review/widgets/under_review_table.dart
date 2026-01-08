import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/bloc/onboarding_queue_bloc.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/under_review/utils/date_formatters.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Table widget for displaying Under Review applicants
///
/// Shows applicant list with columns for name, profession, contact info, etc.
class UnderReviewTable extends StatelessWidget {
  const UnderReviewTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingQueueBloc, OnboardingQueueState>(
      builder: (context, state) {
        if (state.isUnderReviewLoading && state.underReviewApplicants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 1200,
              headingRowDecoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              dataRowColor: WidgetStateProperty.all(Colors.white),
              border: const TableBorder(
                horizontalInside: BorderSide(color: Color(0xFFE9E9E9), width: 1),
              ),
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
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      applicant.professionalTag ?? '---',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      applicant.phone ?? '---',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      applicant.email ?? '---',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      applicant.verificationStatus ?? 'Pending',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        letterSpacing: -0.32,
                        color: const Color(0xFFFFC107), // Yellow text, no background
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      applicant.gender ?? '---',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      DateFormatters.formatDateForTable(applicant.birthDate),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      DateFormatters.formatDateForTable(applicant.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: -0.32,
                      ),
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
          ),
        );
      },
    );
  }

  Widget _buildColumnHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.3, // 130% line height
        letterSpacing: -0.32, // -2% of 16px
        color: Colors.black,
      ),
    );
  }

  void _onSort(BuildContext context, int columnIndex, bool ascending) {
    context.read<OnboardingQueueBloc>().add(
          SortApplicantsEvent(ascending, columnIndex),
        );
  }

  void _handleReview(BuildContext context, ApplicantModel applicant) {
    if (applicant.id == null) return;

    context.read<OnboardingQueueBloc>().add(
          SelectApplicantForReviewEvent(applicant),
        );
  }
}
