// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
  savedVersesCount: _numToInt(json['totalSavedAyat']),
  savedPagesCount: _numToInt(json['totalWajah']),
  savedJuzCount: _numToInt(json['completedPartsNumbr']),
  dailyAverage: _numToDouble(json['averageDailyMemorization']),
  totalParts: _numToInt(json['totalParts']),
  linkedVersesCount: _numToInt(json['totalLinkedAyat']),
  reviewedVersesCount: _numToInt(json['totalReviewedAyat']),
  completionPercentage: _numToDouble(json['completionPercentage']),
  completedDays: _numToInt(json['completedDays']),
  performance: _numToDouble(json['performance']),
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'totalSavedAyat': instance.savedVersesCount,
      'totalWajah': instance.savedPagesCount,
      'completedPartsNumbr': instance.savedJuzCount,
      'averageDailyMemorization': instance.dailyAverage,
      'totalParts': instance.totalParts,
      'totalLinkedAyat': instance.linkedVersesCount,
      'totalReviewedAyat': instance.reviewedVersesCount,
      'completionPercentage': instance.completionPercentage,
      'completedDays': instance.completedDays,
      'performance': instance.performance,
    };
