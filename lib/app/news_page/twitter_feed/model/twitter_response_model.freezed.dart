// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'twitter_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TwitterResponseModel _$TwitterResponseModelFromJson(Map<String, dynamic> json) {
  return _TwitterResponseModel.fromJson(json);
}

/// @nodoc
mixin _$TwitterResponseModel {
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'entities')
  TwitterEntitiesModel get entities => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  TwitterUserModel get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_text')
  String get fullText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TwitterResponseModelCopyWith<TwitterResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwitterResponseModelCopyWith<$Res> {
  factory $TwitterResponseModelCopyWith(TwitterResponseModel value,
          $Res Function(TwitterResponseModel) then) =
      _$TwitterResponseModelCopyWithImpl<$Res, TwitterResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'entities') TwitterEntitiesModel entities,
      @JsonKey(name: 'user') TwitterUserModel user,
      @JsonKey(name: 'full_text') String fullText});

  $TwitterEntitiesModelCopyWith<$Res> get entities;
  $TwitterUserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$TwitterResponseModelCopyWithImpl<$Res,
        $Val extends TwitterResponseModel>
    implements $TwitterResponseModelCopyWith<$Res> {
  _$TwitterResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? entities = null,
    Object? user = null,
    Object? fullText = null,
  }) {
    return _then(_value.copyWith(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      entities: null == entities
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as TwitterEntitiesModel,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as TwitterUserModel,
      fullText: null == fullText
          ? _value.fullText
          : fullText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TwitterEntitiesModelCopyWith<$Res> get entities {
    return $TwitterEntitiesModelCopyWith<$Res>(_value.entities, (value) {
      return _then(_value.copyWith(entities: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TwitterUserModelCopyWith<$Res> get user {
    return $TwitterUserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TwitterResponseModelImplCopyWith<$Res>
    implements $TwitterResponseModelCopyWith<$Res> {
  factory _$$TwitterResponseModelImplCopyWith(_$TwitterResponseModelImpl value,
          $Res Function(_$TwitterResponseModelImpl) then) =
      __$$TwitterResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'entities') TwitterEntitiesModel entities,
      @JsonKey(name: 'user') TwitterUserModel user,
      @JsonKey(name: 'full_text') String fullText});

  @override
  $TwitterEntitiesModelCopyWith<$Res> get entities;
  @override
  $TwitterUserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$TwitterResponseModelImplCopyWithImpl<$Res>
    extends _$TwitterResponseModelCopyWithImpl<$Res, _$TwitterResponseModelImpl>
    implements _$$TwitterResponseModelImplCopyWith<$Res> {
  __$$TwitterResponseModelImplCopyWithImpl(_$TwitterResponseModelImpl _value,
      $Res Function(_$TwitterResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? entities = null,
    Object? user = null,
    Object? fullText = null,
  }) {
    return _then(_$TwitterResponseModelImpl(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      entities: null == entities
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as TwitterEntitiesModel,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as TwitterUserModel,
      fullText: null == fullText
          ? _value.fullText
          : fullText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TwitterResponseModelImpl implements _TwitterResponseModel {
  const _$TwitterResponseModelImpl(
      {@JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'entities') required this.entities,
      @JsonKey(name: 'user') required this.user,
      @JsonKey(name: 'full_text') required this.fullText});

  factory _$TwitterResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TwitterResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'entities')
  final TwitterEntitiesModel entities;
  @override
  @JsonKey(name: 'user')
  final TwitterUserModel user;
  @override
  @JsonKey(name: 'full_text')
  final String fullText;

  @override
  String toString() {
    return 'TwitterResponseModel(createdAt: $createdAt, entities: $entities, user: $user, fullText: $fullText)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwitterResponseModelImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.entities, entities) ||
                other.entities == entities) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.fullText, fullText) ||
                other.fullText == fullText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, createdAt, entities, user, fullText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TwitterResponseModelImplCopyWith<_$TwitterResponseModelImpl>
      get copyWith =>
          __$$TwitterResponseModelImplCopyWithImpl<_$TwitterResponseModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TwitterResponseModelImplToJson(
      this,
    );
  }
}

abstract class _TwitterResponseModel implements TwitterResponseModel {
  const factory _TwitterResponseModel(
      {@JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'entities') required final TwitterEntitiesModel entities,
      @JsonKey(name: 'user') required final TwitterUserModel user,
      @JsonKey(name: 'full_text')
      required final String fullText}) = _$TwitterResponseModelImpl;

  factory _TwitterResponseModel.fromJson(Map<String, dynamic> json) =
      _$TwitterResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'entities')
  TwitterEntitiesModel get entities;
  @override
  @JsonKey(name: 'user')
  TwitterUserModel get user;
  @override
  @JsonKey(name: 'full_text')
  String get fullText;
  @override
  @JsonKey(ignore: true)
  _$$TwitterResponseModelImplCopyWith<_$TwitterResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TwitterEntitiesModel _$TwitterEntitiesModelFromJson(Map<String, dynamic> json) {
  return _TwitterEntitiesModel.fromJson(json);
}

/// @nodoc
mixin _$TwitterEntitiesModel {
  List<TwitterMediaModel> get media => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TwitterEntitiesModelCopyWith<TwitterEntitiesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwitterEntitiesModelCopyWith<$Res> {
  factory $TwitterEntitiesModelCopyWith(TwitterEntitiesModel value,
          $Res Function(TwitterEntitiesModel) then) =
      _$TwitterEntitiesModelCopyWithImpl<$Res, TwitterEntitiesModel>;
  @useResult
  $Res call({List<TwitterMediaModel> media});
}

/// @nodoc
class _$TwitterEntitiesModelCopyWithImpl<$Res,
        $Val extends TwitterEntitiesModel>
    implements $TwitterEntitiesModelCopyWith<$Res> {
  _$TwitterEntitiesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? media = null,
  }) {
    return _then(_value.copyWith(
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<TwitterMediaModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TwitterEntitiesModelImplCopyWith<$Res>
    implements $TwitterEntitiesModelCopyWith<$Res> {
  factory _$$TwitterEntitiesModelImplCopyWith(_$TwitterEntitiesModelImpl value,
          $Res Function(_$TwitterEntitiesModelImpl) then) =
      __$$TwitterEntitiesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TwitterMediaModel> media});
}

/// @nodoc
class __$$TwitterEntitiesModelImplCopyWithImpl<$Res>
    extends _$TwitterEntitiesModelCopyWithImpl<$Res, _$TwitterEntitiesModelImpl>
    implements _$$TwitterEntitiesModelImplCopyWith<$Res> {
  __$$TwitterEntitiesModelImplCopyWithImpl(_$TwitterEntitiesModelImpl _value,
      $Res Function(_$TwitterEntitiesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? media = null,
  }) {
    return _then(_$TwitterEntitiesModelImpl(
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<TwitterMediaModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TwitterEntitiesModelImpl implements _TwitterEntitiesModel {
  const _$TwitterEntitiesModelImpl(
      {required final List<TwitterMediaModel> media})
      : _media = media;

  factory _$TwitterEntitiesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TwitterEntitiesModelImplFromJson(json);

  final List<TwitterMediaModel> _media;
  @override
  List<TwitterMediaModel> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  String toString() {
    return 'TwitterEntitiesModel(media: $media)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwitterEntitiesModelImpl &&
            const DeepCollectionEquality().equals(other._media, _media));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_media));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TwitterEntitiesModelImplCopyWith<_$TwitterEntitiesModelImpl>
      get copyWith =>
          __$$TwitterEntitiesModelImplCopyWithImpl<_$TwitterEntitiesModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TwitterEntitiesModelImplToJson(
      this,
    );
  }
}

abstract class _TwitterEntitiesModel implements TwitterEntitiesModel {
  const factory _TwitterEntitiesModel(
          {required final List<TwitterMediaModel> media}) =
      _$TwitterEntitiesModelImpl;

  factory _TwitterEntitiesModel.fromJson(Map<String, dynamic> json) =
      _$TwitterEntitiesModelImpl.fromJson;

  @override
  List<TwitterMediaModel> get media;
  @override
  @JsonKey(ignore: true)
  _$$TwitterEntitiesModelImplCopyWith<_$TwitterEntitiesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TwitterMediaModel _$TwitterMediaModelFromJson(Map<String, dynamic> json) {
  return _TwitterMediaModel.fromJson(json);
}

/// @nodoc
mixin _$TwitterMediaModel {
  @JsonKey(name: 'media_url')
  String get mediaUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TwitterMediaModelCopyWith<TwitterMediaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwitterMediaModelCopyWith<$Res> {
  factory $TwitterMediaModelCopyWith(
          TwitterMediaModel value, $Res Function(TwitterMediaModel) then) =
      _$TwitterMediaModelCopyWithImpl<$Res, TwitterMediaModel>;
  @useResult
  $Res call({@JsonKey(name: 'media_url') String mediaUrl});
}

/// @nodoc
class _$TwitterMediaModelCopyWithImpl<$Res, $Val extends TwitterMediaModel>
    implements $TwitterMediaModelCopyWith<$Res> {
  _$TwitterMediaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaUrl = null,
  }) {
    return _then(_value.copyWith(
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TwitterMediaModelImplCopyWith<$Res>
    implements $TwitterMediaModelCopyWith<$Res> {
  factory _$$TwitterMediaModelImplCopyWith(_$TwitterMediaModelImpl value,
          $Res Function(_$TwitterMediaModelImpl) then) =
      __$$TwitterMediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'media_url') String mediaUrl});
}

/// @nodoc
class __$$TwitterMediaModelImplCopyWithImpl<$Res>
    extends _$TwitterMediaModelCopyWithImpl<$Res, _$TwitterMediaModelImpl>
    implements _$$TwitterMediaModelImplCopyWith<$Res> {
  __$$TwitterMediaModelImplCopyWithImpl(_$TwitterMediaModelImpl _value,
      $Res Function(_$TwitterMediaModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaUrl = null,
  }) {
    return _then(_$TwitterMediaModelImpl(
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TwitterMediaModelImpl implements _TwitterMediaModel {
  const _$TwitterMediaModelImpl(
      {@JsonKey(name: 'media_url') required this.mediaUrl});

  factory _$TwitterMediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TwitterMediaModelImplFromJson(json);

  @override
  @JsonKey(name: 'media_url')
  final String mediaUrl;

  @override
  String toString() {
    return 'TwitterMediaModel(mediaUrl: $mediaUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwitterMediaModelImpl &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, mediaUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TwitterMediaModelImplCopyWith<_$TwitterMediaModelImpl> get copyWith =>
      __$$TwitterMediaModelImplCopyWithImpl<_$TwitterMediaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TwitterMediaModelImplToJson(
      this,
    );
  }
}

abstract class _TwitterMediaModel implements TwitterMediaModel {
  const factory _TwitterMediaModel(
          {@JsonKey(name: 'media_url') required final String mediaUrl}) =
      _$TwitterMediaModelImpl;

  factory _TwitterMediaModel.fromJson(Map<String, dynamic> json) =
      _$TwitterMediaModelImpl.fromJson;

  @override
  @JsonKey(name: 'media_url')
  String get mediaUrl;
  @override
  @JsonKey(ignore: true)
  _$$TwitterMediaModelImplCopyWith<_$TwitterMediaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TwitterUserModel _$TwitterUserModelFromJson(Map<String, dynamic> json) {
  return _TwitterUserModel.fromJson(json);
}

/// @nodoc
mixin _$TwitterUserModel {
  @JsonKey(name: 'profile_image_url_https')
  String get profileImageUrl => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get screenName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TwitterUserModelCopyWith<TwitterUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwitterUserModelCopyWith<$Res> {
  factory $TwitterUserModelCopyWith(
          TwitterUserModel value, $Res Function(TwitterUserModel) then) =
      _$TwitterUserModelCopyWithImpl<$Res, TwitterUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'profile_image_url_https') String profileImageUrl,
      String name,
      String screenName});
}

/// @nodoc
class _$TwitterUserModelCopyWithImpl<$Res, $Val extends TwitterUserModel>
    implements $TwitterUserModelCopyWith<$Res> {
  _$TwitterUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileImageUrl = null,
    Object? name = null,
    Object? screenName = null,
  }) {
    return _then(_value.copyWith(
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      screenName: null == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TwitterUserModelImplCopyWith<$Res>
    implements $TwitterUserModelCopyWith<$Res> {
  factory _$$TwitterUserModelImplCopyWith(_$TwitterUserModelImpl value,
          $Res Function(_$TwitterUserModelImpl) then) =
      __$$TwitterUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'profile_image_url_https') String profileImageUrl,
      String name,
      String screenName});
}

/// @nodoc
class __$$TwitterUserModelImplCopyWithImpl<$Res>
    extends _$TwitterUserModelCopyWithImpl<$Res, _$TwitterUserModelImpl>
    implements _$$TwitterUserModelImplCopyWith<$Res> {
  __$$TwitterUserModelImplCopyWithImpl(_$TwitterUserModelImpl _value,
      $Res Function(_$TwitterUserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileImageUrl = null,
    Object? name = null,
    Object? screenName = null,
  }) {
    return _then(_$TwitterUserModelImpl(
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      screenName: null == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TwitterUserModelImpl implements _TwitterUserModel {
  const _$TwitterUserModelImpl(
      {@JsonKey(name: 'profile_image_url_https') required this.profileImageUrl,
      required this.name,
      required this.screenName});

  factory _$TwitterUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TwitterUserModelImplFromJson(json);

  @override
  @JsonKey(name: 'profile_image_url_https')
  final String profileImageUrl;
  @override
  final String name;
  @override
  final String screenName;

  @override
  String toString() {
    return 'TwitterUserModel(profileImageUrl: $profileImageUrl, name: $name, screenName: $screenName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwitterUserModelImpl &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, profileImageUrl, name, screenName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TwitterUserModelImplCopyWith<_$TwitterUserModelImpl> get copyWith =>
      __$$TwitterUserModelImplCopyWithImpl<_$TwitterUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TwitterUserModelImplToJson(
      this,
    );
  }
}

abstract class _TwitterUserModel implements TwitterUserModel {
  const factory _TwitterUserModel(
      {@JsonKey(name: 'profile_image_url_https')
      required final String profileImageUrl,
      required final String name,
      required final String screenName}) = _$TwitterUserModelImpl;

  factory _TwitterUserModel.fromJson(Map<String, dynamic> json) =
      _$TwitterUserModelImpl.fromJson;

  @override
  @JsonKey(name: 'profile_image_url_https')
  String get profileImageUrl;
  @override
  String get name;
  @override
  String get screenName;
  @override
  @JsonKey(ignore: true)
  _$$TwitterUserModelImplCopyWith<_$TwitterUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
