import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import 'surah_detail_screen.dart';

class QuranIndexScreen extends StatefulWidget {
  const QuranIndexScreen({Key? key}) : super(key: key);

  @override
  State<QuranIndexScreen> createState() => _QuranIndexScreenState();
}

class _QuranIndexScreenState extends State<QuranIndexScreen> {
  final TextEditingController searchController = TextEditingController();

  List<int> filteredSurahIds = List.generate(114, (i) => i + 1);

  LastRead? lastRead;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final surah = prefs.getInt(_PrefsKeys.lastSurah);
    final ayah = prefs.getInt(_PrefsKeys.lastAyah);
    final ts = prefs.getInt(_PrefsKeys.lastTimestamp);

    if (surah != null && ayah != null) {
      setState(() {
        lastRead = LastRead(
          surahNumber: surah,
          ayahNumber: ayah,
          timestampMs: ts,
        );
      });
    }
  }

  void _filterSurahs(String query) {
    final q = query.trim();

    setState(() {
      if (q.isEmpty) {
        filteredSurahIds = List.generate(114, (i) => i + 1);
        return;
      }

      final asNumber = int.tryParse(q);
      if (asNumber != null && asNumber >= 1 && asNumber <= 114) {
        filteredSurahIds = [asNumber];
        return;
      }

      filteredSurahIds = List.generate(
        114,
        (i) => i + 1,
      ).where((id) => quran.getSurahNameArabic(id).contains(q)).toList();
    });
  }

  void _openSurah(int surahNumber, {int? initialAyah}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahMushafPageScreen(
          surahNumber: surahNumber,
          surahName: quran.getSurahNameArabic(surahNumber),
          initialAyah: initialAyah,
        ),
      ),
    );

    _loadLastRead();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: !isLandscape ? AppBar(title: const Text('المصحف الشريف'), centerTitle: true) : null,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: _filterSurahs,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'ابحث باسم السورة أو رقمها...',
                        prefixIcon: const Icon(Iconsax.search_normal),
                        suffixIcon: searchController.text.trim().isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Iconsax.close_circle),
                                onPressed: () {
                                  searchController.clear();
                                  _filterSurahs('');
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (lastRead != null)
                      _ContinueReadingCard(
                        lastRead: lastRead!,
                        onContinue: () => _openSurah(
                          lastRead!.surahNumber,
                          initialAyah: lastRead!.ayahNumber,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: filteredSurahIds.isEmpty
                  ? SliverToBoxAdapter(
                      child: _EmptyState(
                        query: searchController.text.trim(),
                        onClear: () {
                          searchController.clear();
                          _filterSurahs('');
                        },
                      ),
                    )
                  : SliverList.separated(
                      itemCount: filteredSurahIds.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final surahNumber = filteredSurahIds[index];
                        final surahName = quran.getSurahNameArabic(surahNumber);
                        final isLast = lastRead?.surahNumber == surahNumber;

                        final place =
                            quran.getPlaceOfRevelation(surahNumber) == 'Makkah'
                            ? 'مكية'
                            : 'مدنية';
                        final verses = quran.getVerseCount(surahNumber);

                        return _SurahTileCard(
                          surahNumber: surahNumber,
                          surahName: surahName,
                          subtitle: '$place • $verses آية',
                          isLastRead: isLast,
                          onTap: () => _openSurah(surahNumber),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ContinueReadingCard extends StatelessWidget {
  final LastRead lastRead;
  final VoidCallback onContinue;

  const _ContinueReadingCard({
    required this.lastRead,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final surahName = quran.getSurahNameArabic(lastRead.surahNumber);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: TColors.primary.withOpacity(0.10),
        border: Border.all(color: TColors.primary.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Iconsax.book_1, color: TColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تابع القراءة',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: TColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'سورة $surahName • آية ${lastRead.ayahNumber}',
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: onContinue,
            icon: const Icon(Iconsax.play, size: 18),
            label: const Text('متابعة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahTileCard extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  final String subtitle;
  final bool isLastRead;
  final VoidCallback onTap;

  const _SurahTileCard({
    required this.surahNumber,
    required this.surahName,
    required this.subtitle,
    required this.isLastRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isLastRead
                ? TColors.primary.withOpacity(0.35)
                : (isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.grey.shade200),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: TColors.primary.withOpacity(0.10),
              ),
              child: Center(
                child: Text(
                  '$surahNumber',
                  style: const TextStyle(
                    color: TColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'سورة $surahName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (isLastRead) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: TColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'آخر قراءة',
                            style: TextStyle(
                              color: TColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            const Icon(Iconsax.arrow_left_2, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final VoidCallback onClear;

  const _EmptyState({required this.query, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(Iconsax.search_status, size: 44, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'لا توجد نتائج لـ "$query"',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'جرّب كتابة اسم السورة أو رقمها.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onClear,
              icon: const Icon(Iconsax.close_circle),
              label: const Text('مسح البحث'),
            ),
          ],
        ),
      ),
    );
  }
}


class _PrefsKeys {
  static const String lastSurah = 'q_last_surah';
  static const String lastAyah = 'q_last_ayah';
  static const String lastTimestamp = 'q_last_ts';
}

class LastRead {
  final int surahNumber;
  final int ayahNumber;
  final int? timestampMs;

  LastRead({
    required this.surahNumber,
    required this.ayahNumber,
    required this.timestampMs,
  });
}
