import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';

class Layout extends StatefulWidget {
  final Widget child;
  const Layout({
    super.key,
    required this.child,
  });

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.greybackgroundcolor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: widget.child,
      ),
    );

  }
}