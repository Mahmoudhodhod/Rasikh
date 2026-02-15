import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../../features/guide/user_guide_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../../features/auth/screen/login_screen.dart';

class RasekhAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showNotification;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onBackPressed;

  const RasekhAppBar({
    Key? key,
    this.title,
    this.showLogo = false,
    this.showNotification = true,
    this.bottom,
    this.onNotificationPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState == AuthStatus.guest;

    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      shadowColor: Colors.black12,
      iconTheme: const IconThemeData(color: Colors.black87, size: 28),
      automaticallyImplyLeading: !isGuest,
      leading: isGuest
          ? IconButton(
              icon: const Icon(Icons.login, color: TColors.primary),
              tooltip: appLocalizations?.loginButton ?? '',
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (c) => const LoginScreen()));
              },
            )
          : (onBackPressed != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onBackPressed,
                  )
                : null),
      centerTitle: true,
      title: showLogo && appLocalizations != null
          ? _buildLogo(appLocalizations)
          : _buildTitleText(),
      actions: [
        if (showNotification)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16.0),
            child: IconButton(
              icon: const Icon(Iconsax.message_question),
              color: TColors.textPrimary,
              tooltip: appLocalizations?.userGuide ?? '',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserGuideScreen(),
                  ),
                );
              },
            ),
          ),
      ],
      bottom: bottom,
    );
  }

  Widget _buildLogo(AppLocalizations appLocalizations) {
    return Image.asset(
      'assets/logos/rasikh_logo.png',
      height: 45,
      errorBuilder: (context, error, stackTrace) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.book, color: Colors.green),
            SizedBox(width: 8),
            Text(
              "${appLocalizations.appTitle}",
              style: TextStyle(color: Colors.black87),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleText() {
    return Text(
      title ?? "",
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tajawal',
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(80.0 + (bottom?.preferredSize.height ?? 0.0));
}
