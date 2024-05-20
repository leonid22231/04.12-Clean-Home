// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionModel _$RegionModelFromJson(Map<String, dynamic> json) => RegionModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      priceRoom: (json['priceRoom'] as num).toDouble(),
      priceBathroom: (json['priceBathroom'] as num).toDouble(),
      priceSize: (json['priceSize'] as num).toDouble(),
      options: (json['options'] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegionModelToJson(RegionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priceRoom': instance.priceRoom,
      'priceBathroom': instance.priceBathroom,
      'priceSize': instance.priceSize,
      'options': instance.options,
    };
