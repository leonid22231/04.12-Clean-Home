import 'package:cleanhome/api/models/AddressModel.dart';
import 'package:cleanhome/api/models/OptionModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'OrderModel.g.dart';

@JsonSerializable()
class OrderModel{
  final String id;
  final String status;
  final List<OptionModel> options;
  final int countRoom;
  final int countBathroom;
  final DateTime createDate;
  final DateTime startDate;
  final double? customPrice;
  final double? size;
  final AddressModel address;
  final DateTime? finishDate;
  final String? cleaner;

  OrderModel({required this.id,
    required this.startDate,
    required this.status,
    required this.options,
    required this.countRoom,
    required this.address,
    required this.countBathroom,
    required this.createDate,
    this.customPrice,
    this.size,
    this.finishDate,
    this.cleaner});

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

}