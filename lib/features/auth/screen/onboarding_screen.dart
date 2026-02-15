import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../repository/auth_repository.dart';

import '../../../core/theme/app_colors.dart';
import '../../../../main.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    await ref.read(authStateProvider.notifier).loginAsGuest();

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _isLastPage = index == 2);
              },
              children: [
                _OnboardingPage(
                  imagePath: 'assets/images/onboarding1.svg',
                  imageScale: 0.90,
                  title: localizations.onboardingTitle1,
                  subtitle: localizations.onboardingSub1,
                ),
                _OnboardingPage(
                  imagePath: 'assets/images/onboarding2.svg',
                  imageScale: 0.55,
                  title: localizations.onboardingTitle2,
                  subtitle: localizations.onboardingSub2,
                ),
                _OnboardingPage(
                  imagePath: 'assets/images/onboarding3.svg',
                  imageScale: 0.50,
                  title: localizations.onboardingTitle3,
                  subtitle: localizations.onboardingSub3,
                ),
              ],
            ),

            // Skip Button
            PositionedDirectional(
              top: 10,
              end: 20,
              child: TextButton(
                onPressed: _onOnboardingComplete,
                child: Text(
                  localizations.skipButton,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 79, 33, 243),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Indicator + Next Button
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: TColors.primary,
                        dotHeight: 10,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_isLastPage) {
                          _onOnboardingComplete();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Icon(
                        _isLastPage
                            ? Icons.check
                            : (isRtl
                                  ? Icons.arrow_back_ios_new
                                  : Icons.arrow_forward_ios),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page Widget
class _OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final double imageScale;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.imageScale = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Expanded(
                flex: isLandscape ? 4 : 5,
                child: Center(
                  child: SvgPicture.asset(
                    imagePath,
                    width: size.width * imageScale,
                    height:
                        size.height *
                        (isLandscape ? imageScale * 0.5 : imageScale * 0.4),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                flex: isLandscape ? 3 : 2,
                child: Center(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Expanded(
                flex: isLandscape ? 3 : 2,
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: isLandscape ? 10 : 30),
            ],
          ),
        );
      },
    );
  }
}
