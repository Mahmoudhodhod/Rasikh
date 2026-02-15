import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/models/tafsir_model.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'repository/tafsir_repository.dart';

final tafsirFontSizeProvider = StateProvider<double>((ref) => 18.0);

final tafsirContentProvider = FutureProvider.family<String?, int>((
  ref,
  tafsirId,
) async {
  final repo = ref.watch(tafsirRepositoryProvider);
  return repo.getTafsirById(tafsirId);
});

class TafsirDetailScreen extends ConsumerWidget {
  final TafsirModel tafsirModel;
  final int? fallbackSurahId;
  final String? fallbackSurahName;

  const TafsirDetailScreen({
    Key? key,
    required this.tafsirModel,
    this.fallbackSurahId,
    this.fallbackSurahName,
  }) : super(key: key);

  String _getAppBarTitle(WidgetRef ref, AppLocalizations l10n) {
    final surahsAsync = ref.watch(surahsListProvider);
    final int surahId = (tafsirModel.surahId != 0
        ? tafsirModel.surahId
        : (fallbackSurahId ?? 0));

    return surahsAsync.maybeWhen(
      data: (surahs) {
        final surah = surahs.where((s) => s.id == surahId).firstOrNull;
        final name = (surah?.name ?? fallbackSurahName ?? '').trim();
        return name.isNotEmpty
            ? l10n.surahNameLabel(name)
            : "${l10n.surahNumber} $surahId";
      },
      orElse: () => fallbackSurahName != null
          ? l10n.surahNameLabel(fallbackSurahName!)
          : "${l10n.surahNumber} $surahId",
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontSize = ref.watch(tafsirFontSizeProvider);
    final tafsirAsync = ref.watch(tafsirContentProvider(tafsirModel.id));
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(ref, l10n)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: () => _showFontSizeDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareContent(context, l10n),
          ),
        ],
      ),
      body: SafeArea(
        child: SelectionArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildVerseCard(isDark, l10n),

                    const SizedBox(height: 32),

                    if (!isLandscape)
                      _buildSectionHeader(l10n.tafsirAndTadabburTab),

                    const SizedBox(height: 16),

                    _buildTafsirContent(
                      tafsirAsync,
                      fontSize,
                      isDark,
                      l10n,
                      ref,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerseCard(bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(isDark ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.verseNumberLabel(tafsirModel.verseNumber),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            tafsirModel.verseText ?? "...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 28,
              height: 1.8,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: TColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: TColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTafsirContent(
    AsyncValue<String?> asyncValue,
    double fontSize,
    bool isDark,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return asyncValue.when(
      data: (text) {
        final content = (text == null || text.isEmpty)
            ? l10n.noTafsirAvailableForNow
            : text;
        return AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: fontSize,
            height: 1.8,
            color: isDark ? Colors.grey[300] : Colors.black87,
            fontFamily: 'Roboto',
          ),
          child: Text(content, textAlign: TextAlign.justify),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => _ErrorRetryWidget(
        message: l10n.errorLoadingData,
        onRetry: () => ref.invalidate(tafsirContentProvider(tafsirModel.id)),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            double currentSize = ref.watch(tafsirFontSizeProvider);
            return Container(
              padding: const EdgeInsets.all(24),
              height: 180,
              child: Column(
                children: [
                  const Text(
                    "حجم الخط",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Slider(
                    value: currentSize,
                    min: 14,
                    max: 32,
                    divisions: 9,
                    activeColor: TColors.primary,
                  onChanged: (val) => ref.read(tafsirFontSizeProvider.notifier).state = val,
                  ),
                  Text("${currentSize.toInt()} px"),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _shareContent(BuildContext context, AppLocalizations l10n) {
    final String shareText =
        "${tafsirModel.verseText}\n\n[${l10n.verseNumberLabel(tafsirModel.verseNumber)}]\n\nمن تطبيق القرآن الكريم";
    Share.share(shareText);
  }
}

class _ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetryWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
        const SizedBox(height: 12),
        Text(message),
        TextButton(onPressed: onRetry, child: const Text("إعادة المحاولة")),
      ],
    );
  }
}
