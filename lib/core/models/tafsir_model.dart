import 'package:json_annotation/json_annotation.dart';
part 'tafsir_model.g.dart';

Object? _extractVerseId(Map<dynamic, dynamic> map, String key) {
  return map['verseId'] ?? map['verseNumber'] ?? map['numberInSurah'];
}
Object? _extractId(Map<dynamic, dynamic> map, String key) {
  return map['id'] ?? 0;
}
Object? _extractVerseText(Map<dynamic, dynamic> map, String key) {
  if (map['verseText'] != null) return map['verseText'];
  if (map['verse'] != null) return map['verse'];
  if (map['ayah'] != null) return map['ayah'];
  if (map['text'] != null) return map['text'];

  return null;
}

@JsonSerializable()
class TafsirModel {
  @JsonKey(name: 'id', readValue: _extractId)
  final int id;

  @JsonKey(name: 'surahId', defaultValue: 0)
  final int surahId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String surahName;

  @JsonKey(readValue: _extractVerseId, defaultValue: 0)
  final int verseNumber;
  @JsonKey(readValue: _extractVerseText)
  final String? verseText;

  @JsonKey(name: 'tafsir')
  final String? tafsirText;

  TafsirModel({
    required this.id,
    required this.surahId,
    this.surahName = "",
    required this.verseNumber,
    this.verseText,
    this.tafsirText,
  });

  factory TafsirModel.fromJson(Map<String, dynamic> json) =>
      _$TafsirModelFromJson(json);

  Map<String, dynamic> toJson() => _$TafsirModelToJson(this);
}

@JsonSerializable()
class SurahModel {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: "")
  final String name;
  final String? type;
  final int? ayahsNumber;

  SurahModel({
    required this.id,
    required this.name,
    this.type,
    this.ayahsNumber,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) =>
      _$SurahModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurahModelToJson(this);
}

@JsonSerializable()
class VerseNumberModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(readValue: _extractVerseId, defaultValue: 0)
  final int numberInSurah;
  VerseNumberModel({required this.id, required this.numberInSurah});
  factory VerseNumberModel.fromJson(Map<String, dynamic> json) =>
      _$VerseNumberModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerseNumberModelToJson(this);
}