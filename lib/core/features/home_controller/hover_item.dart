import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';

class HoverMenuItem extends StatefulWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final Icon icon;
  final int index;

  const HoverMenuItem({
    super.key, 
    required this.text,
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.index,
  });

  @override
  State<HoverMenuItem> createState() => _HoverMenuItemState();
}

class _HoverMenuItemState extends State<HoverMenuItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool showBorder = widget.selected;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          // width: 100, // remove this
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: isHovering ? 5 : 0),
            child: Transform.translate(
              offset: Offset(isHovering ? 0 : 0, 3),
              child: Column(
                children: [
                  Row(
                    children: [
                      widget.icon,
                      SizedBox(width: 20),
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: widget.selected ? FontWeight.w500 : FontWeight.normal,
                          color: widget.selected ? AppColors.primary : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
