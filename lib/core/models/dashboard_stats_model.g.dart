// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      overallProgress: (json['completionPercentage'] as num).toDouble(),
      completedParts: (json['completedPartsNumbr'] as num).toInt(),
      totalSavedAyat: (json['totalSavedAyat'] as num).toInt(),
      totalWajah: (json['totalWajah'] as num).toInt(),
      averageDailyMemorization: (json['averageDailyMemorization'] as num)
          .toDouble(),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  DashboardStatsModel instance,
) => <String, dynamic>{
  'completionPercentage': instance.overallProgress,
  'completedPartsNumbr': instance.completedParts,
  'totalSavedAyat': instance.totalSavedAyat,
  'totalWajah': instance.totalWajah,
  'averageDailyMemorization': instance.averageDailyMemorization,
};
