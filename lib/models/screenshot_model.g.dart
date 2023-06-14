// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screenshot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Screenshot _$ScreenshotFromJson(Map<String, dynamic> json) => Screenshot(
      $id: json[r'$id'] as String,
      workdiaryId: json['workdiaryId'] as String,
      image: json['image'] as String,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$ScreenshotToJson(Screenshot instance) =>
    <String, dynamic>{
      r'$id': instance.$id,
      'workdiaryId': instance.workdiaryId,
      'image': instance.image,
      'memo': instance.memo,
    };
