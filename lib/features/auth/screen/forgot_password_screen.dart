import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';
import '../repository/auth_repository.dart';

import '../../../core/api/api_exceptions.dart';
import '../../../core/utils/error_translator.dart';
import '../../../core/widgets/loading_dialog.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _pageController = PageController();
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _otpController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _otpController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(dynamic e) {
    if (!mounted) return;
    if (e is ApiException) {
      final msg = getErrorMessage(e, context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.apiUnexpectedError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _nextPage() async {
    if (_pageController.page == 0) {
      if (_emailFormKey.currentState!.validate()) {
        showLoadingDialog(context);
        try {
          await ref
              .read(authRepositoryProvider)
              .requestPasswordReset(_emailController.text.trim());

          if (mounted) Navigator.pop(context);

          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } catch (e) {
          if (mounted) Navigator.pop(context);
          _showError(e);
        }
      }
    } else if (_pageController.page == 1) {
      if (_otpFormKey.currentState!.validate()) {
        showLoadingDialog(context);
        try {
          await ref
              .read(authRepositoryProvider)
              .verifyResetCode(
                _emailController.text.trim(),
                _otpController.text.trim(),
              );

          if (mounted) Navigator.pop(context);

          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } catch (e) {
          if (mounted) Navigator.pop(context);
          _showError(e);
        }
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_resetFormKey.currentState!.validate()) {
      showLoadingDialog(context);
      try {
        await ref
            .read(authRepositoryProvider)
            .resetPassword(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );

        if (mounted) Navigator.pop(context);
        if (!mounted) return;

        final localizations = AppLocalizations.of(context)!;
        // success dialog
        showDialog(
          context: context,
          barrierDismissible: false, // منع الإغلاق بالضغط في الخارج
          builder: (context) => AlertDialog(
            title: const Icon(
              Icons.check_circle,
              color: TColors.primary,
              size: 50,
            ),
            content: Text(
              localizations.passwordResetSuccess,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: Text(localizations.finishButton),
              ),
            ],
          ),
        );
      } catch (e) {
        if (mounted) Navigator.pop(context);
        _showError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.forgotPasswordTitle)),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildEmailStep(context, localizations),
          _buildOtpStep(context, localizations),
          _buildResetPasswordStep(context, localizations),
        ],
      ),
    );
  }

  Widget _buildEmailStep(BuildContext context, AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _emailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.forgotPasswordHeading,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(localizations.forgotPasswordSub),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: localizations.enterEmailLabel,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@'))
                  ? localizations.validationEmail
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(localizations.startNowButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.backButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpStep(BuildContext context, AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _otpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.otpTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(localizations.otpMessage, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextFormField(
              controller: _otpController,
              decoration: InputDecoration(labelText: localizations.otpLabel),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              validator: (v) => (v == null || v.length < 4)
                  ? localizations.validationEnterCode
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(localizations.nextButton),
            ),
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              child: Text(localizations.backButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetPasswordStep(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.otpTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations.newPasswordLabel,
              ),
              validator: (v) => (v == null || v.length < 6)
                  ? localizations.validationPasswordLength
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations.confirmPasswordLabel,
              ),
              validator: (v) => v != _passwordController.text
                  ? localizations.validationPasswordMismatch
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(localizations.saveButton),
            ),
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              child: Text(localizations.backButton),
            ),
          ],
        ),
      ),
    );
  }
}
