import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:konsulta_admin/core/features/dashboard/dashboard_layout.dart';
import 'package:konsulta_admin/core/features/onboarding_queue/presentation/pages/pending_applications_screen.dart';

List<Widget> pages = [
  // home PARENT (Index 0)
  const HomeLayout(),

  // Onboarding Queue PARENT (Index 1) - Placeholder
  const Scaffold(body: Center(child: Text('Onboarding Queue Parent'))),

  // Pending Applications (Index 2)
  const PendingApplicationsScreen(),

  // Under Review (Index 3)
  const Center(child: Text('Under Review Screen')),

  // Verified (Index 4)
  const Center(child: Text('Verified Screen')),

  // Rejected (Index 5)
  const Center(child: Text('Rejected Screen')),
];

final List<Map<String, dynamic>> menuItems = [
  {
    'title': 'Dashboard',
    'icon': Symbols.space_dashboard_rounded,
    'children': [],
  },
  {
    'title': 'Onboarding Queue',
    'icon': Symbols.article_person, // or similar icon
    'children': [
      'Pending Applications',
      'Under Review',
      'Verified',
      'Rejected',
    ],
  },
  // {
  //   'title': 'Users',
  //   'icon': Symbols.article_person,
  //   'children': ['All Users', 'Roles', 'Permissions']
  // },
  // {
  //   'title': 'Settings',
  //   'icon': Icons.settings,
  //   'children': ['General', 'Security', 'Notifications']
  // },
];
