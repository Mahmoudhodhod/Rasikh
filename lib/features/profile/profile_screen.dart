import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rasikh/core/models/user_model.dart';
import 'package:rasikh/core/theme/app_colors.dart';
import 'package:rasikh/features/auth/screen/logout_screen.dart';
import 'package:rasikh/features/profile/repository/profile_repository.dart';
import 'package:rasikh/l10n/app_localizations.dart';

import 'utils/profile_image_helper.dart';
import 'widgets/change_password_dialog.dart';
import 'widgets/edit_address_dialog.dart';
import 'widgets/edit_profile_dialog.dart';
import '../auth/repository/auth_repository.dart';
import '../../core/api/api_exceptions.dart';
import '../../core/utils/error_translator.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _profileImageFile;

  void _showEditProfileDialog(UserModel currentUser) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditProfileDialog(currentUser: currentUser),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ChangePasswordDialog(),
    );
  }

  void _showEditAddressDialog(UserModel currentUser) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditAddressDialog(currentUser: currentUser),
    );
  }

  void _handleImageSelection(File newImage) {
    setState(() => _profileImageFile = newImage);
    _uploadImageToServer(newImage);
  }

  Future<void> _uploadImageToServer(File imageFile) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.uploadingImage)));

      await ref.read(profileRepositoryProvider).uploadProfileImage(imageFile);

      setState(() => _profileImageFile = null);
      ref.invalidate(userProfileProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.imageUploadSuccess),
          backgroundColor: TColors.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.imageUploadFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showDeleteAccountConfirmation() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.warning_2, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              l10n.deleteAccountTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.deleteAccountWarning,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteAccountConfirmButton),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await ref.read(authStateProvider.notifier).deleteAccount();

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.deleteAccountSuccess),
          backgroundColor: TColors.primary,
        ),
      );

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/login-options', (route) => false);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      String errorMessage;
      if (e is ApiException) {
        errorMessage = getErrorMessage(e, context);
      } else {
        errorMessage = l10n.deleteAccountFailed(e.toString());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: TColors.lightContainer,
      appBar: AppBar(title: Text(l10n.profileScreenTitle), centerTitle: true),
      body: userProfileAsyncValue.when(
        data: (user) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(userProfileProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                24 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Column(
                children: [
                  _buildProfileHeader(context, user),
                  const SizedBox(height: 18),

                  _buildInfoCard(
                    context: context,
                    title: l10n.personalInformationTitle,
                    onEditPressed: () => _showEditProfileDialog(user),
                    children: [
                      _InfoRow(
                        label: l10n.firstNameLabel,
                        value: user.firstName,
                      ),
                      _InfoRow(
                        label: l10n.middleNameLabel,
                        value: user.middleName ?? '',
                        fallbackText: l10n.notDefined,
                      ),
                      _InfoRow(label: l10n.lastNameLabel, value: user.lastName),
                      _InfoRow(
                        label: l10n.emailLabel,
                        value: user.email,
                        fallbackText: l10n.notDefined,
                        valueTextDirection: TextDirection.ltr,
                      ),
                      _InfoRow(
                        label: l10n.phoneLabel,
                        value: user.phone,
                        fallbackText: l10n.notDefined,
                        valueTextDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: 6),
                      _PasswordRow(
                        label: l10n.passwordLabel,
                        onEdit: _showChangePasswordDialog,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _buildInfoCard(
                    context: context,
                    title: l10n.addressInformationTitle,
                    onEditPressed: () => _showEditAddressDialog(user),
                    children: [
                      _InfoRow(
                        label: l10n.countryFormFieldLabel,
                        value: user.country,
                        fallbackText: l10n.notDefined,
                      ),
                      _InfoRow(
                        label: l10n.cityFormFieldLabel,
                        value: user.city,
                        fallbackText: l10n.notDefined,
                      ),
                      _InfoRow(
                        label: l10n.addressDetailsFormFieldLabel,
                        value: user.addressDetails,
                        fallbackText: l10n.notDefined,
                        maxLines: 3,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LogoutScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Iconsax.logout_1),
                      label: Text(l10n.logoutButton),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _showDeleteAccountConfirmation,
                      icon: const Icon(Iconsax.trash, size: 18),
                      label: Text(l10n.deleteAccountButton),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.profileLoadError(error.toString())),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(userProfileProvider),
                  child: Text(l10n.retryButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    final l10n = AppLocalizations.of(context)!;

    Widget imageWidget;

    if (_profileImageFile != null) {
      imageWidget = Image.file(
        _profileImageFile!,
        fit: BoxFit.cover,
        width: 88,
        height: 88,
      );
    } else if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: user.profileImage!,
        fit: BoxFit.cover,
        width: 88,
        height: 88,
        key: ValueKey(user.profileImage!),
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/default_profile.png',
          fit: BoxFit.cover,
          width: 88,
          height: 88,
        ),
      );
    } else {
      imageWidget = Image.asset(
        'assets/images/default_profile.png',
        fit: BoxFit.cover,
        width: 88,
        height: 88,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              InkWell(
                onTap: () => ProfileImageHelper.showProfileImagePreview(
                  context,
                  user: user,
                  currentLocalFile: _profileImageFile,
                  onEditClicked: () =>
                      ProfileImageHelper.showImageSourceActionSheet(
                        context,
                        onImageReady: _handleImageSelection,
                      ),
                ),
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: TColors.primary.withOpacity(.25),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: SizedBox(width: 88, height: 88, child: imageWidget),
                  ),
                ),
              ),
              InkWell(
                onTap: () => ProfileImageHelper.showImageSourceActionSheet(
                  context,
                  onImageReady: _handleImageSelection,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(7),
                  child: const Icon(
                    Iconsax.edit,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${user.firstName} ${user.lastName}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.personalInformationTitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: TColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required VoidCallback onEditPressed,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _EditChipButton(onPressed: onEditPressed),
            ],
          ),
          const SizedBox(height: 10),
          ..._withDividers(children),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) {
        out.add(const Divider(height: 14, thickness: .7));
      }
    }
    return out;
  }
}

class _EditChipButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _EditChipButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black12.withOpacity(.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.edit, size: 16),
            const SizedBox(width: 6),
            Text(
              l10n.editButton,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final String? fallbackText;
  final TextDirection? valueTextDirection;
  final int maxLines;

  const _InfoRow({
    required this.label,
    required this.value,
    this.fallbackText,
    this.valueTextDirection,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isValueEmpty =
        value == null || value!.trim().isEmpty || value!.trim() == "null";
    final displayValue = isValueEmpty ? (fallbackText ?? '—') : value!.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$label :',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
                height: 1.2,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Text(
              displayValue,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textDirection: valueTextDirection,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isValueEmpty ? Colors.grey : Colors.black,
                height: 1.2,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordRow extends StatelessWidget {
  final String label;
  final VoidCallback onEdit;

  const _PasswordRow({required this.label, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$label :',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            flex: 6,
            child: Text(
              '********',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TColors.primary.withOpacity(.18)),
              ),
              child: const Icon(Iconsax.edit, color: TColors.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
