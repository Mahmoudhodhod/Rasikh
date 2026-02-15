import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import 'package:rasikh/l10n/app_localizations.dart';
import 'package:rasikh/main.dart';

// import '../../features/contact_us/contact_screen.dart';
import '../../features/auth/screen/logout_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/repository/profile_repository.dart';

import '../../features/home/logic/plan_selection_controller.dart';
import '../../features/memorization_plan/repository/memorization_repository.dart';
import '../../core/api/api_exceptions.dart';
import '../../features/home/repository/dashboard_repository.dart';
import '../navigation/tabs.dart';
import '../navigation/provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Future<void> _launchWebsite(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final Uri url = Uri.parse('https://rasikh-two.vercel.app');
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.somethingWentWrong),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }
    final currentLocale = ref.watch(localeProvider);
    final textTheme = Theme.of(context).textTheme;
    final userAsync = ref.watch(userProfileProvider);
    final user = userAsync.asData?.value;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final trailingChevron = isRtl
        ? Iconsax.arrow_left_2
        : Iconsax.arrow_right_3;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      backgroundColor: TColors.lightContainer,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(
              userName: user != null
                  ? "${user.firstName} ${user.lastName}"
                  : l10n.welcomeMessage,
              profileImageUrl:
                  (user?.profileImage != null && user!.profileImage!.isNotEmpty)
                  ? user.profileImage
                  : null,
              onProfileTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final futures = <Future<void>>[];

                  ref.invalidate(userProfileProvider);

                  futures.add(
                    ref
                        .read(planSelectionControllerProvider.notifier)
                        .loadPlans(),
                  );

                  ref.invalidate(dashboardStatsProvider);
                  ref.invalidate(currentPlanProvider);

                  await Future.wait(futures);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  children: [
                    _SectionHeader(title: l10n.mainSection),

                    _buildDrawerItem(
                      context: context,
                      icon: Iconsax.home_1,
                      title: l10n.homePage,
                      trailing: trailingChevron,
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(bottomNavIndexProvider.notifier).state =
                            HomeTab.dashboard.index;
                      },
                    ),

                    _buildDrawerItem(
                      context: context,
                      icon: Iconsax.global,
                      title: l10n.openInWebSite,
                      trailing: Iconsax.export_1,
                      color: TColors.primary,
                      onTap: () {
                        Navigator.pop(context);
                        _launchWebsite(context, l10n);
                      },
                    ),

                    const SizedBox(height: 10),
                    _DividerCard(),

                    const SizedBox(height: 10),
                    _SectionHeader(title: l10n.preferences),

                    _buildExpansionTile(
                      context: context,
                      leadingIcon: Iconsax.language_square,
                      title: l10n.language,
                      childrenPadding: EdgeInsetsDirectional.only(
                        start: 10,
                        end: 8,
                        bottom: 8,
                      ),
                      children: [
                        _buildSelectableTile(
                          title: l10n.languageEnglish,
                          selected: currentLocale.languageCode == 'en',
                          onTap: () {
                            ref.read(localeProvider.notifier).state =
                                const Locale('en');
                            Navigator.pop(context);
                          },
                          isRtl: isRtl,
                        ),
                        _buildSelectableTile(
                          title: l10n.languageArabic,
                          selected: currentLocale.languageCode == 'ar',
                          onTap: () {
                            ref.read(localeProvider.notifier).state =
                                const Locale('ar');
                            Navigator.pop(context);
                          },
                          isRtl: isRtl,
                        ),
                      ],
                    ),

                    _buildExpansionTile(
                      context: context,
                      leadingIcon: Iconsax.calendar_1,
                      title: l10n.memrizationPlans,
                      childrenPadding: EdgeInsetsDirectional.only(
                        start: 6,
                        end: 6,
                        bottom: 10,
                      ),
                      children: [
                        _buildPlansList(context, ref, l10n, isRtl: isRtl),
                      ],
                    ),

                    const SizedBox(height: 10),
                    _DividerCard(),

                    const SizedBox(height: 10),
                    _SectionHeader(title: l10n.supportSection),

                    _buildDrawerItem(
                      context: context,
                      icon: Iconsax.setting_2,
                      title: l10n.settings,
                      trailing: trailingChevron,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),

                    // _buildDrawerItem(
                    //   context: context,
                    //   icon: Iconsax.message,
                    //   title: l10n.contactUs,
                    //   trailing: trailingChevron,
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) =>
                    //             const ContactUsScreen(isLoggedIn: true),
                    //       ),
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 10),
                    _DividerCard(),

                    const SizedBox(height: 10),
                    _SectionHeader(title: l10n.accountSection),

                    _buildDrawerItem(
                      context: context,
                      icon: Iconsax.logout,
                      title: l10n.logout,
                      trailing: Iconsax.arrow_left_2,
                      color: TColors.reportBad,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LogoutScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 6),
              child: Text(
                l10n.appVersion,
                style: textTheme.bodySmall!.copyWith(
                  color: TColors.textSecondary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n, {
    required bool isRtl,
  }) {
    final plansAsync = ref.watch(planSelectionControllerProvider);
    final userAsync = ref.watch(userProfileProvider);
    final currentPlanId = userAsync.asData?.value.planId ?? 0;

    final currentPlanAsync = ref.watch(currentPlanProvider);
    bool isCurrentPlanSkipable = false;

    if (currentPlanAsync.hasError) {
      if (currentPlanAsync.error is ApiException) {
        final type = (currentPlanAsync.error as ApiException).type;
        if (type == ApiErrorType.planCompleted ||
            type == ApiErrorType.planEmpty) {
          isCurrentPlanSkipable = true;
        }
      } else {
        isCurrentPlanSkipable = true;
      }
    }

    final statsAsync = ref.watch(dashboardStatsProvider);
    if (!isCurrentPlanSkipable && statsAsync.hasValue) {
      if (statsAsync.value!.overallProgress >= 99.0) {
        isCurrentPlanSkipable = true;
      }
    }

    final bool isCurrentPlanDone = isCurrentPlanSkipable;

    return plansAsync.when(
      data: (plans) {
        if (plans.isEmpty) return const SizedBox.shrink();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 6),
          itemCount: plans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final plan = plans[index];

            final bool isPast = plan.id < currentPlanId;
            final bool isCurrent = plan.id == currentPlanId;
            final bool isImmediateNext = plan.id == currentPlanId + 1;

            bool isLocked = plan.isLocked;
            if (isImmediateNext && isCurrentPlanDone) isLocked = false;
            if (isPast || isCurrent) isLocked = false;

            final bool isClickable = !isLocked && !isCurrent;

            late final IconData leadingIcon;
            late final Color leadingColor;
            late final Color titleColor;
            late final String subtitleText;
            late final IconData trailingIcon;
            late final Color trailingColor;

            if (isCurrent) {
              leadingIcon = Iconsax.tick_circle;
              leadingColor = TColors.primary;
              titleColor = TColors.primary;
              subtitleText = l10n.planInProgress;
              trailingIcon = Iconsax.tick_circle;
              trailingColor = TColors.primary;
            } else if (isPast) {
              leadingIcon = Iconsax.verify;
              leadingColor = Colors.green;
              titleColor = TColors.textPrimary;
              subtitleText = l10n.planCompleted;
              trailingIcon = Iconsax.tick_circle;
              trailingColor = Colors.green;
            } else if (isLocked) {
              leadingIcon = Iconsax.lock;
              leadingColor = Colors.grey.shade400;
              titleColor = Colors.grey.shade500;
              subtitleText = l10n.planLockedHint;
              trailingIcon = Iconsax.lock;
              trailingColor = Colors.grey.shade400;
            } else {
              leadingIcon = Iconsax.arrow_circle_right;
              leadingColor = TColors.secondary;
              titleColor = TColors.textPrimary;
              subtitleText = l10n.tapToStart;
              trailingIcon = isRtl
                  ? Iconsax.arrow_left_3
                  : Iconsax.arrow_right_3;
              trailingColor = TColors.textSecondary;
            }

            final Color tileBg = isCurrent
                ? TColors.primary.withOpacity(0.08)
                : Colors.white.withOpacity(0.0);

            return Material(
              color: tileBg,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: isClickable
                    ? () async {
                        try {
                          await ref
                              .read(planSelectionControllerProvider.notifier)
                              .selectPlan(plan.id);

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.planSwitchedTo(plan.name)),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.failedToSwitchPlanTryLater),
                                backgroundColor: TColors.reportBad,
                              ),
                            );
                          }
                        }
                      }
                    : () {
                        if (isCurrent) return;
                        if (isLocked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.planMustCompleteToUnlock),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      Icon(leadingIcon, color: leadingColor, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: titleColor,
                                fontFamily: 'Tajawal',
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitleText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isLocked
                                    ? Colors.grey.shade400
                                    : TColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(trailingIcon, color: trailingColor, size: 18),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required IconData trailing,
    Color color = TColors.textPrimary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: TColors.primary.withOpacity(0.12),
          highlightColor: TColors.primary.withOpacity(0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(trailing, color: TColors.textSecondary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required bool isRtl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected
            ? TColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: TColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? Iconsax.tick_circle
                      : (isRtl ? Iconsax.arrow_left_3 : Iconsax.arrow_right_3),
                  color: selected ? TColors.primary : TColors.textSecondary,
                  size: selected ? 20 : 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required BuildContext context,
    required IconData leadingIcon,
    required String title,
    required List<Widget> children,
    EdgeInsetsGeometry? childrenPadding,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: TColors.primary.withOpacity(0.12),
          highlightColor: TColors.primary.withOpacity(0.06),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: TColors.borderSecondary.withOpacity(0.8)),
          ),
          child: ExpansionTile(
            leading: Icon(leadingIcon, color: TColors.textPrimary, size: 22),
            title: Text(
              title,
              style: const TextStyle(
                color: TColors.textPrimary,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            childrenPadding:
                childrenPadding ?? const EdgeInsets.symmetric(horizontal: 10),
            collapsedIconColor: TColors.textSecondary,
            iconColor: TColors.textSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;
  final VoidCallback onProfileTap;

  const _DrawerHeader({
    required this.userName,
    required this.profileImageUrl,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.secondary, TColors.primary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/logos/rasikh_logo.png', height: 34),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 14),

          InkWell(
            onTap: onProfileTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: profileImageUrl!,
                        key: ValueKey(profileImageUrl!),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/default_profile.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/default_profile.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Text(
            userName,
            style: textTheme.titleMedium!.copyWith(
              color: TColors.textWhite,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 4,
        end: 4,
        top: 6,
        bottom: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: TColors.textSecondary.withOpacity(0.8),
          fontSize: 12,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _DividerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: TColors.borderSecondary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
