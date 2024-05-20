// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      status: json['status'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      countRoom: json['countRoom'] as int,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      countBathroom: json['countBathroom'] as int,
      createDate: DateTime.parse(json['createDate'] as String),
      customPrice: (json['customPrice'] as num?)?.toDouble(),
      size: (json['size'] as num?)?.toDouble(),
      finishDate: json['finishDate'] == null
          ? null
          : DateTime.parse(json['finishDate'] as String),
      cleaner: json['cleaner'] as String?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'options': instance.options,
      'countRoom': instance.countRoom,
      'countBathroom': instance.countBathroom,
      'createDate': instance.createDate.toIso8601String(),
      'startDate': instance.startDate.toIso8601String(),
      'customPrice': instance.customPrice,
      'size': instance.size,
      'address': instance.address,
      'finishDate': instance.finishDate?.toIso8601String(),
      'cleaner': instance.cleaner,
    };
