import 'package:freezed_annotation/freezed_annotation.dart';

part 'twitter_response_model.freezed.dart';
part 'twitter_response_model.g.dart';

@freezed
class TwitterResponseModel with _$TwitterResponseModel {
  const factory TwitterResponseModel({
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'entities') required TwitterEntitiesModel entities,
    @JsonKey(name: 'user') required TwitterUserModel user,
    @JsonKey(name: 'full_text') required String fullText,
  }) = _TwitterResponseModel;

  factory TwitterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TwitterResponseModelFromJson(json);
}

@freezed
class TwitterEntitiesModel with _$TwitterEntitiesModel {
  const factory TwitterEntitiesModel({
    required List<TwitterMediaModel> media,
  }) = _TwitterEntitiesModel;

  factory TwitterEntitiesModel.fromJson(Map<String, dynamic> json) =>
      _$TwitterEntitiesModelFromJson(json);
}

@freezed
class TwitterMediaModel with _$TwitterMediaModel {
  const factory TwitterMediaModel({
    @JsonKey(name: 'media_url') required String mediaUrl,
  }) = _TwitterMediaModel;

  factory TwitterMediaModel.fromJson(Map<String, dynamic> json) =>
      _$TwitterMediaModelFromJson(json);
}

@freezed
class TwitterUserModel with _$TwitterUserModel {
  const factory TwitterUserModel({
    @JsonKey(name: 'profile_image_url_https') required String profileImageUrl,
    required String name,
    required String screenName,
  }) = _TwitterUserModel;

  factory TwitterUserModel.fromJson(Map<String, dynamic> json) =>
      _$TwitterUserModelFromJson(json);
}
