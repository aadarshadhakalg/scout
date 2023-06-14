import 'package:json_annotation/json_annotation.dart';

part 'workdiary_model.g.dart';

@JsonSerializable()
class WorkDiary {
  final String $id;
  final DateTime startime;
  final DateTime? endtime;
  final String contractId;
  final int duration;

  WorkDiary({
    required this.$id,
    required this.startime,
    required this.contractId,
    required this.duration,
    this.endtime,
  });

  factory WorkDiary.fromJson(Map<String, dynamic> json) =>
      _$WorkDiaryFromJson(json);

  Map<String, dynamic> toJson() => _$WorkDiaryToJson(this);
}
