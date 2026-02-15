import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/repository/auth_repository.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/rasikh_app_bar.dart';
import '../../core/widgets/app_drawer.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/dashboard_stats_model.dart';
import '../profile/repository/profile_repository.dart';
import 'repository/dashboard_repository.dart';
import '../../core/navigation/tabs.dart';
import '../../core/navigation/provider.dart';
import '../../core/api/api_exceptions.dart';
import '../../core/utils/error_translator.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final String imagePath;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final userAsync = ref.watch(userProfileProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState == AuthStatus.guest;

    String currentPlanName = "";
    if (userAsync.hasValue) {
      currentPlanName = userAsync.value!.currentplanName ?? "";
    }

    return Scaffold(
      appBar: const RasekhAppBar(showLogo: true),
      drawer: isGuest ? null : const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          ref.invalidate(dashboardStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                userAsync.when(
                  data: (user) => WelcomeCarousel(
                    studentName: user.firstName,
                    textTheme: textTheme,
                    localizations: localizations,
                  ),
                  loading: () => const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => _buildErrorWidget(
                    context,
                    ref,
                    localizations,
                    e,
                    userProfileProvider,
                  ),
                ),

                const SizedBox(height: 40),
                _buildQuoteCard(textTheme, localizations),
                const SizedBox(height: 24),
                Text(
                  localizations.aboutUsTitle,
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.aboutUsContent,
                  style: textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                statsAsync.when(
                  data: (stats) => Column(
                    children: [
                      _buildOverallProgressCard(
                        textTheme,
                        context,
                        localizations,
                        stats,
                      ),
                      const SizedBox(height: 24),
                      _buildDetailedStatsGrid(textTheme, localizations, stats),
                      const SizedBox(height: 24),
                      _buildCurrentPlanBar(
                        context,
                        textTheme,
                        localizations,
                        currentPlanName.isNotEmpty
                            ? currentPlanName
                            : localizations.noActivePlan,
                        ref,
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => _buildErrorWidget(
                    context,
                    ref,
                    localizations,
                    e,
                    dashboardStatsProvider,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Object error,
    ProviderOrFamily provider,
  ) {
    String errorMessage;
    if (error is ApiException) {
      errorMessage = getErrorMessage(error, context);
    } else {
      errorMessage = l10n.failedToLoadData;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              l10n.somethingWentWrong,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(provider);
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retryButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard(TextTheme textTheme, AppLocalizations localizations) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: TColors.textWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TColors.textWhite, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 20, 10),
            child: Text(
              localizations.quoteText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: textTheme.headlineSmall?.fontWeight,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Positioned(
          top: -60,
          right: -20,
          child: SvgPicture.asset(
            'assets/icons/quran_icon.svg',
            height: 125,
            width: 120,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallProgressCard(
    TextTheme textTheme,
    BuildContext context,
    AppLocalizations localizations,
    DashboardStatsModel stats,
  ) {
    final double progressValue = stats.overallProgress.clamp(0.0, 100.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            PieChart(
              dataMap: {
                'progress': progressValue,
                'remaining': 100 - progressValue,
              },
              chartType: ChartType.ring,
              ringStrokeWidth: 15,
              chartRadius: MediaQuery.of(context).size.width / 4,
              legendOptions: const LegendOptions(showLegends: false),
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: false,
              ),
              centerText: "${progressValue.toStringAsFixed(1)}%",
              centerTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: TColors.secondary,
              ),
              colorList: [TColors.secondary, Colors.grey.shade200],
            ),
            const SizedBox(height: 16),
            Text(
              localizations.completedParts(stats.completedParts),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w700,
                fontSize: 14.53,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStatsGrid(
    TextTheme textTheme,
    AppLocalizations localizations,
    DashboardStatsModel stats,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          localizations.numberOfVerses,
          stats.totalSavedAyat.toString(),
          Icons.menu_book_rounded,
          Colors.blue,
        ),
        _buildStatCard(
          localizations.numberOfPages,
          stats.totalWajah.toString(),
          Icons.auto_stories_rounded,
          Colors.orange,
        ),
        _buildStatCard(
          localizations.dailyAverage,
          stats.averageDailyMemorization.toStringAsFixed(1),
          Icons.bar_chart_rounded,
          Colors.purple,
        ),
        _buildStatCard(
          localizations.performance,
          localizations.performanceGood,
          Icons.thumb_up_alt_rounded,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanBar(
    BuildContext context,
    TextTheme textTheme,
    AppLocalizations localizations,
    String planName,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(text: localizations.currentPlanImportanceTitle),
                  TextSpan(
                    text: "[$planName]",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            height: 35,
            child: ElevatedButton(
              onPressed: () {
                ref.read(bottomNavIndexProvider.notifier).state =
                    HomeTab.planHub.index;
                ref.read(memorizationTabIndexProvider.notifier).state =
                    MemorizationTab.plan.index;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01AB14),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(
                localizations.startMemorizingButton,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeCarousel extends StatefulWidget {
  final String studentName;
  final TextTheme textTheme;
  final AppLocalizations localizations;

  const WelcomeCarousel({
    Key? key,
    required this.studentName,
    required this.textTheme,
    required this.localizations,
  }) : super(key: key);

  @override
  _WelcomeCarouselState createState() => _WelcomeCarouselState();
}

class _WelcomeCarouselState extends State<WelcomeCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<BannerItem> items = [
      BannerItem(
        title: widget.localizations.welcomeUser(widget.studentName),
        subtitle: widget.localizations.welcomeSubtitle,
        imagePath: 'assets/images/welcome_banner_bg.jpg',
      ),
      BannerItem(
        title: widget.localizations.dailyAchievementTitle,
        subtitle: widget.localizations.dailyAchievementSubtitle,
        imagePath: 'assets/images/welcome_banner_bg.jpg',
      ),
      BannerItem(
        title: widget.localizations.dailyTipTitle,
        subtitle: widget.localizations.dailyTipSubtitle,
        imagePath: 'assets/images/welcome_banner_bg.jpg',
      ),
      BannerItem(
        title: widget.localizations.dailyPlanTitle,
        subtitle: widget.localizations.dailyPlanSubtitle,
        imagePath: 'assets/images/welcome_banner_bg.jpg',
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildBannerContent(items[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 20 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? TColors.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerContent(BannerItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(item.imagePath),
          fit: BoxFit.cover,
          alignment: const Alignment(0.0, 0.40),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black.withOpacity(0.6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: widget.textTheme.titleMedium?.copyWith(
                color: TColors.textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.subtitle,
              style: widget.textTheme.titleSmall?.copyWith(
                color: TColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
