import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/signup/signup_background_decor.dart';
import '../widgets/signup/signup_form_content.dart';
import '../widgets/signup/signup_wide_layout.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (!_agreedToTerms) return;
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, cur) => prev.status != cur.status,
      listener: (listenerContext, state) async {
        if (state.status == AuthStatus.authenticated) {
          final curriculumCubit = listenerContext.read<CurriculumCubit>();
          await curriculumCubit.refresh();
          if (!listenerContext.mounted) return;
          listenerContext.go(
            curriculumCubit.state.hasSelection
                ? AppRoutes.dashboardPath
                : AppRoutes.onboardingPath,
          );
        } else if (state.status == AuthStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.localizedError(fallback: state.errorMessage),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            const SignupBackgroundDecor(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide =
                      constraints.maxWidth > AppDimensions.breakpointTablet;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: isWide
                          ? SignupWideLayout(
                              formKey: _formKey,
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmController: _confirmController,
                              obscurePassword: _obscurePassword,
                              obscureConfirm: _obscureConfirm,
                              agreedToTerms: _agreedToTerms,
                              onTogglePassword: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onToggleConfirm: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                              onTermsChanged: (val) =>
                                  setState(() => _agreedToTerms = val ?? false),
                              onCreateAccount: _onCreateAccount,
                            )
                          : SignupFormContent(
                              formKey: _formKey,
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmController: _confirmController,
                              obscurePassword: _obscurePassword,
                              obscureConfirm: _obscureConfirm,
                              agreedToTerms: _agreedToTerms,
                              onTogglePassword: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onToggleConfirm: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                              onTermsChanged: (val) =>
                                  setState(() => _agreedToTerms = val ?? false),
                              onCreateAccount: _onCreateAccount,
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
