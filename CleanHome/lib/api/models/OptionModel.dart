import 'package:json_annotation/json_annotation.dart';

part 'OptionModel.g.dart';

@JsonSerializable()
class OptionModel{
  final String id;
  final String name;
  final String? description;
  final double price;

  OptionModel({
      required this.id,
    required this.name,
    this.description,
    required this.price
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) => _$OptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionModelToJson(this);

}