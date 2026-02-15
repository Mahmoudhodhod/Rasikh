import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../home/logic/plan_selection_controller.dart';
import '../../profile/repository/profile_repository.dart';
import '../../../l10n/app_localizations.dart';

class PlanEmptyWidget extends ConsumerWidget {
  const PlanEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(planSelectionControllerProvider);
    final userAsync = ref.watch(userProfileProvider);
    final currentPlanId = userAsync.asData?.value.planId ?? 0;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.folder_open,
                size: 60,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.emptyPlanMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.emptyPlanSubmessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                l10n.availablePlansLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            plansAsync.when(
              data: (plans) {
                final otherPlans = plans
                    .where((p) => p.id != currentPlanId)
                    .toList();

                if (otherPlans.isEmpty) {
                  return Text(l10n.noOtherPlansAvailable);
                }

                return Column(
                  children: otherPlans.map((plan) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: TColors.secondary,
                          child: Icon(
                            Iconsax.book,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          plan.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          ref
                              .read(planSelectionControllerProvider.notifier)
                              .selectPlan(plan.id);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Text(l10n.failedToLoadPlansWithError(e.toString())),
            ),
          ],
        ),
      ),
    );
  }
}
