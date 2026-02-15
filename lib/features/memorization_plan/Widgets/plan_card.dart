import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
class PlanCard extends StatelessWidget {
  final bool showPlanOnly;
  final Animation<double> animation;
  final VoidCallback onStartPressed;
  final String title;
  final String surahName;
  final int startAyah;
  final int endAyah;

  const PlanCard({
    Key? key,
    required this.showPlanOnly,
    required this.animation,
    required this.onStartPressed,
    required this.title,
    required this.surahName,
    required this.startAyah,
    required this.endAyah,
  }
  
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;
    const localColors = (secondary: Color(0xFF006400), textWhite: Colors.white);

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            color: TColors.secondary,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('من سورة:', style: textTheme.titleMedium),
                    const SizedBox(width: 8),
                    _buildStyledBox(
                      surahName,
                      width: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  children: [
                    Text(localizations.fromAyah, style: textTheme.titleMedium),
                    const SizedBox(width: 8),
                    _buildStyledBox(startAyah.toString(), width: 70),
                    const SizedBox(width: 16),
                    Text(localizations.toAyah, style: textTheme.titleMedium),
                    const SizedBox(width: 8),
                    _buildStyledBox(endAyah.toString(), width: 70),
                  ],
                ),
                const SizedBox(height: 20),
                if (showPlanOnly)
                  Center(
                    child: ScaleTransition(
                      scale: animation,
                      child: ElevatedButton(
                        onPressed: onStartPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                           localizations.startMemorizingButton,
                          style: textTheme.titleMedium?.copyWith(
                            color: localColors.textWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledBox(String text, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.grey.shade500, width: 1.5),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
