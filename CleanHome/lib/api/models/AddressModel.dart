import 'package:json_annotation/json_annotation.dart';

part 'AddressModel.g.dart';

@JsonSerializable()
class AddressModel{
  final String id;
  final String city;
  final String street;
  final String house;
  final String? frame;
  final String? entrance;
  final String apartment;
  final String? intercom;
  final String? floor;

  AddressModel({
    required this.id,
    required this.city,
    required this.street,
    required this.house,
    this.frame,
    this.entrance,
      required this.apartment,
    this.intercom,
    this.floor});

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  @override
  String toString() {
    return street+", д." + house+", кв. "+apartment;
  }
}