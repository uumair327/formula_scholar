import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/forgot_password_dialog.dart';

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
      listener: (listenerContext, state) async {
        if (state.status == AuthStatus.authenticated) {
          final curriculumCubit = listenerContext.read<CurriculumCubit>();
          await curriculumCubit.refresh();
          if (!listenerContext.mounted) {
            return;
          }

          listenerContext.go(
            curriculumCubit.state.hasSelection
                ? AppRoutes.dashboardPath
                : AppRoutes.onboardingPath,
          );
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            _BackgroundDecor(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > AppDimensions.breakpointTablet;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkPrimary : AppColors.primaryFixed)
                      .withValues(alpha: 0.12),
                  (isDark ? AppColors.darkPrimary : AppColors.primaryFixed)
                      .withValues(alpha: 0.0),
                ],
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
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkSecondary : AppColors.secondaryFixed)
                      .withValues(alpha: 0.1),
                  (isDark ? AppColors.darkSecondary : AppColors.secondaryFixed)
                      .withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Additional subtle tertiary orb
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkTertiary : AppColors.tertiaryFixed)
                      .withValues(alpha: 0.08),
                  AppColors.transparent,
                ],
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
  const _WideLayout({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: const [AppShadows.ghost],
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
  const _NarrowLayout({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
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
              color: AppColors.onPrimary.withValues(
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
          const _FormulaCard(formula: 'e = mc²', rotation: -0.035),
          const SizedBox(height: AppDimensions.paddingMD),
          const Padding(
            padding: EdgeInsets.only(left: AppDimensions.paddingHero),
            child: _FormulaCard(formula: 'a² + b² = c²', rotation: 0.052),
          ),
        ],
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  const _FormulaCard({required this.formula, required this.rotation});
  final String formula;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: AppColors.onPrimary.withValues(
            alpha: AppDimensions.opacitySubtle,
          ),
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
  const _FormColumn({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

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
  const _FormContent({
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // ── Email/username field ──
          AppTextField(
            controller: identityController,
            label: AppStrings.loginEmailLabel,
            hintText: AppStrings.loginEmailHint,
            prefixIcon: LucideIcons.user,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // ── Password field ──
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () =>
                  showForgotPasswordDialog(context, identityController.text),
              child: Text(
                AppStrings.loginForgotPassword,
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          AppTextField(
            controller: passwordController,
            label: AppStrings.loginPasswordLabel,
            hintText: AppStrings.loginPasswordHint,
            prefixIcon: LucideIcons.lock,
            obscureText: obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.validationRequired;
              }
              return null;
            },
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                size: AppDimensions.iconDefault,
                color: colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // ── Sign-in button ──
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              return AppGradientButton(
                label: AppStrings.loginSignIn,
                onPressed: isLoading ? null : onSignIn,
                isLoading: isLoading,
                icon: LucideIcons.logIn,
              );
            },
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // ── Divider ──
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMD,
                ),
                child: Text(
                  AppStrings.loginOr,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    letterSpacing: AppDimensions.letterSpacingWide,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
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
                  onTap: () => ComingSoonSheet.show(
                    context,
                    featureName: AppStrings.loginSchoolId,
                  ),
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
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingXXS),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.signupPath),
                  child: Text(
                    AppStrings.loginSignUp,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.primary,
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

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: AppDimensions.iconDefault),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMD),
        shape: const StadiumBorder(),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimensions.opacitySubtle,
          ),
        ),
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        textStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
