import 'package:json_annotation/json_annotation.dart';
import 'package:quran/quran.dart' as quran;

part 'archive_day_model.g.dart';

@JsonSerializable()
class ArchiveDayModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'dayNumber')
  final String dayNumber;

  @JsonKey(name: 'surahStartName')
  final String? surahStartName;

  @JsonKey(name: 'surahEndName')
  final String? surahEndName;

  @JsonKey(name: 'verseStartNumber')
  final int? verseStartNumber;

  @JsonKey(name: 'verseEndNumber')
  final int? verseEndNumber;

  @JsonKey(name: 'reviewSurahStartName')
  final String? reviewSurahStartName;

  @JsonKey(name: 'reviewSurahEndtName')
  final String? reviewSurahEndName;

  @JsonKey(name: 'reviewVerseStartNumber')
  final int? reviewVerseStartNumber;

  @JsonKey(name: 'reviewVerseEndNumber')
  final int? reviewVerseEndNumber;

  @JsonKey(name: 'linkSurahStartName')
  final String? linkSurahStartName;

  @JsonKey(name: 'linkSurahEndtName')
  final String? linkSurahEndName;

  @JsonKey(name: 'linkVerseStartNumber')
  final int? linkVerseStartNumber;

  @JsonKey(name: 'linkVerseEndNumber')
  final int? linkVerseEndNumber;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'repeatNumber')
  final int repetitionCount;

  @JsonKey(name: 'listenNumber')
  final int listeningCount;

  @JsonKey(name: 'isWrited')
  final bool writingCompleted;

  @JsonKey(name: 'completedAt')
  final String? completedAt;

  @JsonKey(name: 'isCompleted')
  final bool isCompleted;

  @JsonKey(name: 'savedAyatCount')
  final int? savedAyatCount;

  @JsonKey(name: 'reviewedAyatCount')
  final int? reviewedAyatCount;

  @JsonKey(name: 'linkedAyatCount')
  final int? linkedAyatCount;

  ArchiveDayModel({
    required this.id,
    required this.dayNumber,
    this.surahStartName,
    this.surahEndName,
    this.verseStartNumber,
    this.verseEndNumber,
    this.reviewSurahStartName,
    this.reviewSurahEndName,
    this.reviewVerseStartNumber,
    this.reviewVerseEndNumber,
    this.linkSurahStartName,
    this.linkSurahEndName,
    this.linkVerseStartNumber,
    this.linkVerseEndNumber,
    this.order,
    required this.repetitionCount,
    required this.listeningCount,
    required this.writingCompleted,
    this.completedAt,
    required this.isCompleted,
    this.savedAyatCount,
    this.reviewedAyatCount,
    this.linkedAyatCount,
  });

  factory ArchiveDayModel.fromJson(Map<String, dynamic> json) =>
      _$ArchiveDayModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArchiveDayModelToJson(this);

  String get dayTitle => "اليوم $dayNumber";

  String get memorizationDetails {
    if (surahStartName == null) return "---";
    final start = verseStartNumber ?? '?';
    final end = verseEndNumber ?? '?';
    final endSurah = (surahEndName != null && surahEndName!.trim().isNotEmpty)
        ? " → سورة $surahEndName"
        : "";
    return "سورة $surahStartName: آية $start - $end $endSurah";
  }

  String get reviewDetails {
    if (reviewSurahStartName == null) return "---";
    final start = reviewVerseStartNumber ?? '?';
    final end = reviewVerseEndNumber ?? '?';
    final endSurah =
        (reviewSurahEndName != null && reviewSurahEndName!.trim().isNotEmpty)
        ? " → سورة $reviewSurahEndName"
        : "";
    return "سورة $reviewSurahStartName: آية $start - $end $endSurah";
  }

  String get linkDetails {
    if (linkSurahStartName == null) return "---";
    final start = linkVerseStartNumber ?? '?';
    final end = linkVerseEndNumber ?? '?';
    final endSurah =
        (linkSurahEndName != null && linkSurahEndName!.trim().isNotEmpty)
        ? " → سورة $linkSurahEndName"
        : "";
    return "سورة $linkSurahStartName: آية $start - $end $endSurah";
  }

  int? get memorizationJuz {
    final sName = surahStartName;
    final a = verseStartNumber;
    if (sName == null || a == null) return null;

    final surahNo = _SurahIndex.byArabicName(sName);
    if (surahNo == null) return null;

    return quran.getJuzNumber(surahNo, a);
  }

  bool get hasReviewRange {
    return reviewSurahStartName != null &&
        reviewSurahStartName!.trim().isNotEmpty &&
        reviewVerseStartNumber != null &&
        reviewVerseEndNumber != null;
  }

  bool get needsReview {
    return hasReviewRange;
  }

  bool get isReviewCompleted {
    return (reviewedAyatCount ?? 0) > 0;
  }

  bool get hasLinkRange {
    return linkSurahStartName != null &&
        linkSurahStartName!.trim().isNotEmpty &&
        linkVerseStartNumber != null &&
        linkVerseEndNumber != null;
  }

  bool get needsLinking {
    return hasLinkRange;
  }

  bool get isLinkingCompleted {
    return (linkedAyatCount ?? 0) > 0;
  }
}

class _SurahIndex {
  static final Map<String, int> _map = {
    for (int i = 1; i <= 114; i++) quran.getSurahNameArabic(i).trim(): i,
  };

  static int? byArabicName(String name) {
    final key = name.trim();
    return _map[key];
  }
}
