import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../repository/auth_repository.dart';
import '../../../main.dart';
import '../../../core/utils/form_validators.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/api/api_exceptions.dart';
import '../../../core/utils/error_translator.dart';
import '../../../core/widgets/guest_drawer.dart';
import '../../../core/widgets/country_selection_field.dart';
import '../../../core/providers/global_providers.dart';
import '../../../core/models/plan_summary_model.dart';

const Color kPrimaryColor = TColors.primary;
const Color kSecondaryColor = TColors.secondary;
const double kBorderRadius = 16.0;

class RegisterModel {
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String age = '';
  String password = '';
  String? countryId;

  String? selectedMethod = 'self_paced';

  int planId = 1009; // Default: خطة نصف وجه من البقرة

  Map<String, dynamic> toMap() {
    return {
      'email': email.trim(),
      'password': password.trim(),
      'firstName': firstName.trim(),
      'middleName': middleName.trim(),
      'lastName': lastName.trim(),
      'phoneNumber': phone.trim(),
      'countryId': countryId,
      'age': int.tryParse(age.trim()) ?? 0,
      'memorizationMethod': _getMemorizationMethodId(selectedMethod),

      'planId': (planId <= 0) ? 1 : planId,
    };
  }

  int _getMemorizationMethodId(String? plan) {
    switch (plan) {
      case 'self_paced':
        return 1;
      case 'group_session':
        return 2;
      case 'online_tutoring':
        return 3;
      default:
        return 1;
    }
  }
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController();
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final _registerModel = RegisterModel();

  int _currentPage = 0;
  bool _obscurePassword = true;
  bool _isLoading = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _ageController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  List<PlanSummaryModel> _availablePlans = [];
  bool _isLoadingPlans = false;

  /// ✅ UX: نظهر رسالة تعليمية عند فشل التسجيل
  bool _lastRegisterFailed = false;

  @override
  void initState() {
    super.initState();
    _fetchPlans();

    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    if (!mounted) return;
    setState(() => _isLoadingPlans = true);

    try {
      final plans = await ref.read(authRepositoryProvider).getAvailablePlans();

      if (!mounted) return;
      if (!mounted) return;
      setState(() {
        _availablePlans = plans;
        _isLoadingPlans = false;

        if (plans.isNotEmpty) {
          final has1009 = plans.any((p) => p.id == 1009);
          _registerModel.planId = has1009 ? 1009 : plans.first.id;
        } else {
          _registerModel.planId = 1009;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        // Keep _availablePlans as is if it already has defaults from repo
        _isLoadingPlans = false;
        _registerModel.planId = 1009;
      });
    }
  }

  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleNextOrRegister() async {
    final localizations = AppLocalizations.of(context)!;

    if (_currentPage == 0) {
      if (_formKeyStep1.currentState!.validate()) {
        _registerModel.firstName = _firstNameController.text;
        _registerModel.middleName = _middleNameController.text;
        _registerModel.lastName = _lastNameController.text;
        _registerModel.age = _ageController.text;
        _registerModel.email = _emailController.text;
        _registerModel.password = _passwordController.text;

        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
      return;
    }

    if (_currentPage == 1) {
      if (_formKeyStep2.currentState!.validate()) {
        if (_registerModel.countryId == null) {
          _showSnackBar(localizations.validationCountryRequired, isError: true);
          return;
        }

        if (_registerModel.planId <= 0) _registerModel.planId = 1009;

        setState(() {
          _isLoading = true;
          _lastRegisterFailed = false;
        });

        try {
          await ref
              .read(authStateProvider.notifier)
              .register(userData: _registerModel.toMap());

          await ref
              .read(authRepositoryProvider)
              .initializeUserPlans(_registerModel.planId, _availablePlans);

          if (!mounted) return;
          _showSnackBar(localizations.registerSuccess, isError: false);

          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
        } on ApiException catch (e) {
          if (!mounted) return;
          setState(() => _lastRegisterFailed = true);
          _showSnackBar(getErrorMessage(e, context), isError: true);
        } catch (_) {
          if (!mounted) return;
          setState(() => _lastRegisterFailed = true);
          _showSnackBar(localizations.apiUnexpectedError, isError: true);
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  void _goToLogin() {
    try {
      Navigator.of(context).pushNamed(AppRoutes.login);
    } catch (_) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const GuestDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: _handleBack,
        ),
        title: Text(
          localizations.registerTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Iconsax.more_square, color: Colors.black),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildCustomStepper(localizations),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildStep1(localizations),
                  _buildStep2(localizations),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomStepper(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          _buildStepIndicator(0, localizations.stepBasicInfo),
          Expanded(
            child: Container(
              height: 2,
              color: _currentPage >= 1 ? kPrimaryColor : Colors.grey[300],
            ),
          ),
          _buildStepIndicator(1, localizations.stepDetails),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    bool isActive = _currentPage >= stepIndex;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive ? kPrimaryColor : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? kPrimaryColor : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    "${stepIndex + 1}",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? kSecondaryColor : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1(AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: localizations.registerWelcome,
              subtitle: localizations.registerWelcomeSub,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: _CustomTextField(
                    controller: _firstNameController,
                    label: localizations.firstNameLabel,
                    icon: Iconsax.user,
                    validator: (v) => FormValidators.validateRequired(
                      v,
                      localizations.firstNameLabel,
                      context,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: _CustomTextField(
                    controller: _middleNameController,
                    label: localizations.middleNameLabel,
                    icon: Iconsax.user,
                    validator: (v) => FormValidators.validateRequired(
                      v,
                      localizations.middleNameLabel,
                      context,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _lastNameController,
              label: localizations.lastNameLabel,
              icon: Iconsax.user,
              validator: (v) => FormValidators.validateRequired(
                v,
                localizations.lastNameLabel,
                context,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: localizations.phoneNumberLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    initialCountryCode: 'SA',
                    languageCode: 'ar',
                    onChanged: (phone) {
                      _registerModel.phone = phone.completeNumber;
                    },
                    validator: (phone) {
                      if (phone == null || phone.number.trim().isEmpty) {
                        return localizations.validationRequiredField(
                          localizations.phoneNumberLabel,
                        );
                      }
                      try {
                        if (!phone.isValidNumber()) {
                          return localizations.invalidPhoneNumber;
                        }
                      } catch (_) {
                        return localizations.invalidPhoneNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _CustomTextField(
                    controller: _ageController,
                    label: localizations.ageLabel,
                    icon: Iconsax.calendar_1,
                    inputType: TextInputType.number,
                    validator: (v) => FormValidators.validateAge(v, context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _emailController,
              label: localizations.emailLabel,
              icon: Iconsax.sms,
              inputType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return localizations.validationEmptyEmail;
                }
                return FormValidators.validateEmail(value, context);
              },
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _passwordController,
              label: localizations.passwordLabel,
              icon: Iconsax.lock,
              obscureText: _obscurePassword,
              maxLength: 10,
              isPassword: true,
              onVisibilityToggle: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              validator: (v) => FormValidators.validatePassword(v, context),
            ),
            const SizedBox(height: 40),
            _buildPrimaryButton(
              localizations.nextButton,
              _handleNextOrRegister,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(AppLocalizations localizations) {
    final countriesAsync = ref.watch(countriesListProvider);

    final bool hasPlans = _availablePlans.isNotEmpty;

    final String? safePlanValue =
        hasPlans && _availablePlans.any((p) => p.id == _registerModel.planId)
        ? _registerModel.planId.toString()
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyStep2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: localizations.step2Title,
              subtitle: localizations.step2Sub,
            ),
            const SizedBox(height: 30),
            countriesAsync.when(
              data: (countries) => CountrySelectorField(
                label: localizations.countryLabel,
                countries: countries,
                selectedCountryId: _registerModel.countryId,
                onCountrySelected: (id, name) {
                  setState(() {
                    _registerModel.countryId = id;
                  });
                },
              ),
              loading: () =>
                  CustomLoadingField(label: localizations.countryLabel),
              error: (_, __) =>
                  CustomErrorField(label: localizations.countryLabel),
            ),
            const SizedBox(height: 24),

            _isLoadingPlans
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    value: safePlanValue,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Iconsax.task_square),
                      hintText: hasPlans
                          ? localizations.choosePlanOptional
                          : localizations.defaultPlanWillBeUsed,
                    ),
                    items: _availablePlans
                        .map(
                          (plan) => DropdownMenuItem<String>(
                            value: plan.id.toString(),
                            child: Text(plan.name),
                          ),
                        )
                        .toList(),
                    onChanged: hasPlans
                        ? (val) {
                            setState(() {
                              if (val == null) {
                                _registerModel.planId = 1;
                              } else {
                                _registerModel.planId = int.tryParse(val) ?? 1;
                              }
                            });
                          }
                        : null,

                    validator: (_) => null,
                  ),

            const SizedBox(height: 12),

            _buildPlanSelectionCard(
              value: 'self_paced',
              title: localizations.planSelfPaced,
              subtitle: localizations.planSelfPacedSub,
              icon: Iconsax.user_tag,
              isEnabled: true,
            ),

            const SizedBox(height: 12),
            const SizedBox(height: 40),

            _buildPrimaryButton(
              localizations.createAccountAction,
              _isLoading ? () {} : _handleNextOrRegister,
              isLoading: _isLoading,
            ),

            if (_lastRegisterFailed) ...[
              const SizedBox(height: 12),
              _buildRegisterHelpCard(localizations),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterHelpCard(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE0A6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.info_circle, size: 18, color: Color(0xFF9A6B00)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  localizations.registerHelpNote,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7A5200),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            localizations.registerHelpDescription,
            style: const TextStyle(
              height: 1.4,
              color: Color(0xFF7A5200),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                localizations.doYouHaveAccount,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A5200),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _goToLogin,
                icon: const Icon(Iconsax.login_1, size: 18),
                label: Text(localizations.loginButton),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF7A5200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Widget _buildPrimaryButton(
    String text,
    VoidCallback onTap, {
    bool isLoading = false,
  }) {
    final currentLocale = ref.watch(localeProvider);
    final isArabic = currentLocale.languageCode == 'ar';

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_currentPage == 0) ...[
                    const SizedBox(width: 8),
                    Icon(
                      isArabic ? Iconsax.arrow_left : Iconsax.arrow_right_1,
                      color: Colors.white,
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildPlanSelectionCard({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isEnabled = true,
  }) {
    bool isSelected = _registerModel.selectedMethod == value;
    return GestureDetector(
      onTap: isEnabled
          ? () => setState(() => _registerModel.selectedMethod = value)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? kPrimaryColor : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Iconsax.tick_circle, color: kPrimaryColor),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final bool obscureText;
  final bool isPassword;
  final VoidCallback? onVisibilityToggle;
  final String? Function(String?)? validator;
  final int? maxLength;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.onVisibilityToggle,
    this.validator,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscureText,
        validator: validator,
        maxLength: maxLength,
        style: const TextStyle(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Iconsax.eye_slash : Iconsax.eye,
                    color: Colors.grey[400],
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
