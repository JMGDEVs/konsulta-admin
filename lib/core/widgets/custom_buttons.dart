import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';

class CustomButtons {

  Widget filledButton(
    String? text,
    void Function()? onPressed,
    {
      bool isPrimaryColor = false,
      bool isLoading = false,
    }
  ) => FilledButton(
    onPressed: isLoading ? null : onPressed,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        isPrimaryColor ? AppColors.primary : AppColors.darkgreyColor,
      ),
    ),
    child: isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          )
        : Text(text ?? ''),
  );

}