import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/models/tafsir_model.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'repository/tafsir_repository.dart';
import 'tafsir_detail_screen.dart';

final tafsirSearchControllerProvider =
    StateNotifierProvider<TafsirSearchController, AsyncValue<List<TafsirModel>>>((ref) {
  final repo = ref.watch(tafsirRepositoryProvider);
  return TafsirSearchController(repo);
});

class TafsirSearchController extends StateNotifier<AsyncValue<List<TafsirModel>>> {
  final TafsirRepository _repository;
  TafsirSearchController(this._repository) : super(const AsyncValue.data([]));

  Future<void> search({int? surahId, int? verseId, String? word}) async {
    state = const AsyncValue.loading();
    try {
      final results = await _repository.search(
        surahId: surahId,
        verseId: verseId,
        word: word,
        pageSize: 300,
      );
      if (mounted) state = AsyncValue.data(results);
    } catch (e, stack) {
      if (mounted) state = AsyncValue.error(e, stack);
    }
  }
}

class TafsirSearchScreen extends ConsumerStatefulWidget {
  const TafsirSearchScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<TafsirSearchScreen> createState() => _TafsirSearchScreenState();
}

class _TafsirSearchScreenState extends ConsumerState<TafsirSearchScreen> {
  int? _selectedSurahId;
  String? _selectedSurahName;
  List<VerseNumberModel> _verseNumbers = [];
  // ignore: unused_field
  bool _isLoadingVerses = false;
  int? _localFilterVerseNumber;
  final TextEditingController _searchWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeFatiha());
  }

  void _initializeFatiha() {
    setState(() {
      _selectedSurahId = 1;
      _selectedSurahName = "الفاتحة";
    });
    ref.read(tafsirSearchControllerProvider.notifier).search(surahId: 1);
    _loadVerseNumbers(1);
  }

  Future<void> _loadVerseNumbers(int surahId) async {
    setState(() {
      _isLoadingVerses = true;
      _verseNumbers = [];
      _localFilterVerseNumber = null;
    });
    try {
      final numbers = await ref.read(tafsirRepositoryProvider).getVerseNumbers(surahId);
      if (mounted) {
        setState(() {
          _verseNumbers = numbers;
          _isLoadingVerses = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingVerses = false);
    }
  }

  void _resetFilters() {
    _searchWordController.clear();
    _initializeFatiha();
  }

 @override
 Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surahsAsync = ref.watch(surahsListProvider);
    final searchResultsAsync = ref.watch(tafsirSearchControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FB),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            
            !isLandscape ? SliverAppBar(
              title: Text(l10n.tafsirAndTadabburTab, 
                style: const TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              floating: true,
              pinned: true,
              elevation: innerBoxIsScrolled ? 2 : 0,
              actions: [
                if (_selectedSurahId != 1 || _localFilterVerseNumber != null)
                  IconButton(onPressed: _resetFilters, icon: const Icon(Iconsax.refresh_circle))
              ],
            ) : const SliverToBoxAdapter(),
            SliverToBoxAdapter(
              child: _buildFilterSection(l10n, surahsAsync, isDark),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () async => _loadVerseNumbers(_selectedSurahId ?? 1),
            child: _buildResultsList(searchResultsAsync, l10n, isDark),
          ),
        ),
      ),
    );
  }

 Widget _buildFilterSection(AppLocalizations l10n, AsyncValue<List<SurahModel>> surahsAsync, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: surahsAsync.when(
                  data: (surahs) => DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: _selectedSurahId,
                    decoration: _getInputDecoration(l10n.searchBySurahNameHint, Iconsax.book_1).copyWith(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    ),
                    items: surahs.map((s) => DropdownMenuItem(
                      value: s.id, 
                      child: Text(s.name, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        final surah = surahs.firstWhere((s) => s.id == val);
                        setState(() {
                          _selectedSurahId = val;
                          _selectedSurahName = surah.name;
                        });
                        _loadVerseNumbers(val);
                        ref.read(tafsirSearchControllerProvider.notifier).search(surahId: val);
                      }
                    },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              
              const SizedBox(width: 10),

              Expanded(
                child: DropdownButtonFormField<int>(
                  isExpanded: true,
                  value: _localFilterVerseNumber,
                  hint: Text(l10n.selectAyah, style: const TextStyle(fontSize: 13)),
                  decoration: _getInputDecoration(l10n.selectAyah, Iconsax.filter).copyWith(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                  items: _verseNumbers.map((v) => DropdownMenuItem(
                    value: v.numberInSurah, 
                    child: Text("${l10n.ayahNumber} ${v.numberInSurah}", style: const TextStyle(fontSize: 13))
                  )).toList(),
                  onChanged: (val) => setState(() => _localFilterVerseNumber = val),
                ),
              ),
            ],
          ),
          
          if (_localFilterVerseNumber != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: () => setState(() => _localFilterVerseNumber = null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.close, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text("إلغاء فلتر الآية", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
 
 InputDecoration _getInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      filled: true,
      fillColor: TColors.primary.withOpacity(0.05),
    );
  }

 Widget _buildResultsList(AsyncValue<List<TafsirModel>> resultsAsync, AppLocalizations l10n, bool isDark) {
    return resultsAsync.when(
      data: (results) {
        final displayList = _localFilterVerseNumber != null
            ? results.where((item) => item.verseNumber == _localFilterVerseNumber).toList()
            : results;

        if (displayList.isEmpty) return _buildEmptyState(l10n);

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            return _buildVerseCard(displayList[index], l10n, isDark);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l10n.errorLoadingData)),
    );
  }

 Widget _buildVerseCard(TafsirModel tafsir, AppLocalizations l10n, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _navigateToDetail(tafsir),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: TColors.primary.withOpacity(0.1),
                      radius: 18,
                      child: Text(tafsir.verseNumber.toString(), 
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: TColors.primary)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tafsir.surahName.isNotEmpty ? tafsir.surahName : (_selectedSurahName ?? ""),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const Icon(Iconsax.arrow_left_1, size: 18, color: Colors.grey),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                color: TColors.primary.withOpacity(0.03),
                child: Text(
                  tafsir.verseText ?? "...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    height: 1.6,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l10n.viewTafsirButton,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: TColors.secondary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(TafsirModel tafsir) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TafsirDetailScreen(
          tafsirModel: tafsir,
          fallbackSurahId: _selectedSurahId,
          fallbackSurahName: _selectedSurahName,
        ),
      ),
    );
  }

 Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.search_status, size: 80, color: Colors.grey.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(l10n.noAyahFound, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}