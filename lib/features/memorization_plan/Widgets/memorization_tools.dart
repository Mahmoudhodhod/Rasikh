import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/memorization_audio_controller.dart';
import '../../../../core/services/audio_service.dart';

class MemorizationTools extends ConsumerWidget {
  final int repetitionTarget;
  final int currentRepetition;
  final VoidCallback onIncrementRepetition;
  final VoidCallback onDecrementRepetition;
  final bool isIncrementEnabled;
  final String? audioUrl;
  final VoidCallback? onCompleteListening;
  final VoidCallback onStartWriting;
  final bool isWritingDone;

  const MemorizationTools({
    Key? key,
    required this.repetitionTarget,
    required this.currentRepetition,
    required this.onIncrementRepetition,
    required this.onDecrementRepetition,
    required this.onStartWriting,
    required this.isWritingDone,
    this.isIncrementEnabled = true,
    this.audioUrl,
    this.onCompleteListening,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;
    final audioStatus = ref.watch(memorizationAudioControllerProvider);

    final int doneInt = currentRepetition.clamp(0, repetitionTarget);
    final double doneValue = doneInt.toDouble();
    final double leftValue = (repetitionTarget - doneInt).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToolColumn(
          child: InkWell(
            onTap: onStartWriting,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isWritingDone
                    ? TColors.primary.withOpacity(0.1)
                    : TColors.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.edit,
                size: 30,
                color: isWritingDone ? TColors.primary : TColors.secondary,
              ),
            ),
          ),
          label: localizations.writingAndRecitation,
          textTheme: textTheme,
        ),

        _buildToolColumn(
          child: SizedBox(
            height: 70,
            width: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  dataMap: {'done': doneValue, 'left': leftValue},
                  chartType: ChartType.ring,
                  ringStrokeWidth: 6,
                  totalValue: repetitionTarget.toDouble(),
                  legendOptions: const LegendOptions(showLegends: false),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValues: false,
                  ),
                  colorList: [TColors.secondary, Colors.grey.shade300],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.repetitionLabel,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      localizations.repetitionCount(
                        currentRepetition,
                        repetitionTarget,
                      ),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomChild: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Iconsax.add, size: 20),
                color:
                    (isIncrementEnabled && currentRepetition < repetitionTarget)
                    ? TColors.secondary
                    : Colors.grey,
                onPressed:
                    (isIncrementEnabled && currentRepetition < repetitionTarget)
                    ? onIncrementRepetition
                    : null,
              ),
              Text("$currentRepetition"),
              IconButton(
                icon: const Icon(Iconsax.minus, size: 20),
                color: (currentRepetition > 0) ? Colors.black : Colors.grey,
                onPressed: (currentRepetition > 0)
                    ? onDecrementRepetition
                    : null,
              ),
            ],
          ),
        ),

        _buildToolColumn(
          child: StreamBuilder<Duration?>(
            stream: ref.watch(audioServiceProvider).durationStream,
            builder: (context, durationSnapshot) {
              final duration = durationSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: ref.watch(audioServiceProvider).positionStream,
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  double progress = 0.0;
                  if (duration.inMilliseconds > 0) {
                    progress =
                        position.inMilliseconds / duration.inMilliseconds;
                  }
                  progress = progress.clamp(0.0, 1.0);

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      if (audioStatus == AudioStatus.playing ||
                          audioStatus == AudioStatus.paused)
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 3,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation(
                              TColors.secondary,
                            ),
                          ),
                        ),

                      InkWell(
                        onTap: () => ref
                            .read(memorizationAudioControllerProvider.notifier)
                            .toggleAudio(
                              audioUrl,
                              context,
                              onComplete: onCompleteListening,
                            ),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: audioStatus == AudioStatus.playing
                                ? TColors.secondary.withOpacity(0.2)
                                : const Color.fromRGBO(88, 139, 118, 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: _buildAudioIcon(audioStatus)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          label: audioStatus == AudioStatus.playing
              ? localizations.stopListening
              : localizations.listenNow,
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _buildToolColumn({
    required Widget child,
    String? label,
    Widget? bottomChild,
    TextTheme? textTheme,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label,
            style: textTheme?.titleSmall?.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
        if (bottomChild != null) bottomChild,
      ],
    );
  }

  Widget _buildAudioIcon(AudioStatus status) {
    switch (status) {
      case AudioStatus.loading:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: TColors.secondary,
          ),
        );
      case AudioStatus.playing:
        return const Icon(Iconsax.pause, size: 30, color: TColors.secondary);
      default:
        return Image.asset('assets/icons/mic_inactive.png', width: 70 * 0.5);
    }
  }
}

class CompleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CompleteButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColors.secondary.withOpacity(0.8),
              TColors.primary.withOpacity(0.8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 40.0),
          child: Text(
            localizations.completeMemorization,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
