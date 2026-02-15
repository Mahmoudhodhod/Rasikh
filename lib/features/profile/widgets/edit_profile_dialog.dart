import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rasikh/core/models/user_model.dart';
import 'package:rasikh/core/theme/app_colors.dart';
import 'package:rasikh/core/widgets/form_error_box.dart';
import 'package:rasikh/features/profile/profile_controller.dart';
import 'package:rasikh/l10n/app_localizations.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  final UserModel currentUser;

  const EditProfileDialog({Key? key, required this.currentUser})
    : super(key: key);

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  late String _fullPhoneNumber;

  String? _errorText;

  RegExp get _nameRegex => RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');

  @override
  void initState() {
    super.initState();
    final user = widget.currentUser;

    _firstNameController = TextEditingController(text: user.firstName);
    _middleNameController = TextEditingController(text: user.middleName ?? '');
    _lastNameController = TextEditingController(text: user.lastName);
    _emailController = TextEditingController(text: user.email);

    _fullPhoneNumber = user.phone;

    void clearError() {
      if (_errorText != null) setState(() => _errorText = null);
    }

    _firstNameController.addListener(clearError);
    _middleNameController.addListener(clearError);
    _lastNameController.addListener(clearError);
    _emailController.addListener(clearError);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorText = null);

    final l10n = AppLocalizations.of(context)!;

    final newUserData = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'middleName': _middleNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phoneNumber': _fullPhoneNumber,
    };

    final error = await ref
        .read(profileControllerProvider.notifier)
        .updateUserProfile(
          context: context,
          l10n: l10n,
          newUserData: newUserData,
        );

    if (!mounted) return;

    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdateSuccess),
          backgroundColor: TColors.primary,
        ),
      );
  }

  InputDecoration _decoration({
    required BuildContext context,
    required String label,
    IconData? icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(profileControllerProvider);

    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.85;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      backgroundColor: TColors.lightContainer,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 520, maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Iconsax.edit, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.editProfileDialogTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.saveButton,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.cancelButton,
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 12),

                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnimatedSize(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            child: _errorText == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: FormErrorBox(message: _errorText!),
                                  ),
                          ),

                          TextFormField(
                            controller: _firstNameController,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              context: context,
                              label: l10n.firstNameFormFieldLabel,
                              icon: Iconsax.user,
                            ),
                            validator: (value) {
                              final v = value?.trim() ?? '';
                              if (v.isEmpty)
                                return l10n.validationEmptyFirstName;
                              if (!_nameRegex.hasMatch(v)) {
                                return l10n.validationInvalidNameFormat;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _middleNameController,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              context: context,
                              label: l10n.middleNameFormFieldLabel,
                              icon: Iconsax.user_octagon,
                            ),
                            validator: (value) {
                              final v = value?.trim() ?? '';
                              if (v.isEmpty)
                                return l10n.validationEmptyMiddleName;
                              if (!_nameRegex.hasMatch(v)) {
                                return l10n.validationInvalidNameFormat;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _lastNameController,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              context: context,
                              label: l10n.lastNameFormFieldLabel,
                              icon: Iconsax.user_tag,
                            ),
                            validator: (value) {
                              final v = value?.trim() ?? '';
                              if (v.isEmpty)
                                return l10n.validationEmptyLastName;
                              if (!_nameRegex.hasMatch(v)) {
                                return l10n.validationInvalidNameFormat;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              context: context,
                              label: l10n.emailFormFieldLabel,
                              icon: Iconsax.direct,
                              hint: 'name@example.com',
                            ),
                            validator: (value) {
                              final v = value?.trim() ?? '';
                              if (v.isEmpty) return null;
                              final emailRegex = RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                              );
                              if (!emailRegex.hasMatch(v)) {
                                return l10n.validationInvalidEmail;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          IntlPhoneField(
                            key: ValueKey(widget.currentUser.phone),
                            initialValue: _fullPhoneNumber,
                            initialCountryCode: 'SA',
                            languageCode: l10n.localeName,
                            decoration: _decoration(
                              context: context,
                              label: l10n.phoneFormFieldLabel,
                              icon: Iconsax.call,
                            ),
                            onChanged: (phone) {
                              _fullPhoneNumber = phone.completeNumber;
                              if (_errorText != null) {
                                setState(() => _errorText = null);
                              }
                            },
                            invalidNumberMessage: l10n.invalidPhoneNumber,
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _saveForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
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
                                ),
                              )
                            : Text(l10n.saveButton),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(l10n.cancelButton),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
