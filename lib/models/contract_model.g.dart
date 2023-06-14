// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      $id: json[r'$id'] as String,
      employeeId: json['employeeId'] as String,
      employerId: json['employerId'] as String,
      title: json['title'] as String,
      minutes: json['minutes'] as int,
      description: json['description'] as String?,
      status: $enumDecode(_$StatusEnumMap, json['status']),
      employerName: json['employerName'] as String?,
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      r'$id': instance.$id,
      'employeeId': instance.employeeId,
      'employerId': instance.employerId,
      'title': instance.title,
      'description': instance.description,
      'employerName': instance.employerName,
      'status': _$StatusEnumMap[instance.status]!,
      'minutes': instance.minutes,
    };

const _$StatusEnumMap = {
  Status.pending: 'pending',
  Status.onhold: 'onhold',
  Status.done: 'done',
  Status.active: 'active',
  Status.declined: 'declined',
};
