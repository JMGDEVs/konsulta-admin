import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:konsulta_admin/core/features/dashboard/dashboard_layout.dart';

List<Widget> pages = [
  // home PARENT
  const HomeLayout(),
  // CHILDREN of HOME
  // Layout(
  //   child: Center(
  //     child: Text('All Users Page'), // SAMPLE OF CHILDREN 
  //   ),
  // )

];

final List<Map<String, dynamic>> menuItems = [
  {
    'title': 'Home',
    'icon': Symbols.space_dashboard,
    'children': []
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
