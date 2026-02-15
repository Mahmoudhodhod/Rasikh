import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasikh/core/models/user_model.dart';
import 'package:rasikh/core/theme/app_colors.dart';
import 'package:rasikh/core/widgets/form_error_box.dart';
import 'package:rasikh/features/profile/profile_controller.dart';
import 'package:rasikh/l10n/app_localizations.dart';

import '../../../../core/providers/global_providers.dart';
import 'package:rasikh/core/widgets/country_selection_field.dart';

class EditAddressDialog extends ConsumerStatefulWidget {
  final UserModel currentUser;

  const EditAddressDialog({Key? key, required this.currentUser})
    : super(key: key);

  @override
  ConsumerState<EditAddressDialog> createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends ConsumerState<EditAddressDialog> {
  final _addressFormKey = GlobalKey<FormState>();

  String? _selectedCountryId;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;

  bool _isInitialCountryIdSet = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final user = widget.currentUser;

    _cityController = TextEditingController(text: user.city ?? '');
    _addressController = TextEditingController(text: user.addressDetails ?? '');

    void clearError() {
      if (_errorText != null) setState(() => _errorText = null);
    }

    _cityController.addListener(clearError);
    _addressController.addListener(clearError);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _getCountryNameFromMap(Map<String, dynamic> country) {
    return country['arName'] ?? country['enName'] ?? country['name'] ?? '';
  }

  void _findInitialCountryId(List<dynamic> countries) {
    if (_isInitialCountryIdSet) return;

    if (widget.currentUser.countryId != null) {
      final userCid = widget.currentUser.countryId.toString();
      try {
        final hasId = countries.any((c) => c['id'].toString() == userCid);
        if (hasId) {
          _selectedCountryId = userCid;
          _isInitialCountryIdSet = true;
          return;
        }
      } catch (_) {}
    }

    final currentCountryName = widget.currentUser.countryName;
    if (currentCountryName != null && currentCountryName.isNotEmpty) {
      try {
        final matchingCountry = countries.firstWhere((country) {
          final cName = _getCountryNameFromMap(country);
          return cName == currentCountryName;
        });
        _selectedCountryId = matchingCountry['id']?.toString();
      } catch (_) {
      }
    }

    _isInitialCountryIdSet = true;
  }

  Future<void> _saveAddressForm() async {
    if (!_addressFormKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    if (_selectedCountryId == null || _selectedCountryId!.trim().isEmpty) {
      setState(() => _errorText = l10n.validationCountryRequired);
      return;
    }

    setState(() => _errorText = null);

    final userId = widget.currentUser.userId;
    final countryIdToSend = int.tryParse(_selectedCountryId!) ?? 0;

    final error = await ref
        .read(profileControllerProvider.notifier)
        .updateAddress(
          context: context,
          l10n: l10n,
          userId: userId,
          countryId: countryIdToSend.toString(),
          city: _cityController.text.trim(),
          addressDetails: _addressController.text.trim(),
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
          content: Text(l10n.addressUpdateSuccess),
          backgroundColor: TColors.primary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(profileControllerProvider);
    final countriesAsync = ref.watch(countriesListProvider);

    final theme = Theme.of(context);
    final radius = BorderRadius.circular(12);

    ButtonStyle baseBtnStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(48)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: radius),
      ),
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: TColors.lightContainer,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Form(
            key: _addressFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on_outlined, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.editAddressDialogTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
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
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.dividerColor.withOpacity(0.6),
                  ),
                  const SizedBox(height: 14),

                  if (_errorText != null) ...[
                    FormErrorBox(message: _errorText!),
                    const SizedBox(height: 12),
                  ],

                  countriesAsync.when(
                    data: (countries) {
                      _findInitialCountryId(countries);

                      return CountrySelectorField(
                        label: l10n.countryFormFieldLabel,
                        countries: countries,
                        selectedCountryId: _selectedCountryId,
                        onCountrySelected: (id, name) {
                          setState(() {
                            _selectedCountryId = id;
                            _errorText = null;
                          });
                        },
                      );
                    },
                    loading: () =>
                        CustomLoadingField(label: l10n.countryFormFieldLabel),
                    error: (_, __) =>
                        CustomErrorField(label: l10n.countryFormFieldLabel),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.cityFormFieldLabel,
                      prefixIcon: const Icon(Icons.location_city_outlined),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? l10n.validationEmptyCity
                        : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _addressController,
                    textInputAction: TextInputAction.done,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: l10n.addressDetailsFormFieldLabel,
                      prefixIcon: const Icon(Icons.home_outlined),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? l10n.validationEmptyAddressDetails
                        : null,
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _saveAddressForm,
                          style: baseBtnStyle.copyWith(
                            backgroundColor: WidgetStateProperty.all(
                              TColors.primary,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            elevation: WidgetStateProperty.all(0),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: baseBtnStyle,
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
      ),
    );
  }
}
