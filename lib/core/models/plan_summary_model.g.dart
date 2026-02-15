// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanSummaryModel _$PlanSummaryModelFromJson(Map<String, dynamic> json) =>
    PlanSummaryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      monthNumber: (json['monthNumber'] as num?)?.toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$PlanSummaryModelToJson(PlanSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'monthNumber': instance.monthNumber,
      'isCompleted': instance.isCompleted,
    };
