import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/login/login_background_decor.dart';
import '../widgets/login/login_narrow_layout.dart';
import '../widgets/login/login_wide_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signIn(
        email: _identityController.text.trim(),
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
            const LoginBackgroundDecor(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide =
                      constraints.maxWidth > AppDimensions.breakpointTablet;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: isWide
                          ? LoginWideLayout(
                              formKey: _formKey,
                              identityController: _identityController,
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              onToggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onSignIn: _onSignIn,
                            )
                          : LoginNarrowLayout(
                              formKey: _formKey,
                              identityController: _identityController,
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              onToggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onSignIn: _onSignIn,
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
