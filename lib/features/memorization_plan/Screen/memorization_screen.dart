import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../logic/memorization_utils.dart';
import '../widgets/plan_card.dart';
import '../widgets/verses_card.dart';
import '../widgets/memorization_tools.dart';
import '../../../core/models/memorization_plan_model.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/memorization_controller.dart';
import '../../../core/utils/error_translator.dart';
import '../../../core/api/api_exceptions.dart';
import '../widgets/plan_completed_widget.dart';
import '../widgets/plan_empty_widget.dart';
import 'package:iconsax/iconsax.dart';

class MemorizationScreen extends ConsumerStatefulWidget {
  const MemorizationScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<MemorizationScreen> createState() => _MemorizationScreenState();
}

class _MemorizationScreenState extends ConsumerState<MemorizationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isProcessingSuccess = false;
  bool _showPlanOnly = true;
  bool _isMemorizing = false;
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  String _visibleVerseText = '';
  // ignore: unused_field
  late List<String> _fullVerseWords = [];

  late ScrollController _verseScrollController;
  MemorizationPlanModel? _currentPlan;
  double _manualScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _verseScrollController = ScrollController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _verseScrollController.dispose();
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void showPlanContent() {
    setState(() {
      _showPlanOnly = false;
    });
  }

  void _startMemorization() {
    setState(() {
      _showPlanOnly = false;
      _isMemorizing = true;
      _textController.clear();

      if (_currentPlan != null) {
        _visibleVerseText = _currentPlan!.fullVerseText;
      }
      _manualScrollOffset = 0.0;
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  void _stopMemorization() {
    setState(() {
      _showPlanOnly = true;
      _isMemorizing = false;
      _textController.clear();
      _focusNode.unfocus();
      if (_currentPlan != null) {
        _visibleVerseText = _currentPlan!.fullVerseText;
      }
    });
  }

  void _onTextChanged() {
    // final localizations = AppLocalizations.of(context)!;
    if (_currentPlan == null || !_isMemorizing || _isProcessingSuccess) return;

    final userInput = _textController.text;
    final targetText = _currentPlan!.fullVerseText;

    if (_verseScrollController.hasClients) {
      final progress = (userInput.length / targetText.length).clamp(0.0, 1.0);
      final baseTarget =
          (_verseScrollController.position.maxScrollExtent * progress);
      final finalTarget = (baseTarget + _manualScrollOffset).clamp(
        0.0,
        _verseScrollController.position.maxScrollExtent,
      );
      _verseScrollController.jumpTo(finalTarget);
    }

    final normalizedTarget = MemorizationUtils.normalizeText(targetText);
    final normalizedInput = MemorizationUtils.normalizeText(userInput);

    if (normalizedTarget.isNotEmpty && normalizedInput == normalizedTarget) {
      _handleWritingSuccess();
      return;
    }

    if (normalizedInput.length >= normalizedTarget.length * 0.95) {
      double similarity = MemorizationUtils.calculateSimilarity(
        targetText,
        userInput,
      );

      
      if (userInput.trim().length >= targetText.trim().length - 2) {
        if (similarity >= 0.95 && similarity < 1.0) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) _showCorrectionDialog(targetText, userInput);
          });
        }
      } else if (similarity < 0.95) {
        // final mistakesCount = MemorizationUtils.getMistakes(
        //   targetText,
        //   userInput,
        // ).length;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(localizations.mistakesWarning(mistakesCount)),
        //     backgroundColor: Colors.redAccent,
        //     duration: const Duration(seconds: 4),
        //     action: SnackBarAction(
        //       label: localizations.reviewButton,
        //       textColor: Colors.white,
        //       onPressed: () {},
        //     ),
        //   ),
        // );
      }
    }

    setState(() {});
  }

  void _manualCheck() {
    if (_currentPlan == null || !_isMemorizing || _isProcessingSuccess) return;

    final userInput = _textController.text;
    final targetText = _currentPlan!.fullVerseText;

    final normalizedTarget = MemorizationUtils.normalizeText(targetText);
    final normalizedInput = MemorizationUtils.normalizeText(userInput);

    if (normalizedTarget.isNotEmpty && normalizedInput == normalizedTarget) {
      _handleWritingSuccess();
      return;
    }

    final mistakes = MemorizationUtils.getMistakes(targetText, userInput);

    if (mistakes.isNotEmpty) {
      _showCorrectionDialog(targetText, userInput);
    } else {
      // Partial correct or empty
      if (userInput.trim().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Correct so far, keep going!",
            ), // TODO: Localize
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showCorrectionDialog(String target, String input) {
    final localizations = AppLocalizations.of(context)!;
    final mistakes = MemorizationUtils.getMistakes(target, input);
    if (mistakes.isEmpty) return;

    final correctionController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final orientation = MediaQuery.of(context).orientation;
        final isLandscape = orientation == Orientation.landscape;

        return StatefulBuilder(
          builder: (context, setState) {
            int currentMistakeIndex = 0;
            String? internalError;

            return StatefulBuilder(
              builder: (context, setInternalState) {
                final currentMistake = mistakes[currentMistakeIndex];

                void moveToNext() {
                  if (currentMistakeIndex < mistakes.length - 1) {
                    setInternalState(() {
                      currentMistakeIndex++;
                      internalError = null;
                      correctionController.clear();
                    });
                  } else {
                    Navigator.pop(context);
                    _handleWritingSuccess();
                  }
                }

                void validate() {
                  final inputNormalized =
                      MemorizationUtils.normalizeForVerification(
                        correctionController.text,
                      );
                  final expectedNormalized =
                      MemorizationUtils.normalizeForVerification(
                        currentMistake['expected'],
                      );

                  if (inputNormalized == expectedNormalized) {
                    moveToNext();
                  } else {
                    setInternalState(() {
                      internalError = localizations.correctionMismatchError;
                    });
                  }
                }

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Row(
                    children: [
                      const Icon(
                        Icons.edit_note,
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          localizations.correctionTitle(
                            currentMistakeIndex + 1,
                            mistakes.length,
                          ),
                          style: TextStyle(fontSize: isLandscape ? 18 : 22),
                        ),
                      ),
                    ],
                  ),
                  content: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLandscape ? 500 : 300,
                      maxHeight: isLandscape ? 200 : 400,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.actualWordLabel,
                            style: TextStyle(
                              fontSize: isLandscape ? 14 : 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentMistake['expected'],
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold,
                                fontSize: isLandscape ? 24 : 32,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.correctionDetailLabel(
                              MemorizationUtils.getDetailedCharacters(
                                currentMistake['expected'],
                              ).join('  '),
                            ),
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: isLandscape ? 14 : 18,
                              color: Colors.grey.shade600,
                              letterSpacing: 2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: correctionController,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: isLandscape ? 16 : 18),
                            decoration: InputDecoration(
                              hintText: localizations.correctionHintText,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (val) {
                              if (internalError != null) {
                                setInternalState(() => internalError = null);
                              }

                              final inputNormalized =
                                  MemorizationUtils.normalizeForVerification(
                                    val,
                                  );
                              final expectedNormalized =
                                  MemorizationUtils.normalizeForVerification(
                                    currentMistake['expected'],
                                  );

                              if (inputNormalized == expectedNormalized) {
                                moveToNext();
                              } else if (inputNormalized.length >=
                                  expectedNormalized.length) {
                                validate();
                              }
                            },
                            onSubmitted: (_) => validate(),
                          ),
                          if (internalError != null) ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                internalError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  actionsPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        localizations.cancelButton,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    TextButton(
                      onPressed: validate,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.withValues(alpha: 0.1),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                      ),
                      child: Text(
                        currentMistakeIndex < mistakes.length - 1
                            ? localizations.nextButton
                            : localizations.checkButton,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleWritingSuccess() async {
    final localizations = AppLocalizations.of(context)!;
    if (_isProcessingSuccess) return;
    setState(() => _isProcessingSuccess = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.writingSuccessSaving),
        backgroundColor: Colors.green,
      ),
    );

    await ref
        .read(memorizationControllerProvider.notifier)
        .incrementWritingCount();

    if (_currentPlan!.isWritingCompleted) {
      await _handlePlanCompletion();
    }

    if (mounted) {
      setState(() {
        _isProcessingSuccess = false;
        _isMemorizing = false;
        _textController.clear();
      });
    }
  }

  void _showExitWarning() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.warningTitle),
        content: Text(localizations.exitWarningMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.continueButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _stopMemorization();
            },
            child: Text(
              localizations.exitAnywayButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePlanCompletion() async {
    final localizations = AppLocalizations.of(context)!;
    if (_currentPlan == null) return;

    const int requiredRepetition = 1;
    const int requiredListening = 1;

    if (!_currentPlan!.isWritingCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.completeWritingWarning),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentPlan!.currentRepetition < requiredRepetition) {
      final remaining = requiredRepetition - _currentPlan!.currentRepetition;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.repetitionRemainingWarning(
              remaining,
              requiredRepetition,
            ),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentPlan!.currentListening < requiredListening) {
      final remaining = requiredListening - _currentPlan!.currentListening;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.listeningRemainingWarning(
              remaining,
              requiredListening,
            ),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    _stopMemorization();

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.recordingPlanCompletion),
          duration: const Duration(milliseconds: 500),
        ),
      );

      await ref
          .read(memorizationControllerProvider.notifier)
          .completeMemorization();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.planCompletionSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.savingError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final planState = ref.watch(memorizationControllerProvider);

    return PopScope(
      canPop: !_isMemorizing,
      onPopInvoked: (didPop) {
        if (!didPop && _isMemorizing) {
          _showExitWarning();
        }
      },
      child: Scaffold(
        body: planState.when(
          data: (plan) {
            if (plan == null) {
              return Center(child: Text(localizations.noActivePlan));
            }
            if (_currentPlan == null ||
                _currentPlan!.progressId != plan.progressId) {
              _currentPlan = plan;

              _fullVerseWords = plan.fullVerseText
                  .split(' ')
                  .where(
                    (word) => MemorizationUtils.normalizeText(word).isNotEmpty,
                  )
                  .toList();

              if (!_isMemorizing) {
                _visibleVerseText = plan.fullVerseText;
              }
            } else {
              _currentPlan = plan;
            }

            return Stack(
              children: [
                RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    // ignore: unused_result
                    ref.refresh(memorizationControllerProvider);
                    await Future.delayed(const Duration(milliseconds: 300));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          PlanCard(
                            showPlanOnly: _showPlanOnly,
                            animation: _animation,
                            onStartPressed: showPlanContent,
                            title: plan.title,
                            surahName: plan.surahName,
                            startAyah: plan.startAyah,
                            endAyah: plan.endAyah,
                          ),
                          if (!_showPlanOnly)
                            Column(
                              children: [
                                const SizedBox(height: 24),
                                NotificationListener<ScrollUpdateNotification>(
                                  onNotification: (notification) {
                                    if (notification.dragDetails != null &&
                                        _currentPlan != null) {
                                      final userInput = _textController.text;
                                      final progress =
                                          (userInput.length /
                                                  _currentPlan!
                                                      .fullVerseText
                                                      .length)
                                              .clamp(0.0, 1.0);
                                      final baseTarget =
                                          _verseScrollController
                                              .position
                                              .maxScrollExtent *
                                          progress;

                                      _manualScrollOffset =
                                          notification.metrics.pixels -
                                          baseTarget;
                                    }
                                    return false;
                                  },
                                  child: VersesCard(
                                    isMemorizing: _isMemorizing,
                                    visibleVerseText: _visibleVerseText,
                                    scrollController: _verseScrollController,
                                    fullVerseText: plan.fullVerseText,
                                    userInput: _textController.text,
                                    onCheckPressed: _manualCheck,
                                  ),
                                ),

                                const SizedBox(height: 24),
                                MemorizationTools(
                                  repetitionTarget: plan.repetitionTarget,
                                  currentRepetition: plan.currentRepetition,
                                  audioUrl: plan.audioUrl,

                                  onStartWriting: _startMemorization,
                                  isWritingDone: plan.isWritingCompleted,

                                  onCompleteListening: () {
                                    ref
                                        .read(
                                          memorizationControllerProvider
                                              .notifier,
                                        )
                                        .incrementListeningCount();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          localizations
                                              .listeningCompletedSuccess,
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  onIncrementRepetition: () {
                                    if (plan.currentRepetition < 10) {
                                      ref
                                          .read(
                                            memorizationControllerProvider
                                                .notifier,
                                          )
                                          .updateRepetition(
                                            plan.currentRepetition + 1,
                                          );
                                    }
                                  },
                                  onDecrementRepetition: () {
                                    if (plan.currentRepetition > 0) {
                                      plan.currentRepetition - 1;
                                    }
                                  },

                                  isIncrementEnabled: true,
                                ),

                                const SizedBox(height: 40),
                                CompleteButton(
                                  onPressed: _handlePlanCompletion,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isMemorizing) _buildHiddenInputField(),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            if (error is ApiException &&
                error.type == ApiErrorType.planCompleted) {
              return PlanCompletedWidget(
                completionDate:
                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                totalParts: 0,
              );
            }
            if (error is ApiException && error.type == ApiErrorType.planEmpty) {
              return const PlanEmptyWidget();
            }
            return _buildErrorWidget(context, error, localizations);
          },
        ),
      ),
    );
  }

  Widget _buildHiddenInputField() {
    return Opacity(
      opacity: 0.0,
      child: SizedBox(
        width: 0,
        height: 0,
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          autofocus: true,
          autocorrect: false,
          enableSuggestions: false,
          enableInteractiveSelection: false,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    AppLocalizations localizations,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final apiError = error is ApiException
        ? error
        : ApiException(ApiErrorType.unexpected);
    String errorMessage = getErrorMessage(apiError, context);

    IconData icon;
    Color color;
    String title;

    if (apiError.type == ApiErrorType.noActivePlan) {
      icon = Iconsax.calendar_remove;
      color = Colors.orange;
      title = localizations.errorNoPlanTitle;
    } else if (apiError.type == ApiErrorType.noInternet) {
      icon = Iconsax.wifi_square;
      color = Colors.red;
      title = localizations.errorNoInternetTitle;
    } else {
      icon = Iconsax.warning_2;
      color = Colors.red;
      title = localizations.errorGeneralTitle;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
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
                onPressed: () async {
                  // ignore: unused_result
                  ref.refresh(memorizationControllerProvider);
                  await Future.delayed(const Duration(milliseconds: 300));
                },
                icon: const Icon(Icons.refresh),
                label: Text(localizations.refreshButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
