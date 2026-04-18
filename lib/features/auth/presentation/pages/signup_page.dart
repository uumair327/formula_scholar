import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/auth_cubit.dart';
import '../../../profile/presentation/widgets/support_contact_sheet.dart';

/// Sign-up page — account creation screen.
///
/// Two-column layout on large screens (brand + testimonial left,
/// form right). Single-column on small screens.
///
/// Mirrors SignUp.tsx from the React prototype.
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
    if (!_agreedToTerms) {
      return;
    }
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
        backgroundColor: AppColors.surface,
        body: Stack(
          children: [
            _SignupBackgroundDecor(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: isWide
                          ? _SignupWideLayout(
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
                          : _SignupFormScroll(
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

// ── Background ─────────────────────────────────────────────────────

class _SignupBackgroundDecor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top:
              -AppDimensions.decorativeBlurMD *
              AppDimensions.decorativePositionFraction,
          right:
              -AppDimensions.decorativeBlurSM *
              AppDimensions.decorativePositionFraction,
          child: Container(
            width: AppDimensions.decorativeBlurLG,
            height: AppDimensions.decorativeBlurLG,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryFixed.withValues(
                alpha: AppDimensions.opacityFaint * AppDimensions.opacitySubtle,
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
              color: AppColors.tertiaryContainer.withValues(
                alpha: AppDimensions.opacityFaint * AppDimensions.opacitySubtle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Wide layout ────────────────────────────────────────────────────

class _SignupWideLayout extends StatelessWidget {

  const _SignupWideLayout({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.agreedToTerms,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onTermsChanged,
    required this.onCreateAccount,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool agreedToTerms;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: const [AppShadows.ghost],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(flex: 5, child: _SignupBrandColumn()),
          Expanded(
            flex: 5,
            child: _SignupFormScroll(
              formKey: formKey,
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              confirmController: confirmController,
              obscurePassword: obscurePassword,
              obscureConfirm: obscureConfirm,
              agreedToTerms: agreedToTerms,
              onTogglePassword: onTogglePassword,
              onToggleConfirm: onToggleConfirm,
              onTermsChanged: onTermsChanged,
              onCreateAccount: onCreateAccount,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Brand column ────────────────────────────────────────────────────

class _SignupBrandColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.signupBrandTitle,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w900,
              letterSpacing: AppDimensions.letterSpacingTight,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.signupBrandHeadline,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w900,
                  height: AppDimensions.lineHeightTight,
                  letterSpacing: AppDimensions.letterSpacingTight,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              Text(
                AppStrings.signupBrandDesc,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryFixed.withValues(
                    alpha: AppDimensions.opacityHigh,
                  ),
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
          // Testimonial card
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: AppColors.white.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppDimensions.avatarMD,
                      height: AppDimensions.avatarMD,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryFixed,
                      ),
                      child: Center(
                        child: Text(
                          'IS',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.onPrimaryFixed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMD),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.signupTestimonialName,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          AppStrings.signupTestimonialRole,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onPrimary.withValues(
                              alpha: AppDimensions.opacityMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                Text(
                  AppStrings.signupTestimonial,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onPrimary.withValues(
                      alpha: AppDimensions.opacityNearOpaque,
                    ),
                    fontStyle: FontStyle.italic,
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

// ── Form scroll wrapper ─────────────────────────────────────────────

class _SignupFormScroll extends StatelessWidget {

  const _SignupFormScroll({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.agreedToTerms,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onTermsChanged,
    required this.onCreateAccount,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool agreedToTerms;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHero,
        vertical: AppDimensions.paddingXXL,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.signupTitle,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: AppDimensions.letterSpacingTight,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              AppStrings.signupSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),

            // ── Name + Email row ──
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: AppStrings.signupFullName,
                    hintText: AppStrings.signupFullNameHint,
                    prefixIcon: LucideIcons.user,
                    controller: nameController,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: AppTextField(
                    label: AppStrings.signupEmail,
                    hintText: AppStrings.signupEmailHint,
                    prefixIcon: LucideIcons.mail,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLG),

            // ── Password ──
            AppTextField(
              label: AppStrings.signupPassword,
              hintText: AppStrings.signupPasswordHint,
              controller: passwordController,
              prefixIcon: LucideIcons.lock,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                  color: AppColors.onSurfaceVariant,
                  size: AppDimensions.iconDefault,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),

            // ── Confirm Password ──
            AppTextField(
              label: AppStrings.signupConfirmPassword,
              hintText: AppStrings.signupPasswordHint,
              controller: confirmController,
              prefixIcon: LucideIcons.checkSquare,
              obscureText: obscureConfirm,
              suffixIcon: IconButton(
                onPressed: onToggleConfirm,
                icon: Icon(
                  obscureConfirm ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: AppColors.onSurfaceVariant,
                  size: AppDimensions.iconDefault,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),

            // ── Terms checkbox ──
            Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: onTermsChanged,
                  activeColor: AppColors.primary,
                ),
                const SizedBox(width: AppDimensions.paddingXS),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        AppStrings.signupTerms,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            context.pushNamed(AppRoutes.termsOfServiceName),
                        child: Text(
                          AppStrings.signupTermsLink,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        AppStrings.signupAnd,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            context.pushNamed(AppRoutes.privacyPolicyName),
                        child: Text(
                          AppStrings.signupPrivacy,
                          style: AppTextStyles.bodySmall.copyWith(
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
            const SizedBox(height: AppDimensions.paddingXL),

            // ── Create Account button ──
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state.status == AuthStatus.loading;
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isLoading ? null : onCreateAccount,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingLG,
                      ),
                      shape: const StadiumBorder(),
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
                            AppStrings.signupCreateAccount,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimensions.paddingLG),

            // ── Or join with divider ──
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.surfaceVariant)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMD,
                  ),
                  child: Text(
                    AppStrings.signupOrJoin,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.surfaceVariant)),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLG),

            // ── Social buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.read<AuthCubit>().signInWithGoogle(),
                    icon: const Icon(
                      LucideIcons.globe,
                      size: AppDimensions.iconDefault,
                    ),
                    label: const Text(AppStrings.loginGoogle),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMD,
                      ),
                      shape: const StadiumBorder(),
                      backgroundColor: AppColors.surfaceContainerHigh,
                      foregroundColor: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => SupportContactSheet.show(
                      context,
                      title: AppStrings.signupFacebook,
                      subtitle:
                          'Facebook sign-in is not enabled in this build. '
                          'Contact support if your school needs a different access path.',
                      email: 'support@formulascholar.app',
                    ),
                    icon: const Icon(
                      LucideIcons.facebook,
                      size: AppDimensions.iconDefault,
                    ),
                    label: const Text(AppStrings.signupFacebook),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMD,
                      ),
                      shape: const StadiumBorder(),
                      backgroundColor: AppColors.surfaceContainerHigh,
                      foregroundColor: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXXL),

            // ── Sign-in link ──
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.signupHasAccount,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingXXS),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.loginPath),
                    child: Text(
                      AppStrings.signupSignIn,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
