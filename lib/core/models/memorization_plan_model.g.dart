// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorization_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemorizationPlanModel _$MemorizationPlanModelFromJson(
  Map<String, dynamic> json,
) => MemorizationPlanModel(
  progressId: (json['id'] as num).toInt(),
  currentRepetition: (json['reapetNumber'] as num).toInt(),
  currentListening: (json['heardNumber'] as num).toInt(),
  isWritingCompleted: json['isWriting'] as bool,
  isMemorizationCompleted: json['isCompleted'] as bool,
  isReviewCompleted: json['isReview'] as bool? ?? false,
  isLinkCompleted: json['isLink'] as bool? ?? false,
  details: DailyPlanDetails.fromJson(json['dailyPlan'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MemorizationPlanModelToJson(
  MemorizationPlanModel instance,
) => <String, dynamic>{
  'id': instance.progressId,
  'reapetNumber': instance.currentRepetition,
  'heardNumber': instance.currentListening,
  'isWriting': instance.isWritingCompleted,
  'isCompleted': instance.isMemorizationCompleted,
  'isReview': instance.isReviewCompleted,
  'isLink': instance.isLinkCompleted,
  'dailyPlan': instance.details,
};

DailyPlanDetails _$DailyPlanDetailsFromJson(Map<String, dynamic> json) =>
    DailyPlanDetails(
      id: (json['id'] as num).toInt(),
      dayNumber: json['dayNumber'] as String,
      surahStartId: (json['surahStartId'] as num).toInt(),
      verseStartNumber: (json['verseStartId'] as num?)?.toInt(),
      verseEndNumber: (json['verseEndId'] as num?)?.toInt(),
      partNumber: (json['partNumber'] as num).toInt(),
      audioClipPath: json['audioClipPath'] as String?,
      planId: (json['planId'] as num).toInt(),
      reviewSurahId: (json['reviewSurahId'] as num?)?.toInt(),
      reviewStartVerse: (json['reviewStartVerse'] as num?)?.toInt(),
      reviewEndVerse: (json['reviewEndVerse'] as num?)?.toInt(),
      linkSurahId: (json['linkSurahId'] as num?)?.toInt(),
      linkStartVerse: (json['linkStartVerse'] as num?)?.toInt(),
      linkEndVerse: (json['linkEndVerse'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DailyPlanDetailsToJson(DailyPlanDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayNumber': instance.dayNumber,
      'surahStartId': instance.surahStartId,
      'verseStartId': instance.verseStartNumber,
      'verseEndId': instance.verseEndNumber,
      'partNumber': instance.partNumber,
      'audioClipPath': instance.audioClipPath,
      'planId': instance.planId,
      'reviewSurahId': instance.reviewSurahId,
      'reviewStartVerse': instance.reviewStartVerse,
      'reviewEndVerse': instance.reviewEndVerse,
      'linkSurahId': instance.linkSurahId,
      'linkStartVerse': instance.linkStartVerse,
      'linkEndVerse': instance.linkEndVerse,
    };
