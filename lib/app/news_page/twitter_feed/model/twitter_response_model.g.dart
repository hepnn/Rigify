// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TwitterResponseModelImpl _$$TwitterResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TwitterResponseModelImpl(
      createdAt: json['created_at'] as String,
      entities: TwitterEntitiesModel.fromJson(
          json['entities'] as Map<String, dynamic>),
      user: TwitterUserModel.fromJson(json['user'] as Map<String, dynamic>),
      fullText: json['full_text'] as String,
    );

Map<String, dynamic> _$$TwitterResponseModelImplToJson(
        _$TwitterResponseModelImpl instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt,
      'entities': instance.entities,
      'user': instance.user,
      'full_text': instance.fullText,
    };

_$TwitterEntitiesModelImpl _$$TwitterEntitiesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TwitterEntitiesModelImpl(
      media: (json['media'] as List<dynamic>)
          .map((e) => TwitterMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TwitterEntitiesModelImplToJson(
        _$TwitterEntitiesModelImpl instance) =>
    <String, dynamic>{
      'media': instance.media,
    };

_$TwitterMediaModelImpl _$$TwitterMediaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TwitterMediaModelImpl(
      mediaUrl: json['media_url'] as String,
    );

Map<String, dynamic> _$$TwitterMediaModelImplToJson(
        _$TwitterMediaModelImpl instance) =>
    <String, dynamic>{
      'media_url': instance.mediaUrl,
    };

_$TwitterUserModelImpl _$$TwitterUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TwitterUserModelImpl(
      profileImageUrl: json['profile_image_url_https'] as String,
      name: json['name'] as String,
      screenName: json['screenName'] as String,
    );

Map<String, dynamic> _$$TwitterUserModelImplToJson(
        _$TwitterUserModelImpl instance) =>
    <String, dynamic>{
      'profile_image_url_https': instance.profileImageUrl,
      'name': instance.name,
      'screenName': instance.screenName,
    };
