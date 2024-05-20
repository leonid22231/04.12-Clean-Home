import 'package:cleanhome/api/models/OptionModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'RegionModel.g.dart';

@JsonSerializable()
class RegionModel{
  final String? id;
  final String? name;
  final double priceRoom;
  final double priceBathroom;
  final double priceSize;
  final List<OptionModel> options;

  const RegionModel(
      {this.id,
        this.name,
        required this.priceRoom,
        required this.priceBathroom,
        required this.priceSize,
        required this.options
        });

  factory RegionModel.fromJson(Map<String, dynamic> json) => _$RegionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionModelToJson(this);
}