// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NewModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewModel _$NewModelFromJson(Map<String, dynamic> json) => NewModel(
      id: json['id'] as String,
      title: json['title'] as String,
      info: json['info'] as String,
      image: json['image'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$NewModelToJson(NewModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'info': instance.info,
      'image': instance.image,
      'url': instance.url,
    };
