// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TafsirModel _$TafsirModelFromJson(Map<String, dynamic> json) => TafsirModel(
  id: (_extractId(json, 'id') as num).toInt(),
  surahId: (json['surahId'] as num?)?.toInt() ?? 0,
  verseNumber: (_extractVerseId(json, 'verseNumber') as num?)?.toInt() ?? 0,
  verseText: _extractVerseText(json, 'verseText') as String?,
  tafsirText: json['tafsir'] as String?,
);

Map<String, dynamic> _$TafsirModelToJson(TafsirModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surahId': instance.surahId,
      'verseNumber': instance.verseNumber,
      'verseText': instance.verseText,
      'tafsir': instance.tafsirText,
    };

SurahModel _$SurahModelFromJson(Map<String, dynamic> json) => SurahModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  type: json['type'] as String?,
  ayahsNumber: (json['ayahsNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$SurahModelToJson(SurahModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'ayahsNumber': instance.ayahsNumber,
    };

VerseNumberModel _$VerseNumberModelFromJson(Map<String, dynamic> json) =>
    VerseNumberModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      numberInSurah:
          (_extractVerseId(json, 'numberInSurah') as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VerseNumberModelToJson(VerseNumberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numberInSurah': instance.numberInSurah,
    };
