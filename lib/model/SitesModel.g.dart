// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SitesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitesModel _$SitesModelFromJson(Map<String, dynamic> json) {
  return SitesModel(
      id: json['id'],
      name: json['name'],
      items: (json['items'] as List)
          ?.map((e) =>
              e == null ? null : SitesModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      image: json['image'],
      cnt: json['cnt'],
      followed: json['followed'],
      time: json['time']);
}

Map<String, dynamic> _$SitesModelToJson(SitesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
      'image': instance.image,
      'cnt': instance.cnt,
      'followed': instance.followed,
      'time': instance.time
    };
