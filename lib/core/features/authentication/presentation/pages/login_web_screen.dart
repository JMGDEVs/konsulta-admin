import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsulta_admin/core/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';
import 'package:konsulta_admin/core/widgets/custom_buttons.dart';
import 'package:konsulta_admin/core/widgets/custom_fields.dart';
import 'package:konsulta_admin/core/widgets/path_images.dart';

class LoginWebScreen extends StatefulWidget {
  const LoginWebScreen({super.key});

  @override
  State<LoginWebScreen> createState() => _LoginWebScreenState();
}

class _LoginWebScreenState extends State<LoginWebScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        
        return Column(
          spacing: 68,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 31),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Images().imageLogoWithName(sizeWidth: 300, sizeHeight: 70),
              ),
            ),
        
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 430,
                    width: 550,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: colorScheme.primary.withOpacity(0.09),
                          blurRadius: 80,
                          spreadRadius: 0,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                  ),
        
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 100,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: contentCard(colorScheme, context, state)
                      )
                    ),
                  ),
                ],
              ),
            ),
            Container()
          ],
        );
      }
    );
  }

  Widget contentCard(ColorScheme colorScheme, BuildContext context, AuthState state) {
    final style = Theme.of(context).textTheme.titleMedium;
    final space20 = SizedBox(height: 20,);
    final space10 = SizedBox(height: 10,);
    final space40 = SizedBox(height: 40,);
    return Column(
      children: [
        Images().imageLogo(sizeHeight: 100, sizeWidth: 100),
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
          controller: usernameController,
        ),
        space20,
        CustomTextFormField(
          label: 'Password',
          controller: passwordController,
        ),
        if (state is LoginFailed) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${state.message}*',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
            ),
          ),
        ],
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
            isLoading: state is ButtonLoading,
            'Sign In', 
            () {
              context.read<AuthBloc>().add(OnLogin(usernameController.text, passwordController.text));
            },
          ),
        ),
      ],
    );
  }
}