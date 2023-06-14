import 'package:json_annotation/json_annotation.dart';

part 'screenshot_model.g.dart';

@JsonEnum()
enum Status { pending, onhold, done, active, declined }

@JsonSerializable()
class Screenshot {
  final String $id, workdiaryId, image;
  final String? memo;

  Screenshot({
    required this.$id,
    required this.workdiaryId,
    required this.image,
    this.memo,
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenshotToJson(this);
}
