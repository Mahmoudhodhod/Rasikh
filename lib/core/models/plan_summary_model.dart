import 'package:json_annotation/json_annotation.dart';

part 'plan_summary_model.g.dart';
@JsonSerializable()
class PlanSummaryModel {
  final int id;
  final String name;
  final int? monthNumber;

  @JsonKey(defaultValue: false)
  bool isCompleted;

  PlanSummaryModel({
    required this.id,
    required this.name,
    this.monthNumber,
    this.isCompleted = false,
  });

  factory PlanSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PlanSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlanSummaryModelToJson(this);
}
