import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';

class CustomButtons {

  Widget filledButton(String? text, void Function()? onPressed, {bool isPrimaryColor = false}) => FilledButton(
    onPressed: onPressed,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(isPrimaryColor ? AppColors.primary : AppColors.darkgreyColor)
    ),
    child: Text(text ?? ''),
  );

}