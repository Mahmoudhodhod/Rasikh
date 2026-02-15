import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../reports/certificate_view_screen.dart';
import '../../reports/repository/certificates_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/logic/plan_selection_controller.dart';
import '../../profile/repository/profile_repository.dart';
import '../../memorization_plan/logic/memorization_controller.dart';
import '../../home/repository/dashboard_repository.dart';

class PlanCompletedWidget extends ConsumerStatefulWidget {
  final String completionDate;
  final int totalParts;

  const PlanCompletedWidget({
    Key? key,
    required this.completionDate,
    required this.totalParts,
  }) : super(key: key);

  @override
  ConsumerState<PlanCompletedWidget> createState() =>
      _PlanCompletedWidgetState();
}

class _PlanCompletedWidgetState extends ConsumerState<PlanCompletedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isSwitchingPlan = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: unused_result
      ref.refresh(planSelectionControllerProvider);
      // ignore: unused_result
      ref.refresh(dashboardStatsProvider);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSelectPlan(int newPlanId, String planName) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSwitchingPlan = true);
    try {
      await ref
          .read(memorizationControllerProvider.notifier)
          .changeToPlan(newPlanId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.planSwitchedTo(planName)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSwitchingPlan = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToSwitchPlan(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final plansAsync = ref.watch(planSelectionControllerProvider);
    final userAsync = ref.watch(userProfileProvider);
    final currentPlanId = userAsync.asData?.value.planId ?? 0;

    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.celebration_rounded,
                      size: 80,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        l10n.planCompletedCongrats,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall?.copyWith(
                          color: TColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.duaMessage,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoColumn(
                          l10n.dateOfCompletion,
                          widget.completionDate,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        _buildInfoColumn(
                          l10n.numberOfSavedParts,
                          widget.totalParts == 0
                              ? "..."
                              : "${widget.totalParts}",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: InkWell(
                    onTap: () => _handleCertificateTap(context, ref, l10n),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            TColors.primary,
                            TColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.getCertificate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Divider(),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          l10n.chooseNextStep,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      plansAsync.when(
                        data: (plans) {
                          final futurePlans = plans
                              .where((p) => p.id > currentPlanId)
                              .toList();

                          if (futurePlans.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l10n.allPlansCompleted,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }

                          final int nextImmediatePlanId = futurePlans.first.id;

                          return Column(
                            children: futurePlans.map((plan) {
                              bool isImmediateNext =
                                  plan.id == nextImmediatePlanId;

                              bool isLocked = isImmediateNext
                                  ? false
                                  : plan.isLocked;

                              bool isClickable = !isLocked && !_isSwitchingPlan;

                              Color cardColor = isLocked
                                  ? Colors.grey.shade50
                                  : Colors.white;
                              Color textColor = isLocked
                                  ? Colors.grey
                                  : Colors.black87;
                              IconData trailingIcon = isLocked
                                  ? Iconsax.lock
                                  : Icons.arrow_forward_ios_rounded;
                              Color iconColor = isLocked
                                  ? Colors.grey
                                  : TColors.secondary;

                              Color? borderColor = isImmediateNext
                                  ? TColors.secondary.withOpacity(0.5)
                                  : Colors.grey.shade200;

                              return Card(
                                elevation: isLocked ? 0 : 2,
                                color: cardColor,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isLocked
                                        ? Colors.transparent
                                        : borderColor,
                                  ),
                                ),
                                child: ListTile(
                                  enabled: isClickable,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: isLocked
                                        ? Colors.grey.shade200
                                        : TColors.secondary.withOpacity(0.1),
                                    child: Icon(
                                      Iconsax.book,
                                      color: isLocked
                                          ? Colors.grey
                                          : TColors.secondary,
                                    ),
                                  ),
                                  title: Text(
                                    plan.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    isLocked
                                        ? l10n.planLockedHint
                                        : l10n.tapToStart,
                                    style: TextStyle(
                                      color: isLocked
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Icon(
                                    trailingIcon,
                                    size: 20,
                                    color: iconColor,
                                  ),
                                  onTap: isClickable
                                      ? () => _onSelectPlan(plan.id, plan.name)
                                      : () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                l10n.planMustCompleteToUnlock,
                                              ),
                                            ),
                                          );
                                        },
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text(
                          l10n.failedToLoadPlans,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_isSwitchingPlan)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _handleCertificateTap(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final certificates = await ref.refresh(certificatesProvider.future);
      if (mounted) Navigator.pop(context);
      if (certificates.isNotEmpty) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CertificateViewScreen(certificate: certificates.first),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.certificateNotIssued)));
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.failedToLoadCertificate} $e')),
        );
      }
    }
  }
}
