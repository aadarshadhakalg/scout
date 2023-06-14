import 'package:json_annotation/json_annotation.dart';

part 'contract_model.g.dart';

@JsonEnum()
enum Status { pending, onhold, done, active, declined }

@JsonSerializable()
class Contract {
  final String $id;
  final String employeeId, employerId, title;
  final String? description, employerName;
  final Status status;
  final int minutes;

  Contract({
    required this.$id,
    required this.employeeId,
    required this.employerId,
    required this.title,
    required this.minutes,
    this.description,
    required this.status,
    this.employerName,
  });

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);

  Map<String, dynamic> toJson() => _$ContractToJson(this);
}
