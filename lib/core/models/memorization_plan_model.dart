import 'package:json_annotation/json_annotation.dart';
part 'memorization_plan_model.g.dart';

@JsonSerializable()
class MemorizationPlanModel {
  @JsonKey(name: 'id')
  final int progressId;

  @JsonKey(name: 'reapetNumber')
  final int currentRepetition;

  @JsonKey(name: 'heardNumber')
  final int currentListening;

  @JsonKey(name: 'isWriting')
  final bool isWritingCompleted;

  @JsonKey(name: 'isCompleted')
  final bool isMemorizationCompleted;

  @JsonKey(name: 'isReview', defaultValue: false)
  final bool isReviewCompleted;

  @JsonKey(name: 'isLink', defaultValue: false)
  final bool isLinkCompleted;

  @JsonKey(name: 'dailyPlan')
  final DailyPlanDetails details;

  @JsonKey(ignore: true)
  final String fullVerseText;

  @JsonKey(ignore: true)
  final String surahName;

  @JsonKey(ignore: true)
  final int startAyah;

  @JsonKey(ignore: true)
  final int endAyah;

  @JsonKey(ignore: true)
  final String planName;

  @JsonKey(ignore: true)
  final int repetitionTarget = 10;
  @JsonKey(ignore: true)
  final int listeningTarget = 1;
  @JsonKey(ignore: true)
  final int writingTarget = 1;

  String get title =>
      "الخطة : $planName (${details.dayNumber} - الجزء ${details.partNumber})";

  String? get audioUrl => details.audioClipPath;

  MemorizationPlanModel({
    required this.progressId,
    required this.currentRepetition,
    required this.currentListening,
    required this.isWritingCompleted,
    required this.isMemorizationCompleted,
    required this.isReviewCompleted,
    required this.isLinkCompleted,
    required this.details,
    this.fullVerseText = "",
    this.surahName = "",
    this.startAyah = 0,
    this.endAyah = 0,
    this.planName = "",
  });

  factory MemorizationPlanModel.fromJson(Map<String, dynamic> json) =>
      _$MemorizationPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemorizationPlanModelToJson(this);

  MemorizationPlanModel copyWith({
    int? currentRepetition,
    int? currentListening,
    bool? isWritingCompleted,
    bool? isMemorizationCompleted,
    bool? isReviewCompleted,
    bool? isLinkCompleted,
    String? fullVerseText,
    String? surahName,
    int? startAyah,
    int? endAyah,
    String? planName,
  }) {
    return MemorizationPlanModel(
      progressId: this.progressId,
      details: this.details,
      currentRepetition: currentRepetition ?? this.currentRepetition,
      currentListening: currentListening ?? this.currentListening,
      isWritingCompleted: isWritingCompleted ?? this.isWritingCompleted,
      isMemorizationCompleted:
          isMemorizationCompleted ?? this.isMemorizationCompleted,
      isReviewCompleted: isReviewCompleted ?? this.isReviewCompleted,
      isLinkCompleted: isLinkCompleted ?? this.isLinkCompleted,
      fullVerseText: fullVerseText ?? this.fullVerseText,
      surahName: surahName ?? this.surahName,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
      planName: planName ?? this.planName,
    );
  }
}

@JsonSerializable()
class DailyPlanDetails {
  final int id;
  final String dayNumber;
  final int surahStartId;

  @JsonKey(name: 'verseStartId')
  final int? verseStartNumber;

  @JsonKey(name: 'verseEndId')
  final int? verseEndNumber;

  final int partNumber;
  final String? audioClipPath;
  final int planId;

  final int? reviewSurahId;
  final int? reviewStartVerse;
  final int? reviewEndVerse;

  final int? linkSurahId;
  final int? linkStartVerse;
  final int? linkEndVerse;

  DailyPlanDetails({
    required this.id,
    required this.dayNumber,
    required this.surahStartId,
    this.verseStartNumber,
    this.verseEndNumber,
    required this.partNumber,
    this.audioClipPath,
    required this.planId,
    this.reviewSurahId,
    this.reviewStartVerse,
    this.reviewEndVerse,
    this.linkSurahId,
    this.linkStartVerse,
    this.linkEndVerse,
  });

  factory DailyPlanDetails.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DailyPlanDetailsToJson(this);
}
