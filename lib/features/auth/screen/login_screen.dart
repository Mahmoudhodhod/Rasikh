import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'register_screen.dart';
import '../../../main.dart';
import '../repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'forgot_password_screen.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/api/api_exceptions.dart';
import '../../../core/utils/error_translator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    showLoadingDialog(context);

    try {
      await ref
          .read(authStateProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      }
    } on ApiException catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        // تحويل الخطأ إلى نص مترجم باستخدام الدالة المساعدة
        final errorMessage = getErrorMessage(e, context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.apiUnexpectedError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;
        final double maxH = constraints.maxHeight;

        final bool isTablet = maxW > 600;
        final bool isLandscape = maxW > maxH;

        final double titleFontSize = isTablet ? 34 : 24;
        final double bodyFontSize = isTablet ? 20 : 16;
        final EdgeInsets screenPadding = EdgeInsets.symmetric(
          horizontal: isTablet ? 48 : 24,
          vertical: isLandscape ? 16 : 24,
        );

        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: true),
          body: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: screenPadding,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        localizations.welcomeBack,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontSize: titleFontSize),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        localizations.loginPrompt,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: bodyFontSize),
                      ),
                      SizedBox(height: isLandscape ? 20 : 32),

                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: localizations.emailLabel,
                          prefixIcon: const Icon(Iconsax.sms),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations.validationEmptyEmail;
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return localizations.validationInvalidEmail;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: localizations.passwordLabel,
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations.validationEnterPassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(localizations.forgotPasswordButton),
                        ),
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 18 : 14,
                          ),
                        ),
                        child: Text(
                          localizations.loginButton,
                          style: TextStyle(fontSize: isTablet ? 20 : 16),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(localizations.dontHaveAccount),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                            child: Text(localizations.createAccountButton),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // Trigger guest login
                          ref.read(authStateProvider.notifier).loginAsGuest();
                          // Navigate to home and clear stack
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.home,
                            (route) => false,
                          );
                        },
                        child: Text(
                          localizations.continueAsGuest,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
