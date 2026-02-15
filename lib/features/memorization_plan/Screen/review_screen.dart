import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/models/archive_day_model.dart';
import '../repository/review_repository.dart';
import 'package:quran/quran.dart' as quran;

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(reviewStateProvider);
    final primaryGreen = const Color(0xFF0E4D21);

    return Scaffold(
      body: async.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (state) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(reviewStateProvider),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const _HeaderMotivationalCard(),
                const SizedBox(height: 24),
                if (state.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("لا توجد مراجعات حالياً"),
                    ),
                  )
                else ...[
                  if (state.pendingReviews.isNotEmpty) ...[
                    _SectionHeader(
                      title: "المراجعة الحالية",
                      color: primaryGreen,
                    ),
                    ...state.pendingReviews.map(
                      (day) => _RevisionCard(
                        day: day,
                        isCompleted: false,
                        accentColor: primaryGreen,
                        actionLabel: l10n.reviewDoneButton,
                        onAction: () async {
                          await ref
                              .read(reviewStateRepositoryProvider)
                              .markReviewed(day.id);
                          ref.invalidate(reviewStateProvider);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (state.completedReviews.isNotEmpty) ...[
                    _SectionHeader(
                      title: "المراجعات المكتملة",
                      color: primaryGreen.withOpacity(0.7),
                    ),
                    ...state.completedReviews.map(
                      (day) => _RevisionCard(
                        day: day,
                        isCompleted: true,
                        accentColor: Colors.grey,
                        actionLabel: "تمت المراجعة",
                        onAction: null,
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderMotivationalCard extends StatelessWidget {
  const _HeaderMotivationalCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/welcome_banner_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.2),
            ],
            begin: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            "لا تنسَ أن المراجعة تُثبت الحفظ، فاجعل وردك اليومي متوازنًا بين التقدم والمراجعة.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  final ArchiveDayModel day;
  final bool isCompleted;
  final Color accentColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _RevisionCard({
    required this.day,
    required this.isCompleted,
    required this.accentColor,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildInfoField(
                "من سورة:",
                day.reviewSurahStartName ?? day.surahStartName ?? "---",
                flex: 2,
              ),
              const SizedBox(width: 8),
              _buildInfoField(
                "من آية:",
                "${day.reviewVerseStartNumber ?? day.verseStartNumber ?? 1}",
                flex: 1,
              ),
              const SizedBox(width: 8),
              _buildInfoField(
                "إلى آية:",
                "${day.reviewVerseEndNumber ?? day.verseEndNumber ?? 1}",
                flex: 1,
              ),

              if (isCompleted) ...[
                const SizedBox(width: 12),
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
              ],
            ],
          ),
          if (!isCompleted && day.reviewSurahStartName != null)
            _QuranVersesSheet(
              surahName: day.reviewSurahStartName!,
              startVerse: day.reviewVerseStartNumber ?? 1,
              endVerse: day.reviewVerseEndNumber ?? 1,
            ),
          if (onAction != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: 120,
              height: 38,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuranVersesSheet extends StatelessWidget {
  final String surahName;
  final int startVerse;
  final int endVerse;

  const _QuranVersesSheet({
    required this.surahName,
    required this.startVerse,
    required this.endVerse,
  });

  @override
  Widget build(BuildContext context) {
    final surahId = _getSurahIdByName(surahName);
    if (surahId == -1) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8D7A5), width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.book_1,
            color: const Color(0xFF0E4D21).withOpacity(0.3),
            size: 20,
          ),
          const SizedBox(height: 8),

          Directionality(
            textDirection: TextDirection.rtl,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  for (int i = startVerse; i <= endVerse; i++) ...[
                    TextSpan(
                      text: quran.getVerse(surahId, i),
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 20,
                        height: 1.8,
                        color: Color(0xFF2D2D2D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: " ﴿$i﴾ ",
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: Color(0xFF0E4D21),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getSurahIdByName(String name) {
    for (int i = 1; i <= 114; i++) {
      if (quran.getSurahNameArabic(i).trim() == name.trim()) return i;
    }
    return -1;
  }
}
