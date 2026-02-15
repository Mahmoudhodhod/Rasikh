import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/navigation/tabs.dart';
import '../../core/navigation/provider.dart';

class UserGuideScreen extends ConsumerWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final is_arabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: TColors.light,
      appBar: AppBar(
        title: Text(l10n.userGuideTitle),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 760
              ? 760.0
              : constraints.maxWidth;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    _HeroHeader(
                      title: l10n.userGuideTitle,
                      subtitle: l10n.footerMessage,
                    ),
                    const SizedBox(height: 14),

                    _buildGuideCard(
                      context,
                      icon: Iconsax.lovely,
                      title: l10n.welcomeTitle,
                      content: l10n.welcomeContent,
                      action: _PrimaryAction(
                        icon: Iconsax.global,
                        label: l10n.visitWebsite,
                        onPressed: () async {
                          final Uri url = Uri.parse(
                            'https://rasikh-two.vercel.app',
                          );
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $url');
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildGuideCard(
                      context,
                      icon: Iconsax.map_1,
                      title: l10n.firstStepTitle,
                      content: l10n.firstStepContent,
                      action: _PrimaryAction(
                        icon: is_arabic ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                        label: l10n.goToMemorization,
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(bottomNavIndexProvider.notifier).state =
                              HomeTab.planHub.index;
                          ref
                                  .read(memorizationTabIndexProvider.notifier)
                                  .state =
                              MemorizationTab.plan.index;
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildMethodologyCard(context),

                    const SizedBox(height: 14),

                    _buildGuideCard(
                      context,
                      icon: Iconsax.chart_2,
                      title: l10n.progressTitle,
                      content: l10n.progressContent,
                      action: _SecondaryAction(
                        label: l10n.viewArchive,
                        icon: is_arabic ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(bottomNavIndexProvider.notifier).state =
                              HomeTab.planHub.index;
                          ref
                                  .read(memorizationTabIndexProvider.notifier)
                                  .state =
                              MemorizationTab.archive.index;
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildGuideCard(
                      context,
                      icon: Iconsax.repeat,
                      title: l10n.reviewTitle,
                      content: l10n.reviewContent,
                      action: _SecondaryAction(
                        label: l10n.reviewTitle,
                        icon: is_arabic ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(bottomNavIndexProvider.notifier).state =
                              HomeTab.planHub.index;
                          ref
                                  .read(memorizationTabIndexProvider.notifier)
                                  .state =
                              MemorizationTab.review.index;
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildGuideCard(
                      context,
                      icon: Iconsax.lamp_on,
                      title: l10n.masteryTitle,
                      content: l10n.masteryContent,
                      action: Column(
                        children: [
                          _SecondaryAction(
                            icon: Iconsax.book_1,
                            label: l10n.goToMushaf,
                            onPressed: () {
                              Navigator.pop(context);
                              ref.read(bottomNavIndexProvider.notifier).state =
                                  HomeTab.resourcesHub.index;
                            },
                          ),
                          const SizedBox(height: 10),
                          _HintChip(text: l10n.quranGreeting),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      l10n.footerMessage,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TColors.textPrimary.withOpacity(0.65),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height:40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    Widget? action,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBadge(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: TColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.7,
              color: TColors.textPrimary,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 14), action],
        ],
      ),
    );
  }

  Widget _buildMethodologyCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TColors.primary.withOpacity(0.18)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [TColors.primary.withOpacity(0.08), TColors.lightContainer],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.secondStepTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: TColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.methodologyIntro,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: TColors.textPrimary.withOpacity(0.8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StepTile(
                icon: Iconsax.headphone,
                title: l10n.listen,
                subtitle: l10n.listenDesc,
              ),
              _StepTile(
                icon: Iconsax.book_1,
                title: l10n.read,
                subtitle: l10n.readDesc,
              ),
              _StepTile(
                icon: Iconsax.edit_2,
                title: l10n.write,
                subtitle: l10n.writeDesc,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _HeroHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColors.primary.withOpacity(0.18),
            TColors.primary.withOpacity(0.06),
          ],
        ),
        border: Border.all(color: TColors.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Iconsax.info_circle, color: TColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: TColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: TColors.textPrimary.withOpacity(0.7),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TColors.primary.withOpacity(0.12)),
      ),
      child: Icon(icon, color: TColors.primary, size: 22),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _PrimaryAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onPressed;
  const _SecondaryAction({
    this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Iconsax.arrow_left_2, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: TColors.primary.withOpacity(0.6)),
          foregroundColor: TColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StepTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: TColors.primary,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 11,
                    height: 1.25,
                    color: TColors.textPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HintChip extends StatelessWidget {
  final String text;
  const _HintChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TColors.primary.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.tick_circle, size: 18, color: TColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.35,
                color: TColors.textPrimary.withOpacity(0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
