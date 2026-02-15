import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/report_model.dart';
import 'repository/reports_repository.dart';
import '../../core/widgets/login_required_widget.dart';
import '../auth/repository/auth_repository.dart';

enum _HeaderContentType { hadith, motivation, progress, reminder }

_HeaderContentType _pickHeaderType() {
  final index = DateTime.now().millisecondsSinceEpoch % 4;
  return _HeaderContentType.values[index];
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final authState = ref.watch(authStateProvider);
    final isGuest = authState == AuthStatus.guest;

    if (isGuest) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: LoginRequiredWidget(
          title: l10n.loginRequiredTitle,
          message: l10n.reportsGuestMessage,
        ),
      );
    }

    final reportAsync = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: reportAsync.when(
        data: (report) => _buildBody(context, textTheme, l10n, report),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) =>
            _buildErrorWidget(context, ref, error, l10n),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TextTheme textTheme,
    AppLocalizations l10n,
    ReportModel report,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _SlideFadeTransition(
              delay: const Duration(milliseconds: 100),
              offset: const Offset(0, -0.2),
              child: _buildHeaderCard(textTheme, l10n, report),
            ),
            const SizedBox(height: 24),

            _SlideFadeTransition(
              delay: const Duration(milliseconds: 0),
              child: _buildSectionTitle(textTheme, l10n),
            ),
            const SizedBox(height: 18),

            _buildStatsGrid(context, l10n, report),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    WidgetRef ref,
    Object error,
    AppLocalizations l10n,
  ) {
    final textTheme = Theme.of(context).textTheme;

    String errorMessage = error.toString();
    IconData errorIcon = Iconsax.warning_2;

    if (errorMessage.contains("internet") || errorMessage.contains("اتصال")) {
      errorIcon = Iconsax.wifi_square;
      errorMessage = l10n.checkInternetThenRetry;
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        errorIcon,
                        size: 60,
                        color: Colors.red.shade400,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.soryFailedToLoadReport,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(reportProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retryButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: TColors.primary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    TextTheme textTheme,
    AppLocalizations l10n,
    ReportModel report,
  ) {
    final headerType = _pickHeaderType();

    late final String label;
    late final String title;
    late final String subtitle;

    switch (headerType) {
      case _HeaderContentType.hadith:
        label = l10n.prophetSaidLabel;
        title = report.hadith;
        subtitle = report.quote;
        break;

      case _HeaderContentType.motivation:
        label = '';
        title = 'استمر، فكل خطوة تقرّبك من كتاب الله';
        subtitle = '«بالقرآن تحيا القلوب، وبالثبات يكتمل الطريق.»';
        break;

      case _HeaderContentType.progress:
        label = l10n.progressLabel;
        title = 'أنجزت ${report.savedVersesCount} آية حتى الآن';
        subtitle =
            'بمعدل يومي ${report.dailyAverage.toStringAsFixed(1)} آية، أداء رائع 🌱';
        break;

      case _HeaderContentType.reminder:
        label = l10n.reminderLabel;
        title = '﴿وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ﴾';
        subtitle = 'ما دمت مع القرآن، فأنت في طريق الخير.';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.05),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColors.primary.withOpacity(0.05),
            TColors.primary.withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: textTheme.titleSmall?.copyWith(
                color: TColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: textTheme.bodyMedium?.color?.withOpacity(0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(TextTheme textTheme, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Iconsax.book_1, color: TColors.secondary, size: 28),
        const SizedBox(width: 8),
        Text(
          l10n.memorizationReportTitle,
          style: textTheme.headlineSmall?.copyWith(
            color: TColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AppLocalizations l10n,
    ReportModel report,
  ) {
    double parseValue(dynamic val) {
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final children = [
      _buildStatCard(
        icon: Iconsax.document_text,
        color: Colors.green,
        title: l10n.savedVersesStatTitle,
        valueStr: report.savedVersesCount.toString(),
        targetValue: parseValue(report.savedVersesCount),
        unit: l10n.savedVersesStatUnit,
        delayIndex: 0,
      ),
      _buildStatCard(
        icon: Iconsax.document_copy,
        color: Colors.blue,
        title: l10n.savedPagesStatTitle,
        valueStr: report.savedPagesCount.toString(),
        targetValue: parseValue(report.savedPagesCount),
        unit: l10n.savedPagesStatUnit,
        delayIndex: 1,
      ),
      _buildStatCard(
        icon: Iconsax.book_square,
        color: Colors.brown,
        title: l10n.totalPartsStatTitle,
        valueStr: report.totalParts.toString(),
        targetValue: parseValue(report.totalParts),
        unit: l10n.savedJuzStatUnit,
        delayIndex: 6,
      ),
      _buildStatCard(
        icon: Iconsax.archive_book,
        color: Colors.orange,
        title: l10n.savedJuzStatTitle,
        valueStr: report.savedJuzCount.toString(),
        targetValue: parseValue(report.savedJuzCount),
        unit: l10n.savedJuzStatUnit,
        delayIndex: 2,
      ),
      _buildStatCard(
        icon: Iconsax.chart_2,
        color: Colors.purple,
        title: l10n.dailyAverageStatTitle,
        valueStr: report.dailyAverage.toStringAsFixed(1),
        targetValue: report.dailyAverage,
        unit: l10n.dailyAverageStatUnit,
        delayIndex: 3,
        isDecimal: true,
      ),

      _buildStatCard(
        icon: Iconsax.link_2,
        color: Colors.teal,
        title: l10n.linkedVersesStatTitle,
        valueStr: report.linkedVersesCount.toString(),
        targetValue: parseValue(report.linkedVersesCount),
        unit: l10n.savedVersesStatUnit,
        delayIndex: 4,
      ),

      _buildStatCard(
        icon: Iconsax.refresh_square_2,
        color: Colors.indigo,
        title: l10n.reviewedVersesStatTitle,
        valueStr: report.reviewedVersesCount.toString(),
        targetValue: parseValue(report.reviewedVersesCount),
        unit: l10n.savedVersesStatUnit,
        delayIndex: 5,
      ),

      _buildStatCard(
        icon: Iconsax.speedometer,
        color: Colors.redAccent,
        title: l10n.performanceStatTitle,
        valueStr: report.performance.toStringAsFixed(0),
        targetValue: report.performance,
        unit: l10n.performanceStatUnit,
        delayIndex: 7,
        isDecimal: false,
      ),

      _buildStatCard(
        icon: Iconsax.tick_circle,
        color: Colors.lightGreen,
        title: l10n.completionStatTitle,
        valueStr: report.completionPercentage.toStringAsFixed(0),
        targetValue: report.completionPercentage,
        unit: '%',
        delayIndex: 8,
        isDecimal: false,
      ),

      _buildStatCard(
        icon: Iconsax.calendar_1,
        color: Colors.cyan,
        title: l10n.completedDaysStatTitle,
        valueStr: report.completedDays.toString(),
        targetValue: parseValue(report.completedDays),
        unit: l10n.daysUnit,
        delayIndex: 9,
      ),
    ];

    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String title,
    required String valueStr,
    required double targetValue,
    required String unit,
    required int delayIndex,
    bool isDecimal = false,
  }) {
    final delay = Duration(milliseconds: 400 + (delayIndex * 150));

    return _SlideFadeTransition(
      delay: delay,
      offset: const Offset(0, 0.2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: TColors.borderSecondary),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      const SizedBox(height: 12),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: TColors.textSecondary,
                          ),
                          maxLines: 1,
                        ),
                      ),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: targetValue),
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeOutExpo,
                              builder: (context, value, child) {
                                return Text(
                                  isDecimal
                                      ? value.toStringAsFixed(1)
                                      : value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: TColors.textPrimary,
                                    fontFamily: 'Tajawal',
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            Text(
                              unit,
                              style: TextStyle(
                                fontSize: 14,
                                color: TColors.textSecondary.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SlideFadeTransition extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;

  const _SlideFadeTransition({
    Key? key,
    required this.child,
    required this.delay,
    this.offset = const Offset(0, 0.1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              offset.dx * (1 - value) * 100,
              offset.dy * (1 - value) * 100,
            ),
            child: child,
          ),
        );
      },
      child: child,
    )._withDelay(delay);
  }
}

extension _DelayExt on Widget {
  Widget _withDelay(Duration delay) {
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Opacity(opacity: 0, child: SizedBox());
        }
        return this;
      },
    );
  }
}
