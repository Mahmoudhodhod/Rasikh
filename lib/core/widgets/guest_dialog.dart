import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';

class GuestDialog extends StatelessWidget {
  const GuestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.guestModeTitle),
      content: Text(AppLocalizations.of(context)!.guestModeMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          },
          child: Text(AppLocalizations.of(context)!.loginButton),
        ),
      ],
    );
  }
}

Future<void> showGuestDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const GuestDialog(),
  );
}
