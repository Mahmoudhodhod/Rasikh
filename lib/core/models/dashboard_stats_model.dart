import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel {
  @JsonKey(name: 'completionPercentage')
  final double overallProgress;

  @JsonKey(name: 'completedPartsNumbr')
  final int completedParts;

  @JsonKey(name: 'totalSavedAyat')
  final int totalSavedAyat;

  @JsonKey(name: 'totalWajah')
  final int totalWajah;

  @JsonKey(name: 'averageDailyMemorization')
  final double averageDailyMemorization;

  @JsonKey(ignore: true)
  final double progressGood;

  @JsonKey(ignore: true)
  final double progressNeedsImprovement;

  @JsonKey(ignore: true)
  final double progressNeedsIntensiveReview;

  @JsonKey(ignore: true)
  final String nextTarget;

  DashboardStatsModel({
    required this.overallProgress,
    required this.completedParts,
    required this.totalSavedAyat,
    required this.totalWajah,
    required this.averageDailyMemorization,
    this.progressGood = 0,
    this.progressNeedsImprovement = 0,
    this.progressNeedsIntensiveReview = 0,
    this.nextTarget = "",
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return _$DashboardStatsModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);
}
