import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/tafsir_model.dart';
import '../../auth/repository/auth_repository.dart';

final tafsirRepositoryProvider = Provider<TafsirRepository>((ref) {
  return TafsirRepository(ref.watch(apiServiceProvider));
});

final surahsListProvider = FutureProvider<List<SurahModel>>((ref) async {
  final repo = ref.watch(tafsirRepositoryProvider);
  return repo.getSurahs();
});

class TafsirRepository {
  final ApiService _apiService;
  TafsirRepository(this._apiService);
  Future<List<SurahModel>> getSurahs() async {
    final data = await _apiService.getAllSurahs();
    return data.map((e) => SurahModel.fromJson(e)).toList();
  }
 
  Future<List<TafsirModel>> search({
    int? surahId,
    int? verseId,
    String? word,
    int page = 1,
    int pageSize = 300,
  }) async {
    final Map<String, dynamic> response = await _apiService.getTafsirList(
      page: page,
      pageSize: pageSize,
      surahId: surahId,
      verseId: verseId,
      word: word,
    );

    List<dynamic> listData = [];
    if (response.containsKey('data') && response['data'] is List) {
      listData = response['data'];
    }
    List<TafsirModel> allResults = listData
        .map((e) => TafsirModel.fromJson(e))
        .toList();
    final Map<int, TafsirModel> uniqueVerses = {};

    for (var item in allResults) {
      if (!uniqueVerses.containsKey(item.verseNumber)) {
        uniqueVerses[item.verseNumber] = item;
      } else {
        final existingItem = uniqueVerses[item.verseNumber]!;
        if ((existingItem.verseText?.length ?? 0) <
            (item.verseText?.length ?? 0)) {
          uniqueVerses[item.verseNumber] = item;
        }
      }
    }
    return uniqueVerses.values.toList();
  }

  Future<String?> getTafsirById(int id) async {
    try {
      final data = await _apiService.getTafsirDetails(id);
      return data['text'] ?? data['description'];
    } catch (e) {
      return null;
    }
  }
  Future<List<VerseNumberModel>> getVerseNumbers(int surahId) async {
    final List<dynamic> rawData = await _apiService.getVerseNumbers(surahId);
    final List<VerseNumberModel> allVerses = rawData
        .map((e) => VerseNumberModel.fromJson(e))
        .toList();
    final Set<int> seenNumbers = {};
    final List<VerseNumberModel> uniqueVerses = [];
    for (var verse in allVerses) {
      if (!seenNumbers.contains(verse.numberInSurah) &&
          verse.numberInSurah != 0) {
        seenNumbers.add(verse.numberInSurah);
        uniqueVerses.add(verse);
      }
    }
    uniqueVerses.sort((a, b) => a.numberInSurah.compareTo(b.numberInSurah));
    return uniqueVerses;
  }
}
