import 'package:cleanhome/api/models/AddressModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String phoneNumber;
  final String? email;
  final String? createDate;
  final bool? activate;
  final RegionModel? region;
  final List<AddressModel> addresses;
  final List<String?>? roles;

  const UserModel(
      {required this.id,
        this.firstName,
        this.lastName,
        required this.phoneNumber,
        this.email,
        this.createDate,
        this.activate,
        required this.addresses,
        required this.region,
        this.roles});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}