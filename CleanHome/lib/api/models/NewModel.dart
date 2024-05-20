import 'package:json_annotation/json_annotation.dart';

part 'NewModel.g.dart';

@JsonSerializable()
class NewModel{
  final String id;
  final String title;
  final String info;
  final String? image;
  final String? url;

  NewModel({
    required this.id,
    required this.title,
    required this.info,
    this.image,
    this.url
});
  factory NewModel.fromJson(Map<String, dynamic> json) => _$NewModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewModelToJson(this);
}