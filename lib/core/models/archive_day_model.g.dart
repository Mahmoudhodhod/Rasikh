// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveDayModel _$ArchiveDayModelFromJson(Map<String, dynamic> json) =>
    ArchiveDayModel(
      id: (json['id'] as num).toInt(),
      dayNumber: json['dayNumber'] as String,
      surahStartName: json['surahStartName'] as String?,
      surahEndName: json['surahEndName'] as String?,
      verseStartNumber: (json['verseStartNumber'] as num?)?.toInt(),
      verseEndNumber: (json['verseEndNumber'] as num?)?.toInt(),
      reviewSurahStartName: json['reviewSurahStartName'] as String?,
      reviewSurahEndName: json['reviewSurahEndtName'] as String?,
      reviewVerseStartNumber: (json['reviewVerseStartNumber'] as num?)?.toInt(),
      reviewVerseEndNumber: (json['reviewVerseEndNumber'] as num?)?.toInt(),
      linkSurahStartName: json['linkSurahStartName'] as String?,
      linkSurahEndName: json['linkSurahEndtName'] as String?,
      linkVerseStartNumber: (json['linkVerseStartNumber'] as num?)?.toInt(),
      linkVerseEndNumber: (json['linkVerseEndNumber'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      repetitionCount: (json['repeatNumber'] as num).toInt(),
      listeningCount: (json['listenNumber'] as num).toInt(),
      writingCompleted: json['isWrited'] as bool,
      completedAt: json['completedAt'] as String?,
      isCompleted: json['isCompleted'] as bool,
      savedAyatCount: (json['savedAyatCount'] as num?)?.toInt(),
      reviewedAyatCount: (json['reviewedAyatCount'] as num?)?.toInt(),
      linkedAyatCount: (json['linkedAyatCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ArchiveDayModelToJson(ArchiveDayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayNumber': instance.dayNumber,
      'surahStartName': instance.surahStartName,
      'surahEndName': instance.surahEndName,
      'verseStartNumber': instance.verseStartNumber,
      'verseEndNumber': instance.verseEndNumber,
      'reviewSurahStartName': instance.reviewSurahStartName,
      'reviewSurahEndtName': instance.reviewSurahEndName,
      'reviewVerseStartNumber': instance.reviewVerseStartNumber,
      'reviewVerseEndNumber': instance.reviewVerseEndNumber,
      'linkSurahStartName': instance.linkSurahStartName,
      'linkSurahEndtName': instance.linkSurahEndName,
      'linkVerseStartNumber': instance.linkVerseStartNumber,
      'linkVerseEndNumber': instance.linkVerseEndNumber,
      'order': instance.order,
      'repeatNumber': instance.repetitionCount,
      'listenNumber': instance.listeningCount,
      'isWrited': instance.writingCompleted,
      'completedAt': instance.completedAt,
      'isCompleted': instance.isCompleted,
      'savedAyatCount': instance.savedAyatCount,
      'reviewedAyatCount': instance.reviewedAyatCount,
      'linkedAyatCount': instance.linkedAyatCount,
    };
