import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

const Color kPrimaryColor = TColors.primary;
const double kBorderRadius = 16.0;

class CountrySearchSheet extends StatefulWidget {
  final List<dynamic> countries;
  final Function(dynamic) onSelect;

  const CountrySearchSheet({
    super.key,
    required this.countries,
    required this.onSelect,
  });

  @override
  State<CountrySearchSheet> createState() => _CountrySearchSheetState();
}

class _CountrySearchSheetState extends State<CountrySearchSheet> {
  List<dynamic> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries.where((country) {
          final arName = (country['arName'] ?? '').toString().toLowerCase();
          final enName = (country['name'] ?? '').toString().toLowerCase();
          final q = query.toLowerCase();
          return arName.contains(q) || enName.contains(q);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
        decoration: const BoxDecoration(
          color: TColors.lightContainer,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: TColors.borderPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Row(
              children: [
                const Icon(
                  Iconsax.global,
                  size: 18,
                  color: TColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.countryFormFieldLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: TColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _searchController,
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: l10n.searchCountryHint,
                prefixIcon: const Icon(Iconsax.search_normal, size: 18),
                filled: true,
                fillColor: TColors.light,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TColors.borderSecondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TColors.borderSecondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: TColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _filteredCountries.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noResultsFound,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredCountries.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: TColors.borderSecondary,
                      ),
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        final name = country['arName'] ?? country['name'] ?? '';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          title: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: TColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          trailing: const Icon(
                            Iconsax.arrow_left_2,
                            size: 16,
                            color: TColors.textSecondary,
                          ),
                          onTap: () => widget.onSelect(country),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}

class CountrySelectorField extends StatefulWidget {
  final String label;
  final List<dynamic> countries;
  final String? selectedCountryId;
  final Function(String id, String name) onCountrySelected;

  const CountrySelectorField({
    super.key,
    required this.label,
    required this.countries,
    required this.selectedCountryId,
    required this.onCountrySelected,
  });

  @override
  State<CountrySelectorField> createState() => _CountrySelectorFieldState();
}

class _CountrySelectorFieldState extends State<CountrySelectorField> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDisplayController(widget.selectedCountryId);
  }

  @override
  void didUpdateWidget(covariant CountrySelectorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCountryId != oldWidget.selectedCountryId) {
      _updateDisplayController(widget.selectedCountryId);
    }
  }

  void _updateDisplayController(String? countryId) {
    if (countryId != null) {
      final selected = widget.countries.firstWhere(
        (c) => c['id'].toString() == countryId,
        orElse: () => null,
      );
      if (selected != null) {
        _displayController.text = selected['arName'] ?? selected['name'] ?? '';
        return;
      }
    }
    _displayController.text = '';
  }

  void _openSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountrySearchSheet(
        countries: widget.countries,
        onSelect: (country) {
          final name = country['arName'] ?? country['name'] ?? '';
          final id = country['id'].toString();
          widget.onCountrySelected(id, name);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: _displayController,
      readOnly: true,
      onTap: () => _openSearchBottomSheet(context),
      validator: (value) => value == null || value.isEmpty
          ? l10n.validationCountryRequired
          : null,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: TColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Iconsax.global, size: 18),
        suffixIcon: const Icon(Iconsax.arrow_down_1, size: 18),
        filled: true,
        fillColor: TColors.lightContainer,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: TColors.borderSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: TColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: TColors.reportBad),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: TColors.reportBad, width: 2),
        ),
      ),
    );
  }
}

class CustomLoadingField extends StatelessWidget {
  final String label;
  const CustomLoadingField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: const BorderSide(color: TColors.borderSecondary).toBorder(),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.global, color: TColors.textSecondary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomErrorField extends StatelessWidget {
  final String label;
  const CustomErrorField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: TColors.reportBad.withOpacity(0.08),
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: TColors.reportBad.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.warning_2, color: TColors.reportBad, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.failedToLoadCountries,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.reportBad,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on BorderSide {
  BoxBorder toBorder() => Border.fromBorderSide(this);
}
