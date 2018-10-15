import 'package:json_annotation/json_annotation.dart';

part 'SitesModel.g.dart';

@JsonSerializable(nullable: true)
class SitesModel{
  var id;
  var name;
  List<SitesModel> items;
  var image;
  var cnt;
  var followed;
  var time;

  SitesModel(
      {this.id,
      this.name,
      this.items,
      this.image,
      this.cnt,
      this.followed,
      this.time});
  factory SitesModel.fromJson(Map<String, dynamic> json) => _$SitesModelFromJson(json);
}
