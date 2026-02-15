import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasikh/core/theme/app_colors.dart';
import 'package:rasikh/core/widgets/form_error_box.dart';
import 'package:rasikh/features/profile/profile_controller.dart';
import 'package:rasikh/l10n/app_localizations.dart';
import '../../auth/screen/forgot_password_screen.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _passwordFormKey = GlobalKey<FormState>();

  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmNewPasswordController;

  String? _errorText;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();

    void clearError() {
      if (_errorText != null) setState(() => _errorText = null);
    }

    _oldPasswordController.addListener(clearError);
    _newPasswordController.addListener(clearError);
    _confirmNewPasswordController.addListener(clearError);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePasswordForm() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _errorText = null);

    final err = await ref
        .read(profileControllerProvider.notifier)
        .changePassword(
          context: context,
          l10n: l10n,
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        );

    if (!mounted) return;

    if (err != null) {
      setState(() => _errorText = err);
      return;
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.passwordUpdateSuccess),
          backgroundColor: TColors.primary,
        ),
      );
  }

  void _goToForgotPassword() {
    Navigator.of(context).pop();
    Future.microtask(() {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(profileControllerProvider);
    final theme = Theme.of(context);

    const borderRadius = BorderRadius.all(Radius.circular(14));

    InputDecoration _decoration({
      required String label,
      required IconData icon,
    }) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(borderRadius: borderRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.25)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: TColors.primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      );
    }

    Widget _counter(
      BuildContext context, {
      required int currentLength,
      required int? maxLength,
      required bool isFocused,
    }) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            '${currentLength}/${maxLength ?? ''}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ),
      );
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: TColors.lightContainer,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Form(
            key: _passwordFormKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock_outline, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                l10n.changePasswordDialogTitle,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: IconButton(
                            tooltip: l10n.cancelButton,
                            onPressed: isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (_errorText != null) ...[
                    FormErrorBox(message: _errorText!),
                    const SizedBox(height: 12),
                  ],

                  TextFormField(
                    maxLength: 10,
                    controller: _oldPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(
                      label: l10n.oldPasswordFormFieldLabel,
                      icon: Icons.key_outlined,
                    ),
                    buildCounter: _counter,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.validationEmptyOldPassword;
                      }
                      return null;
                    },
                  ),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: isLoading ? null : _goToForgotPassword,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: const Size(0, 34),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: TColors.primary,
                        textStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      child: Text(l10n.forgotPasswordButton),
                    ),
                  ),

                  const SizedBox(height: 6),

                  TextFormField(
                    maxLength: 10,
                    controller: _newPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(
                      label: l10n.newPasswordFormFieldLabel,
                      icon: Icons.lock_outline,
                    ),
                    buildCounter: _counter,
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return l10n.validationEmptyNewPassword;
                      if (v.length < 6) return l10n.validationPasswordTooShort;
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    maxLength: 10,
                    controller: _confirmNewPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: _decoration(
                      label: l10n.confirmNewPasswordFormFieldLabel,
                      icon: Icons.verified_user_outlined,
                    ),
                    buildCounter: _counter,
                    validator: (value) {
                      if ((value ?? '') != _newPasswordController.text) {
                        return l10n.validationPasswordsDoNotMatch;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    textDirection: Directionality.of(context),
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: isLoading ? null : _savePasswordForm,
                            style: FilledButton.styleFrom(
                              backgroundColor: TColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    l10n.saveButton,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.35),
                              ),
                            ),
                            child: Text(
                              l10n.cancelButton,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
