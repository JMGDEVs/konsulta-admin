import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konsulta_admin/core/widgets/layout/layout_container.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeStateWeb extends StatefulWidget {
  const HomeStateWeb({super.key});

  @override
  State<HomeStateWeb> createState() => _HomeStateWebState();
}

class _HomeStateWebState extends State<HomeStateWeb> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 40, 80, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Summary',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Monitor and manage all applications at a glance — from Pending and In Review to Verified or Rejected.',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Pending Applications',
                    count: '210',
                    icon: Symbols.cards_stack,
                    iconColor: const Color(0xFFFFC107),
                    iconBackgroundColor: const Color(0xFFFFF8E1), // Light Amber
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _SummaryCard(
                    title: 'Verified Professional',
                    count: '520',
                    icon: Symbols.check_box,
                    iconColor: const Color(0xFF00C217),
                    iconBackgroundColor: const Color(0xFFE8F5E9), // Light Green
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _SummaryCard(
                    title: 'Rejected Applications',
                    count: '25',
                    icon: Symbols.computer_cancel,
                    iconColor: const Color(0xFFFB4545),
                    iconBackgroundColor: const Color(0xFFFFEBEE), // Light Red
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _SummaryCard(
                    title: 'Return for Revision',
                    count: '12',
                    icon: Symbols.published_with_changes,
                    iconColor: const Color(0xFFFFC107),
                    iconBackgroundColor: const Color(0xFFFFF8E1), // Light Amber
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
