import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../../core/widgets/guest_drawer.dart';

class LoginOptionsScreen extends ConsumerStatefulWidget {
  const LoginOptionsScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<LoginOptionsScreen> createState() => _LoginOptionsScreenState();
}

class _LoginOptionsScreenState extends ConsumerState<LoginOptionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //دالة التسجيل الاجتماعي
  /*
  Future<void> _handleSocialLogin(
    BuildContext context,
    WidgetRef ref,
    String provider,
  ) async {
    try {
      if (provider == 'google') {
        await ref.read(authStateProvider.notifier).loginWithGoogle();
      } else if (provider == 'apple') {
        await ref.read(authStateProvider.notifier).loginWithApple();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل تسجيل الدخول: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  */
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final currentLocale = ref.watch(localeProvider);
    final isArabic = currentLocale.languageCode == 'ar';
    return Scaffold(
      key: _scaffoldKey,
      drawer: !isArabic ? const GuestDrawer() : null,
      endDrawer: isArabic ? const GuestDrawer() : null,
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final double maxW = constraints.maxWidth;
                final double maxH = constraints.maxHeight;
                final bool isTablet = maxW > 600;
                final bool isLandscape = maxW > maxH;
                final double logoSize = isTablet ? 180 : 140;

                return Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 60 : 30,
                        vertical: 24,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: logoSize,
                              width: logoSize,
                              decoration: BoxDecoration(
                                color: TColors.primary.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Iconsax.book_1,
                                  size: logoSize * 0.5,
                                  color: TColors.primary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                            Text(
                              localizations.loginOptionsTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontSize: isTablet ? 32 : 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              localizations.loginScreenSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: isTablet ? 18 : 14,
                                  ),
                            ),

                            SizedBox(height: isLandscape ? 30 : 60),
                            // الأزرار الاجتماعية
                            /*
                            _buildSocialLoginButton(
                              iconPath: 'assets/icons/google.svg',
                              text: localizations.loginWithGoogle,
                              onPressed: () => _handleSocialLogin(context, ref, 'google'),
                              scale: isTablet ? 1.2 : 1,
                            ),
                            const SizedBox(height: 16),
                            _buildSocialLoginButton(
                              iconPath: 'assets/icons/apple.svg',
                              text: localizations.loginWithApple,
                              onPressed: () => _handleSocialLogin(context, ref, 'apple'),
                              scale: isTablet ? 1.2 : 1,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(localizations.orDivider),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 24),
                            */
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                backgroundColor: TColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: TColors.primary.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                localizations.loginWithPhone,
                                style: TextStyle(
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations.dontHaveAccount,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    localizations.createAccountButton,
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: TColors.primary,
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
                );
              },
            ),
            Positioned(
              top: 10,
              left: isArabic ? 20 : null,
              right: !isArabic ? 20 : null,
              child: IconButton(
                onPressed: () {
                  if (isArabic) {
                    _scaffoldKey.currentState?.openEndDrawer();
                  } else {
                    _scaffoldKey.currentState?.openDrawer();
                  }
                },
                icon: const Icon(
                  Iconsax.element_4,
                  size: 28,
                  color: Colors.black87,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تابع لتسجيل الدخول الاجتماعي
  /*
  Widget _buildSocialLoginButton({
    required String iconPath,
    required String text,
    required VoidCallback onPressed,
    double scale = 1.0,
  }) {
    return Transform.scale(
      scale: scale,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: SvgPicture.asset(iconPath, height: 24),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  */
}
