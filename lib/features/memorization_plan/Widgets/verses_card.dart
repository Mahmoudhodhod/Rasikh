import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../logic/memorization_utils.dart';
import '../../../l10n/app_localizations.dart';

class VersesCard extends StatelessWidget {
  final bool isMemorizing;
  final String visibleVerseText;
  final ScrollController scrollController;
  final String fullVerseText;
  final String userInput;
  final VoidCallback? onCheckPressed;

  const VersesCard({
    Key? key,
    required this.isMemorizing,
    required this.visibleVerseText,
    required this.scrollController,
    required this.fullVerseText,
    required this.userInput,
    this.onCheckPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const double iconSize = 120.0;
    final bool isScrollable = isMemorizing;

    return Card(
      elevation: 1,
      color: const Color.fromARGB(243, 243, 243, 243),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: TColors.secondary.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -33,
            bottom: -33,
            child: Image.asset(
              'assets/icons/quran_VersesCard_icon.png',
              height: iconSize,
              width: iconSize,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 40.0,
            ),
            child: (isScrollable)
                ? ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 180.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 20,
                            height: 2.2,
                            color: TColors.textPrimary,
                          ),
                          children: MemorizationUtils.buildVerseSpans(
                            fullVerseText,
                            userInput,
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    isMemorizing
                        ? (visibleVerseText.isEmpty
                              ? localizations.startTypingBelow
                              : visibleVerseText)
                        : visibleVerseText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      height: 2.2,
                      color: TColors.textPrimary,
                    ),
                  ),
          ),
          if (isMemorizing && onCheckPressed != null)
            Positioned(
              bottom: 2,
              right: 16,
              child: IconButton(
                onPressed: onCheckPressed,
                style: IconButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Iconsax.tick_circle),
                tooltip: localizations.checkButton,
              ),
            ),


        ],
      ),
    );
  }
}
