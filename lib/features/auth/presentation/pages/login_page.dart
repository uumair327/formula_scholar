import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/auth_cubit.dart';

/// Login page — the entry-point of the app before onboarding / dashboard.
///
/// Two-column layout on large screens (brand left column + form right column).
/// Single-column on small screens (form only, with brand label at top).
///
/// Design faithfully implemented from Login.tsx in the React prototype.
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
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go(AppRoutes.onboardingPath);
        } else if (state.status == AuthStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
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
        backgroundColor: AppColors.surface,
        body: Stack(
          children: [
            _BackgroundDecor(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: isWide
                          ? _WideLayout(
                              formKey: _formKey,
                              identityController: _identityController,
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              onToggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onSignIn: _onSignIn,
                            )
                          : _NarrowLayout(
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

// ── Background decorative blobs ────────────────────────────────────

class _BackgroundDecor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top:
              -AppDimensions.decorativeBlurLG *
              AppDimensions.decorativePositionFraction,
          right:
              -AppDimensions.decorativeBlurLG *
              AppDimensions.decorativePositionFraction,
          child: Container(
            width: AppDimensions.decorativeBlurLG,
            height: AppDimensions.decorativeBlurLG,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryFixed.withValues(
                alpha: AppDimensions.opacityFaint,
              ),
            ),
          ),
        ),
        Positioned(
          bottom:
              -AppDimensions.decorativeBlurSM *
              AppDimensions.decorativePositionFraction,
          left:
              -AppDimensions.decorativeBlurSM *
              AppDimensions.decorativePositionFraction,
          child: Container(
            width: AppDimensions.decorativeBlurMD,
            height: AppDimensions.decorativeBlurMD,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondaryFixed.withValues(
                alpha: AppDimensions.opacityFaint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Wide (two-column) layout ───────────────────────────────────────

class _WideLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  const _WideLayout({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [AppShadows.ghost],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(flex: 5, child: _BrandColumn()),
          Expanded(
            flex: 5,
            child: _FormColumn(
              formKey: formKey,
              identityController: identityController,
              passwordController: passwordController,
              obscurePassword: obscurePassword,
              onToggleObscure: onToggleObscure,
              onSignIn: onSignIn,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Narrow (single-column) layout ─────────────────────────────────

class _NarrowLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  const _NarrowLayout({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingHero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appName,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: AppDimensions.letterSpacingTight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingHero),
          _FormContent(
            formKey: formKey,
            identityController: identityController,
            passwordController: passwordController,
            obscurePassword: obscurePassword,
            onToggleObscure: onToggleObscure,
            onSignIn: onSignIn,
          ),
        ],
      ),
    );
  }
}

// ── Brand column (left) ───────────────────────────────────────────

class _BrandColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
              vertical: AppDimensions.paddingXS,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            ),
            child: Text(
              AppStrings.loginStudentPortal,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: AppDimensions.letterSpacingWide,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            AppStrings.loginBrandTagline,
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w900,
              height: AppDimensions.lineHeightTight,
              letterSpacing: AppDimensions.letterSpacingTight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            AppStrings.loginBrandDesc,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary.withValues(
                alpha: AppDimensions.opacityHigh,
              ),
              height: AppDimensions.lineHeightRelaxed,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingHero),
          // Formula cards
          _FormulaCard(formula: 'e = mc²', rotation: -0.035),
          const SizedBox(height: AppDimensions.paddingMD),
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.paddingHero),
            child: _FormulaCard(formula: 'a² + b² = c²', rotation: 0.052),
          ),
        ],
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  final String formula;
  final double rotation;

  const _FormulaCard({required this.formula, required this.rotation});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: AppDimensions.opacitySubtle),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Text(
          formula,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

// ── Form column (right, also reused in narrow layout) ────────────

class _FormColumn extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  const _FormColumn({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHero,
        vertical: AppDimensions.paddingXXL,
      ),
      child: _FormContent(
        formKey: formKey,
        identityController: identityController,
        passwordController: passwordController,
        obscurePassword: obscurePassword,
        onToggleObscure: onToggleObscure,
        onSignIn: onSignIn,
      ),
    );
  }
}

class _FormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  const _FormContent({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.loginTitle,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: AppDimensions.letterSpacingTight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            AppStrings.loginSubtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // ── Email/username field ──
          _AuthLabel(AppStrings.loginEmailLabel),
          const SizedBox(height: AppDimensions.paddingXS),
          _AuthTextField(
            controller: identityController,
            hint: AppStrings.loginEmailHint,
            prefixIcon: LucideIcons.user,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // ── Password field ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AuthLabel(AppStrings.loginPasswordLabel),
              GestureDetector(
                onTap: () {},
                child: Text(
                  AppStrings.loginForgotPassword,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          _AuthTextField(
            controller: passwordController,
            hint: AppStrings.loginPasswordHint,
            prefixIcon: LucideIcons.lock,
            obscureText: obscurePassword,
            suffixIcon: GestureDetector(
              onTap: onToggleObscure,
              child: Icon(
                obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                size: AppDimensions.iconDefault,
                color: AppColors.outline,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // ── Sign-in button ──
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLoading ? null : onSignIn,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingLG,
                    ),
                    shape: StadiumBorder(),
                    elevation: AppDimensions.elevationMD,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: AppDimensions.iconDefault,
                          height: AppDimensions.iconDefault,
                          child: CircularProgressIndicator(
                            strokeWidth: AppDimensions.borderWidth,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : Text(
                          AppStrings.loginSignIn,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // ── Divider ──
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMD,
                ),
                child: Text(
                  AppStrings.loginOr,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.outline,
                    fontWeight: FontWeight.w700,
                    letterSpacing: AppDimensions.letterSpacingWide,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.outlineVariant)),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // ── Social buttons ──
          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  label: AppStrings.loginGoogle,
                  icon: LucideIcons.globe,
                  onTap: () {
                    context.read<AuthCubit>().signInWithGoogle();
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Expanded(
                child: _SocialButton(
                  label: AppStrings.loginSchoolId,
                  icon: LucideIcons.graduationCap,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // ── Sign-up link ──
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.loginNoAccount,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingXXS),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.signupPath),
                  child: Text(
                    AppStrings.loginSignUp,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared auth sub-widgets ───────────────────────────────────────

class _AuthLabel extends StatelessWidget {
  final String text;

  const _AuthLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const _AuthTextField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.outline),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppDimensions.paddingMD),
          child: Icon(
            prefixIcon,
            size: AppDimensions.iconDefault,
            color: AppColors.outline,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: AppDimensions.avatarMD,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: AppDimensions.paddingMD),
                child: suffixIcon,
              )
            : null,
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withValues(
              alpha: AppDimensions.opacitySubtle,
            ),
            width: AppDimensions.borderWidth,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMD,
          vertical: AppDimensions.paddingLG,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: AppDimensions.iconDefault),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMD),
        shape: StadiumBorder(),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(
            alpha: AppDimensions.opacitySubtle,
          ),
        ),
        backgroundColor: AppColors.surfaceContainerLow,
        foregroundColor: AppColors.onSurface,
        textStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
