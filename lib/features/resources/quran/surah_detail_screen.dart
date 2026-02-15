import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/mushaf_styles.dart';

class SurahMushafPageScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final int? initialAyah;

  const SurahMushafPageScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    this.initialAyah,
  });

  @override
  State<SurahMushafPageScreen> createState() => _SurahMushafPageScreenState();
}

class _SurahMushafPageScreenState extends State<SurahMushafPageScreen> {
  final GlobalKey _paperKey = GlobalKey();
  final Map<int, ScrollController> _pageScrollControllers = {};

  double fontSize = 26;
  int? lastAyah;
  final Set<int> selectedAyat = {};
  late final List<_SurahPage> _pages;
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = _buildSurahPages(widget.surahNumber);
    _pageController = PageController(initialPage: 0);

    _loadPrefs().then((_) {
      final targetAyah = lastAyah ?? 1;
      final targetIndex = _pageIndexForAyah(targetAyah);
      if (mounted) {
        setState(() => _currentPageIndex = targetIndex);
        _pageController.jumpToPage(targetIndex);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _pageScrollControllers.values) {
      c.dispose();
    }
    _pageScrollControllers.clear();
    _pageController.dispose();
    super.dispose();
  }

  List<_SurahPage> _buildSurahPages(int surahNumber) {
    final verseCount = quran.getVerseCount(surahNumber);
    final Map<int, List<int>> byPage = {};
    for (int ayah = 1; ayah <= verseCount; ayah++) {
      final p = quran.getPageNumber(surahNumber, ayah);
      byPage.putIfAbsent(p, () => []).add(ayah);
    }
    final sortedPages = byPage.keys.toList()..sort();
    return sortedPages.map((p) {
      final ayat = byPage[p]!;
      return _SurahPage(
        pageNumber: p,
        startAyah: ayat.first,
        endAyah: ayat.last,
      );
    }).toList();
  }

  int _pageIndexForAyah(int ayah) {
    for (int i = 0; i < _pages.length; i++) {
      final pg = _pages[i];
      if (ayah >= pg.startAyah && ayah <= pg.endAyah) return i;
    }
    return 0;
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble(_K.fontSize) ?? 26;
    });

    final savedSurah = prefs.getInt(_K.lastSurah);
    final savedAyah = prefs.getInt(_K.lastAyah);

    final target =
        widget.initialAyah ??
        ((savedSurah == widget.surahNumber) ? savedAyah : null);

    if (target != null) {
      setState(() => lastAyah = target);
    }
  }

  Future<void> _saveLastRead(int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_K.lastSurah, widget.surahNumber);
    await prefs.setInt(_K.lastAyah, ayah);
    if (mounted) setState(() => lastAyah = ayah);
  }

  Future<void> _saveFont() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_K.fontSize, fontSize);
  }

  void _onAyahNumberTap(int ayah) async {
    if (selectedAyat.isNotEmpty) {
      setState(() {
        if (selectedAyat.contains(ayah)) {
          selectedAyat.remove(ayah);
        } else {
          selectedAyat.add(ayah);
        }
      });
      await _saveLastRead(ayah);
      return;
    }

    await _saveLastRead(ayah);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _AyahActionsSheet(
            surahName: widget.surahName,
            ayah: ayah,
            verseText: quran.getVerse(widget.surahNumber, ayah),
            onCopy: () => _copyAyah(ayah),
            onShareText: () => _shareAyahText(ayah),
            onStartSelect: () {
              Navigator.pop(context);
              setState(() => selectedAyat.add(ayah));
            },
          ),
        ),
      ),
    );
  }

  Future<void> _copyAyah(int ayah) async {
    final text =
        '﴿ ${quran.getVerse(widget.surahNumber, ayah)} ﴾\n(سورة ${widget.surahName} - آية $ayah)';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الآية', style: TextStyle(fontFamily: 'Tajawal')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _shareAyahText(int ayah) async {
    final text =
        '﴿ ${quran.getVerse(widget.surahNumber, ayah)} ﴾\n(سورة ${widget.surahName} - آية $ayah)';
    await Share.share(text);
  }

  Future<void> _shareSelectedAsText() async {
    await Share.share(_selectedText());
  }

  Future<void> _shareSelectedAsImage() async {
    try {
      final boundary =
          _paperKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      final xFile = XFile.fromData(
        bytes,
        mimeType: 'image/png',
        name: 'ayah_rasikh.png',
      );

      final box = context.findRenderObject() as RenderBox?;
      final shareOrigin = box != null
          ? (box.localToGlobal(Offset.zero) & box.size)
          : const Rect.fromLTWH(0, 0, 100, 100);

      await Share.shareXFiles(
        [xFile],
        text: 'سورة ${widget.surahName}',
        sharePositionOrigin: shareOrigin,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء مشاركة الصورة')),
        );
      }
    }
  }

  String _selectedText() {
    final list = selectedAyat.toList()..sort();
    final verses = list
        .map((a) => '﴿ ${quran.getVerse(widget.surahNumber, a)} ﴾ (آية $a)')
        .join('\n\n');
    return 'سورة ${widget.surahName}\n\n$verses';
  }

  List<InlineSpan> _buildMushafSpansForRange({
    required int startAyah,
    required int endAyah,
  }) {
    final spans = <InlineSpan>[];

    for (int ayah = startAyah; ayah <= endAyah; ayah++) {
      final verse = quran.getVerse(widget.surahNumber, ayah);
      final isSelected = selectedAyat.contains(ayah);
      final isLast = lastAyah == ayah;

      spans.add(
        TextSpan(
          text: '$verse ',
          style: TextStyle(
            backgroundColor: isSelected
                ? TColors.primary.withOpacity(0.25)
                : (isLast ? TColors.primary.withOpacity(0.1) : null),
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _onAyahNumberTap(ayah),
        ),
      );

      spans.add(
        TextSpan(
          text: '﴿$ayah﴾ ',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: fontSize * 0.8,
            color: isSelected || isLast
                ? TColors.primary
                : TColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _onAyahNumberTap(ayah),
        ),
      );
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final verseCount = quran.getVerseCount(widget.surahNumber);

    return Scaffold(
      backgroundColor: TColors.light,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'سورة ${widget.surahName}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _buildAppBarAction(Icons.remove_circle_outline, () async {
            setState(() => fontSize = (fontSize - 1).clamp(16, 40));
            await _saveFont();
          }),
          _buildAppBarAction(Icons.add_circle_outline, () async {
            setState(() => fontSize = (fontSize + 1).clamp(16, 40));
            await _saveFont();
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!isLandscape)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? size.width * 0.15 : 16,
                  vertical: 12,
                ),
                child: _TopInfoBar(
                  verseCount: verseCount,
                  place:
                      quran.getPlaceOfRevelation(widget.surahNumber) == 'Makkah'
                      ? 'مكية'
                      : 'مدنية',
                  lastAyah: lastAyah,
                  onClearSelection: selectedAyat.isEmpty
                      ? null
                      : () => setState(() => selectedAyat.clear()),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                reverse: true,
                onPageChanged: (i) => setState(() => _currentPageIndex = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final pg = _pages[index];
                  final isCurrent = index == _currentPageIndex;
                  final scrollCtrl = _pageScrollControllers.putIfAbsent(
                    pg.pageNumber,
                    () => ScrollController(),
                  );

                  final bool needsBasmala =
                      pg.startAyah == 1 &&
                      widget.surahNumber != 9 &&
                      widget.surahNumber != 1;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 700 : double.infinity,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        child: RepaintBoundary(
                          key: isCurrent ? _paperKey : null,
                          child: _MushafPaper(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: _MushafScrollArea(
                                      controller: scrollCtrl,
                                      child: Column(
                                        children: [
                                          if (needsBasmala) ...[
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                  ),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '﷽',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Amiri',
                                                    fontSize: 38,
                                                    height: 1.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF1F1B16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                          RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Amiri',
                                                fontSize: fontSize,
                                                height: 2.2,
                                                color: const Color(0xFF1F1B16),
                                                fontWeight: FontWeight.w500,
                                                wordSpacing: 1.2,
                                              ),
                                              children:
                                                  _buildMushafSpansForRange(
                                                    startAyah: pg.startAyah,
                                                    endAyah: pg.endAyah,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'صفحة ${pg.pageNumber}',
                                    style: const TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: TColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: selectedAyat.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? size.width * 0.2 : 0,
                ),
                child: _SelectionActionTray(
                  count: selectedAyat.length,
                  onCopy: () async {
                    await Clipboard.setData(
                      ClipboardData(text: _selectedText()),
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
                    }
                  },
                  onShareText: _shareSelectedAsText,
                  onShareImage: _shareSelectedAsImage,
                ),
              ),
            ),
    );
  }

  Widget _buildAppBarAction(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: TColors.primary, size: 28),
      onPressed: onPressed,
      tooltip: 'تغيير حجم الخط',
    );
  }
}

class _MushafPaper extends StatelessWidget {
  final Widget child;
  const _MushafPaper({required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      margin: !isTablet
          ? const EdgeInsets.symmetric(
              horizontal: 4,
            )
          : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17663A), Color(0xFF0F4A27), Color(0xFF0B3A1E)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE7CC8A).withOpacity(0.7),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFDFDF9),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet
                    ? 30
                    : 12,
                vertical: isTablet ? 25 : 12,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _MushafScrollArea extends StatefulWidget {
  final ScrollController controller;
  final Widget child;
  const _MushafScrollArea({required this.controller, required this.child});

  @override
  State<_MushafScrollArea> createState() => _MushafScrollAreaState();
}

class _MushafScrollAreaState extends State<_MushafScrollArea> {
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_recalc);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalc());
  }

  void _recalc() {
    if (!mounted || !widget.controller.hasClients) return;
    final max = widget.controller.position.maxScrollExtent;
    final px = widget.controller.position.pixels;
    final shouldShow = max > 10 && px < (max - 10);
    if (_showHint != shouldShow) setState(() => _showHint = shouldShow);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
          controller: widget.controller,
          child: SingleChildScrollView(
            controller: widget.controller,
            physics: const BouncingScrollPhysics(),
            child: widget.child,
          ),
        ),
        if (_showHint)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFDFDF9).withOpacity(0),
                      const Color(0xFFFDFDF9),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6E8A73),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TopInfoBar extends StatelessWidget {
  final int verseCount;
  final String place;
  final int? lastAyah;
  final VoidCallback? onClearSelection;

  const _TopInfoBar({
    required this.verseCount,
    required this.place,
    this.lastAyah,
    this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Flexible(flex: 2, child: _Pill(text: '$verseCount آية')),
          const SizedBox(width: 8),
          Flexible(flex: 2, child: _Pill(text: place)),
          if (lastAyah != null) ...[
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: _Pill(text: 'آخر قراءة: $lastAyah', isHighlight: true),
            ),
          ],
          if (onClearSelection != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
              onPressed: onClearSelection,
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final bool isHighlight;
  const _Pill({required this.text, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlight
            ? TColors.primary.withOpacity(0.12)
            : const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isHighlight ? TColors.primary : Colors.black87,
        ),
      ),
    );
  }
}

class _SelectionActionTray extends StatelessWidget {
  final int count;
  final VoidCallback onCopy, onShareText, onShareImage;

  const _SelectionActionTray({
    required this.count,
    required this.onCopy,
    required this.onShareText,
    required this.onShareImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: TColors.secondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$count آيات مختارة',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _trayBtn(Icons.copy, onCopy),
          _trayBtn(Icons.share, onShareText),
          _trayBtn(Icons.image, onShareImage),
        ],
      ),
    );
  }

  Widget _trayBtn(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onTap,
    );
  }
}

class _AyahActionsSheet extends StatelessWidget {
  final String surahName, verseText;
  final int ayah;
  final VoidCallback onCopy, onShareText, onStartSelect;

  const _AyahActionsSheet({
    required this.surahName,
    required this.verseText,
    required this.ayah,
    required this.onCopy,
    required this.onShareText,
    required this.onStartSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سورة $surahName (آية $ayah)',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(height: 30),
            Text(
              verseText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy),
                    label: const Text('نسخ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onStartSelect,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('تحديد متعدد'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShareText,
                    icon: const Icon(Icons.share),
                    label: const Text('مشاركة'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _K {
  static const lastSurah = 'q_last_surah';
  static const lastAyah = 'q_last_ayah';
  static const fontSize = 'q_font_size';
}

class _SurahPage {
  final int pageNumber;
  final int startAyah;
  final int endAyah;
  const _SurahPage({
    required this.pageNumber,
    required this.startAyah,
    required this.endAyah,
  });
}
