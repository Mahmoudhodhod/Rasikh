import 'package:json_annotation/json_annotation.dart';

part 'certificate_model.g.dart';

@JsonSerializable()
class CertificateModel {
  final int id;
  final String studentName;
  @JsonKey(name: 'part', readValue: _readPart)
  final String partName;

  final String date;
  final String planName;

  CertificateModel({
    required this.id,
    required this.studentName,
    required this.partName,
    required this.date,
    required this.planName,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      _$CertificateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateModelToJson(this);
  static Object? _readPart(Map json, String key) {
    return json['part'] ?? json['partt'] ?? 'غير محدد';
  }
}
