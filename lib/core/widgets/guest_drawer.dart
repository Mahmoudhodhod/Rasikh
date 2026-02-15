import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
// import '../../features/contact_us/contact_screen.dart';
import 'package:rasikh/main.dart';
import 'package:rasikh/l10n/app_localizations.dart';

class GuestDrawer extends ConsumerWidget {
  const GuestDrawer({Key? key}) : super(key: key);
  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://rasekh.app/portal/login');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
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
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      backgroundColor: TColors.lightContainer,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [TColors.secondary, TColors.primary],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logos/rasikh_logo.png', height: 60),
                const SizedBox(height: 16),
                Text(
                  l10n.welcomeMessage,
                  style: textTheme.titleMedium!.copyWith(
                    color: TColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                ExpansionTile(
                  leading: const Icon(
                    Iconsax.language_square,
                    color: TColors.textPrimary,
                    size: 24,
                  ),
                  title: Text(
                    l10n.language,
                    style: const TextStyle(
                      color: TColors.textPrimary,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                  childrenPadding: const EdgeInsets.only(left: 20, right: 8),
                  children: [
                    ListTile(
                      title: Text(l10n.languageEnglish),
                      trailing: currentLocale.languageCode == 'en'
                          ? const Icon(
                              Iconsax.tick_circle,
                              color: TColors.primary,
                            )
                          : null,
                      onTap: () {
                        ref.read(localeProvider.notifier).state = const Locale(
                          'en',
                        );
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.languageArabic),
                      trailing: currentLocale.languageCode == 'ar'
                          ? const Icon(
                              Iconsax.tick_circle,
                              color: TColors.primary,
                            )
                          : null,
                      onTap: () {
                        ref.read(localeProvider.notifier).state = const Locale(
                          'ar',
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                // _buildDrawerItem(
                //   icon: Iconsax.message,
                //   title: l10n.contactUs,
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             const ContactUsScreen(isLoggedIn: false),
                //       ),
                //     );
                //   },
                // ),
                const Divider(height: 32, color: TColors.borderSecondary),
                _buildDrawerItem(
                  icon: Iconsax.global,
                  title: l10n.openInWebSite,
                  onTap: () {
                    Navigator.pop(context);
                    _launchWebsite();
                  },
                  color: TColors.primary,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.appVersion,
              style: textTheme.bodySmall!.copyWith(
                color: TColors.textSecondary.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = TColors.textPrimary,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      horizontalTitleGap: 10,
      onTap: onTap,
      hoverColor: TColors.primary.withOpacity(0.08),
      splashColor: TColors.primary.withOpacity(0.12),
    );
  }
}
