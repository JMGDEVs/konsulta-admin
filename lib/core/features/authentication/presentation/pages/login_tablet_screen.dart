import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';
import 'package:konsulta_admin/core/widgets/custom_buttons.dart';
import 'package:konsulta_admin/core/widgets/custom_fields.dart';
import 'package:konsulta_admin/core/widgets/path_images.dart';

class LoginTabletScreen extends StatefulWidget {
  const LoginTabletScreen({super.key});

  @override
  State<LoginTabletScreen> createState() => _LoginTabletScreenState();
}

class _LoginTabletScreenState extends State<LoginTabletScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Expanded(
        child: Center(
          child: Container(
            width: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 100,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(child: Padding(
              padding: const EdgeInsets.all(40),
              child: contentCard(colorScheme),
            )),
          ),
        ),
      ),
    );
  }

  Widget contentCard(ColorScheme colorScheme) {
    final style = Theme.of(context).textTheme.titleMedium;
    final space20 = SizedBox(height: 20,);
    final space10 = SizedBox(height: 10,);
    final space40 = SizedBox(height: 40,);
    return Column(
      children: [
        Images().imageLogo(sizeHeight: 80, sizeWidth: 80),
        space20,
        Text(
          'Welcome Admin!',
          style: style?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 28
          ),
        ),
        space10,
        Text(
          'Please enter your details to sign in',
          style: style?.copyWith(
            fontSize: 14,
            color: AppColors.grayText
          ),
        ),
        space40,
        CustomTextFormField(
          label: 'Email Address',
          controller: TextEditingController(),
        ),
        space20,
        CustomTextFormField(
          label: 'Password',
          controller: TextEditingController(),
        ),
        space20,
        Row(
          children: [
            Checkbox(
              value: true, 
              onChanged: (value) {
                
              },
            ),
            Text(
              'Remember Me',
              style: style,
            ),
            Spacer(),
            Text(
              'Forgot Password?',
               style: style?.copyWith(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary
              ),
            ),
            
          ],
        ),
        space40,
        SizedBox(
          height: 50,
          width: double.infinity,
          child: CustomButtons().filledButton(
            'Sign In', 
            () {
                
            },
          ),
        ),
      ],
    );
  }
}