import 'package:json_annotation/json_annotation.dart';
part 'report_model.g.dart';

double _numToDouble(Object? v) => (v as num?)?.toDouble() ?? 0.0;
int _numToInt(Object? v) => (v as num?)?.toInt() ?? 0;

@JsonSerializable()
class ReportModel {
  @JsonKey(name: 'totalSavedAyat', fromJson: _numToInt)
  final int savedVersesCount;

  @JsonKey(name: 'totalWajah', fromJson: _numToInt)
  final int savedPagesCount;

  @JsonKey(name: 'completedPartsNumbr', fromJson: _numToInt)
  final int savedJuzCount;

  @JsonKey(name: 'averageDailyMemorization', fromJson: _numToDouble)
  final double dailyAverage;

  @JsonKey(name: 'totalParts', fromJson: _numToInt)
  final int totalParts; 

  @JsonKey(name: 'totalLinkedAyat', fromJson: _numToInt)
  final int linkedVersesCount;

  @JsonKey(name: 'totalReviewedAyat', fromJson: _numToInt)
  final int reviewedVersesCount;

  @JsonKey(name: 'completionPercentage', fromJson: _numToDouble)
  final double completionPercentage;

  @JsonKey(name: 'completedDays', fromJson: _numToInt)
  final int completedDays;

  @JsonKey(name: 'performance', fromJson: _numToDouble)
  final double performance;

  @JsonKey(ignore: true)
  final String hadith = '"خيركم من تعلم القرآن وعلمه"';

  @JsonKey(ignore: true)
  final String quote = 'كل آية تحفظها، هي نور في قلبك، ورفعة في آخرتك.';

  const ReportModel({
    required this.savedVersesCount,
    required this.savedPagesCount,
    required this.savedJuzCount,
    required this.dailyAverage,
    required this.totalParts,
    required this.linkedVersesCount,
    required this.reviewedVersesCount,
    required this.completionPercentage,
    required this.completedDays,
    required this.performance,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
