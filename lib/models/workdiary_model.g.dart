// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workdiary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkDiary _$WorkDiaryFromJson(Map<String, dynamic> json) => WorkDiary(
      $id: json[r'$id'] as String,
      startime: DateTime.parse(json['startime'] as String),
      contractId: json['contractId'] as String,
      duration: json['duration'] as int,
      endtime: json['endtime'] == null
          ? null
          : DateTime.parse(json['endtime'] as String),
    );

Map<String, dynamic> _$WorkDiaryToJson(WorkDiary instance) => <String, dynamic>{
      r'$id': instance.$id,
      'startime': instance.startime.toIso8601String(),
      'endtime': instance.endtime?.toIso8601String(),
      'contractId': instance.contractId,
      'duration': instance.duration,
    };
