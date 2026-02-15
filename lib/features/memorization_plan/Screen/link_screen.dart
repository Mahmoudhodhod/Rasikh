import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran/quran.dart' as quran;
import '../repository/link_repository.dart';
import '../../../core/models/archive_day_model.dart';

class LinkScreen extends ConsumerWidget {
  const LinkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(linkingStateProvider);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: isLandscape
          ? null
          : AppBar(
              title: const Text(
                "ربط المحفوظ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
      body: async.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (state) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(linkingStateProvider),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildInfoBanner(),
                const SizedBox(height: 25),

                if (state.isEmpty)
                  const SizedBox(
                    height: 400,
                    child: Center(child: Text("لا توجد عمليات ربط حالياً")),
                  ),

                if (state.pendingLinks.isNotEmpty) ...[
                  const _SectionTitle(title: "الربط المطلوب"),
                  ...state.pendingLinks.map(
                    (day) => _LinkTimelineCard(
                      day: day,
                      isDone: false,
                      color: Color(0xFF0E4D21),
                      onTap: () async {
                        await ref
                            .read(linkingRepositoryProvider)
                            .markAsLinked(day.id);
                        ref.invalidate(linkingStateProvider);
                      },
                    ),
                  ),
                ],

                if (state.completedLinks.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  const _SectionTitle(title: "تم الربط بحمد الله"),
                  ...state.completedLinks.map(
                    (day) => _LinkTimelineCard(
                      day: day,
                      isDone: true,
                      color: Colors.grey,
                    ),
                  ),
                ],
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: const [
          Icon(Iconsax.link_1, color: Color(0xFF00796B)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "الربط يساعدك على وصل الآيات ببعضها لضمان عدم التوقف أثناء التسميع.",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF004D40),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTimelineCard extends StatelessWidget {
  final ArchiveDayModel day;
  final bool isDone;
  final Color color;
  final VoidCallback? onTap;

  const _LinkTimelineCard({
    required this.day,
    required this.isDone,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isDone ? Colors.green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone ? Colors.green : color,
                    width: 3,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              Expanded(
                child: VerticalDivider(
                  color: color.withOpacity(0.2),
                  thickness: 2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day.linkSurahStartName ??
                            day.surahStartName ??
                            "سورة غير محددة",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: Color(0xFF263238),
                        ),
                      ),
                      if (isDone)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
                  ),

                  if (!isDone && day.linkSurahStartName != null)
                    _LinkingVersesDisplay(
                      surahName: day.linkSurahStartName!,
                      startVerse: day.linkVerseStartNumber ?? 1,
                      endVerse: day.linkVerseEndNumber ?? 1,
                    ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _infoBadge("من آية", "${day.linkVerseStartNumber ?? 1}"),
                      const SizedBox(width: 8),
                      _infoBadge("إلى آية", "${day.linkVerseEndNumber ?? 10}"),
                    ],
                  ),

                  if (!isDone) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Iconsax.link, size: 18),
                        label: const Text("تأكيد الربط"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

  Widget _infoBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _LinkingVersesDisplay extends StatelessWidget {
  final String surahName;
  final int startVerse;
  final int endVerse;

  const _LinkingVersesDisplay({
    required this.surahName,
    required this.startVerse,
    required this.endVerse,
  });

  @override
  Widget build(BuildContext context) {
    final surahId = _getSurahId(surahName);
    if (surahId == -1) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFB2DFDB), width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -5,
            top: -5,
            child: Icon(
              Iconsax.link_1,
              size: 40,
              color: const Color(0xFF00796B).withOpacity(0.06),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    for (int i = startVerse; i <= endVerse; i++) ...[
                      TextSpan(
                        text: quran.getVerse(surahId, i),
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 19,
                          height: 1.8,
                          color: Color(0xFF263238),
                        ),
                      ),
                      TextSpan(
                        text: " ﴿$i﴾ ",
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 17,
                          color: Color(0xFF00796B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getSurahId(String name) {
    for (int i = 1; i <= 114; i++) {
      if (quran.getSurahNameArabic(i).trim() == name.trim()) return i;
    }
    return -1;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
      ),
    );
  }
}
