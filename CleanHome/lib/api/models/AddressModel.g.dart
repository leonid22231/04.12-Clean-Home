// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AddressModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      id: json['id'] as String,
      city: json['city'] as String,
      street: json['street'] as String,
      house: json['house'] as String,
      frame: json['frame'] as String?,
      entrance: json['entrance'] as String?,
      apartment: json['apartment'] as String,
      intercom: json['intercom'] as String?,
      floor: json['floor'] as String?,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'street': instance.street,
      'house': instance.house,
      'frame': instance.frame,
      'entrance': instance.entrance,
      'apartment': instance.apartment,
      'intercom': instance.intercom,
      'floor': instance.floor,
    };
