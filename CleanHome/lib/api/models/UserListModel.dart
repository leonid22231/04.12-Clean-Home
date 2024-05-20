import 'package:json_annotation/json_annotation.dart';

import 'UserModel.dart';

part 'UserListModel.g.dart';
@JsonSerializable()
class UserListModel{
  List<UserModel> users;
  List<UserModel> cleaners;

  UserListModel({required this.users,required this.cleaners});

  factory UserListModel.fromJson(Map<String, dynamic> json) => _$UserListModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListModelToJson(this);
}