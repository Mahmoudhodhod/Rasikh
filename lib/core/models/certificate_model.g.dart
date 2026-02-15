// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateModel _$CertificateModelFromJson(Map<String, dynamic> json) =>
    CertificateModel(
      id: (json['id'] as num).toInt(),
      studentName: json['studentName'] as String,
      partName: CertificateModel._readPart(json, 'part') as String,
      date: json['date'] as String,
      planName: json['planName'] as String,
    );

Map<String, dynamic> _$CertificateModelToJson(CertificateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentName': instance.studentName,
      'part': instance.partName,
      'date': instance.date,
      'planName': instance.planName,
    };
