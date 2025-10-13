import 'package:bcode/shared_widgets/auth_logo.dart' show AuthLogo;
import 'package:bcode/shared_widgets/default_button.dart';
import 'package:bcode/shared_widgets/text_fields/default.dart';
import 'package:bcode/shared_widgets/text_fields/email.dart';
import 'package:bcode/shared_widgets/text_fields/password.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Sign Up screen for new user registration
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            context.showErrorSnackBar(state.message);
          } else if (state is Authenticated) {
            context.showSuccessSnackBar('account_created_successfully'.tr());
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Form content
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0).copyWith(top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AuthLogo(label: 'create_account'.tr()),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Full name field
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DefaultTextField(
                                            hint: 'first_name',
                                            _firstNameController,
                                            validator:
                                                Validators.validateFullName,
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: DefaultTextField(
                                            hint: 'last_name',
                                            _lastNameController,
                                            validator:
                                                Validators.validateFullName,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),
                                    // Email field
                                    EmailTextField(_emailController),
                                    const SizedBox(height: 16),
                                    PasswordTextField(_passwordController),
                                    const SizedBox(height: 16),
                                    PasswordTextField(
                                      _confirmPasswordController,
                                      hint: 'confirm_password',
                                      validator: (v) =>
                                          Validators.validateConfPassword(
                                            _passwordController.text,
                                            v,
                                          ),
                                    ),
                                    const SizedBox(height: 24),
                                    DefaultButton(
                                      label: 'sign_up'.tr(),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                           context.read<AuthBloc>().add(
                                            SignUpRequested(
                                              email: _emailController.text
                                                  .trim(),
                                              password:
                                                  _passwordController.text,
                                              firstName: _firstNameController
                                                  .text
                                                  .trim(),
                                              lastName: _lastNameController.text
                                                  .trim(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
