import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final String? hintText;

  const CustomTextFormField({
    super.key,
    this.label,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    BorderSide borderSide = BorderSide(color: AppColors.divider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10), 
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: borderSide
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: borderSide
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              // borderSide: borderSide
            ),
          ),
        ),
      ],
    );
  }
}
