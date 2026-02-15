import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/models/archive_day_model.dart';
import '../repository/archive_repository.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final archiveAsync = ref.watch(archivePlanProvider);
    final localizations = AppLocalizations.of(context)!;

    final planNameAsync = ref.watch(planNameProvider);
    final planName = planNameAsync.asData?.value ?? "no";

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await ref
                .read(archiveRepositoryProvider)
                .getArchivePlan(forceRefresh: true);
            ref.invalidate(archivePlanProvider);
          } catch (e) {}
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTopHeader(planName, textTheme),
                const SizedBox(height: 16),
                archiveAsync.when(
                  data: (archiveDays) {
                    if (archiveDays.isEmpty) {
                      return SizedBox(
                        height: 300,
                        child: Center(child: Text(localizations.noArchiveData)),
                      );
                    }

                    return ArchiveByJuzSection(
                      archiveDays: archiveDays,
                      textTheme: textTheme,
                      localizations: localizations,
                      buildDayCard: (day) => _buildArchiveDayCard(
                        context,
                        ref,
                        textTheme,
                        day,
                        localizations,
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(localizations.archiveLoadError(e.toString())),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(archivePlanProvider),
                          child: Text(localizations.retryButton),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(String planName, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TColors.borderSecondary),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.book_1, color: TColors.secondary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              planName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineSmall?.copyWith(
                color: TColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchiveDayCard(
    BuildContext context,
    WidgetRef ref,
    TextTheme textTheme,
    ArchiveDayModel day,
    AppLocalizations localizations,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        shape: const Border(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                day.dayTitle,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildStatusChip(day.isCompleted, localizations),
          ],
        ),
        subtitle: _buildSubtitleLine(textTheme, day),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 24) / 3;
                return Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: _buildDetailItem(
                        localizations.detailMemorization,
                        day.memorizationDetails,
                        textTheme,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _buildRepetitionDetailItem(
                        day.repetitionCount,
                        textTheme,
                        localizations,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _buildListeningDetailItem(
                        day.listeningCount,
                        textTheme,
                        localizations,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _buildReviewDetailItem(
                        context,
                        ref,
                        day,
                        textTheme,
                        localizations,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _buildLinkingDetailItem(
                        context,
                        ref,
                        day,
                        textTheme,
                        localizations,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _buildWritingDetailItem(
                        day.writingCompleted,
                        textTheme,
                        localizations,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildSubtitleLine(TextTheme textTheme, ArchiveDayModel day) {
    final juz = day.memorizationJuz;
    final date = day.completedAt;
    if (juz == null && (date == null || date.isEmpty)) return null;

    final parts = <String>[];
    if (juz != null) parts.add('الجزء $juz');
    if (date != null && date.isNotEmpty) parts.add(date);

    return Text(
      parts.join(' • '),
      style: textTheme.bodySmall?.copyWith(color: TColors.textSecondary),
    );
  }

  Widget _buildStatusChip(bool isCompleted, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? TColors.primary : TColors.reportMedium,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Iconsax.tick_circle : Iconsax.timer_1,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            isCompleted
                ? localizations.statusCompleted
                : localizations.statusIncomplete,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            color: TColors.textSecondary,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildReviewDetailItem(
    BuildContext context,
    WidgetRef ref,
    ArchiveDayModel day,
    TextTheme textTheme,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.detailReview,
          style: textTheme.titleSmall?.copyWith(
            color: TColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        if (!day.hasReviewRange)
          Text(
            "---",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          )
        else if (day.isReviewCompleted)
          _buildMiniActionChip(
            label: localizations.statusCompleted,
            icon: Iconsax.info_circle,
            color: TColors.primary,
          )
        else
          InkWell(
            onTap: () {
              ref.read(memorizationTabIndexProvider.notifier).state = 1;
            },
            child: _buildMiniActionChip(
              label:
                  "${day.reviewVerseStartNumber}-${day.reviewVerseEndNumber}",
              icon: Iconsax.info_circle,
              color: TColors.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildWritingDetailItem(
    bool isCompleted,
    TextTheme textTheme,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.detailWriting,
          style: textTheme.titleSmall?.copyWith(
            color: TColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        isCompleted
            ? _buildMiniActionChip(
                label: localizations.writingCompleted,
                icon: Iconsax.tick_circle,
                color: TColors.primary,
              )
            : Text(
                localizations.writingNotCompleted,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
      ],
    );
  }

  Widget _buildLinkingDetailItem(
    BuildContext context,
    WidgetRef ref,
    ArchiveDayModel day,
    TextTheme textTheme,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.detailLinking,
          style: textTheme.titleSmall?.copyWith(
            color: TColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        if (!day.hasLinkRange)
          Text(
            "---",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          )
        else if (day.isLinkingCompleted)
          _buildMiniActionChip(
            label: localizations.linkDoneButton,
            icon: Iconsax.link,
            color: TColors.primary,
          )
        else
          InkWell(
            onTap: () {
              ref.read(memorizationTabIndexProvider.notifier).state = 2;
            },
            child: _buildMiniActionChip(
              label: localizations.linkButton,
              icon: Iconsax.link,
              color: TColors.secondary,
            ),
          ),
      ],
    );
  }

  Widget _buildMiniActionChip({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepetitionDetailItem(
    int count,
    TextTheme textTheme,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Iconsax.refresh, size: 12, color: TColors.textSecondary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "التكرار",
                style: textTheme.titleSmall?.copyWith(
                  color: TColors.textSecondary,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "$count ${count >= 3 && count <= 10 ? 'مرات' : 'مرة'}",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: count > 0 ? TColors.primary : TColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildListeningDetailItem(
    int count,
    TextTheme textTheme,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Iconsax.headphone,
              size: 12,
              color: TColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "الاستماع",
                style: textTheme.titleSmall?.copyWith(
                  color: TColors.textSecondary,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "$count ${count >= 3 && count <= 10 ? 'مرات' : 'مرة'}",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: count > 0 ? TColors.secondary : TColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class ArchiveByJuzSection extends StatelessWidget {
  final List<ArchiveDayModel> archiveDays;
  final TextTheme textTheme;
  final AppLocalizations localizations;

  final Widget Function(ArchiveDayModel day) buildDayCard;

  const ArchiveByJuzSection({
    super.key,
    required this.archiveDays,
    required this.textTheme,
    required this.localizations,
    required this.buildDayCard,
  });

  @override
  Widget build(BuildContext context) {
    final Map<int, List<ArchiveDayModel>> grouped = {};
    final List<ArchiveDayModel> ungrouped = [];

    for (final d in archiveDays) {
      final juz = d.memorizationJuz;
      if (juz == null) {
        ungrouped.add(d);
      } else {
        grouped.putIfAbsent(juz, () => []).add(d);
      }
    }

    final juzKeys = grouped.keys.toList()..sort();

    return Column(
      children: [
        for (final juz in juzKeys) ...[
          _buildJuzTile(context: context, juz: juz, days: grouped[juz]!),
          const SizedBox(height: 10),
        ],
        if (ungrouped.isNotEmpty) ...[
          _buildJuzTile(
            context: context,
            juz: 0,
            days: ungrouped,
            titleOverride: localizations.notClassifiedLabel,
          ),
        ],
      ],
    );
  }

  Widget _buildJuzTile({
    required BuildContext context,
    required int juz,
    required List<ArchiveDayModel> days,
    String? titleOverride,
  }) {
    days.sort((a, b) {
      final ao = a.order ?? 0;
      final bo = b.order ?? 0;
      if (ao != bo) return ao.compareTo(bo);
      return a.id.compareTo(b.id);
    });

    final completedCount = days.where((d) => d.isCompleted).length;

    return Container(
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TColors.borderSecondary),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: TColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  juz == 0 ? '؟' : '$juz',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: TColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                titleOverride ?? 'الجزء $juz',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _miniProgressChip(completedCount, days.length),
          ],
        ),
        children: [
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            itemBuilder: (context, index) => buildDayCard(days[index]),
          ),
        ],
      ),
    );
  }

  Widget _miniProgressChip(int completed, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: TColors.secondary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: TColors.secondary.withOpacity(0.18)),
      ),
      child: Text(
        '$completed/$total',
        style: textTheme.bodySmall?.copyWith(
          color: TColors.secondary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
