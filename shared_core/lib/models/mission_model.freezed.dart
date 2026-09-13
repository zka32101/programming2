// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Mission _$MissionFromJson(Map<String, dynamic> json) {
  return _Mission.fromJson(json);
}

/// @nodoc
mixin _$Mission {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get reward => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // 'weekly', 'monthly', 'special'
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<String> get completedUserIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionCopyWith<Mission> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionCopyWith<$Res> {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) then) =
      _$MissionCopyWithImpl<$Res, Mission>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int reward,
      String category,
      DateTime startDate,
      DateTime endDate,
      List<String> completedUserIds});
}

/// @nodoc
class _$MissionCopyWithImpl<$Res, $Val extends Mission>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? reward = null,
    Object? category = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? completedUserIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedUserIds: null == completedUserIds
          ? _value.completedUserIds
          : completedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionImplCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$$MissionImplCopyWith(
          _$MissionImpl value, $Res Function(_$MissionImpl) then) =
      __$$MissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int reward,
      String category,
      DateTime startDate,
      DateTime endDate,
      List<String> completedUserIds});
}

/// @nodoc
class __$$MissionImplCopyWithImpl<$Res>
    extends _$MissionCopyWithImpl<$Res, _$MissionImpl>
    implements _$$MissionImplCopyWith<$Res> {
  __$$MissionImplCopyWithImpl(
      _$MissionImpl _value, $Res Function(_$MissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? reward = null,
    Object? category = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? completedUserIds = null,
  }) {
    return _then(_$MissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedUserIds: null == completedUserIds
          ? _value._completedUserIds
          : completedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionImpl implements _Mission {
  const _$MissionImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.reward,
      required this.category,
      required this.startDate,
      required this.endDate,
      final List<String> completedUserIds = const []})
      : _completedUserIds = completedUserIds;

  factory _$MissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final int reward;
  @override
  final String category;
// 'weekly', 'monthly', 'special'
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<String> _completedUserIds;
  @override
  @JsonKey()
  List<String> get completedUserIds {
    if (_completedUserIds is EqualUnmodifiableListView)
      return _completedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedUserIds);
  }

  @override
  String toString() {
    return 'Mission(id: $id, title: $title, description: $description, reward: $reward, category: $category, startDate: $startDate, endDate: $endDate, completedUserIds: $completedUserIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._completedUserIds, _completedUserIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      reward,
      category,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_completedUserIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      __$$MissionImplCopyWithImpl<_$MissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionImplToJson(
      this,
    );
  }
}

abstract class _Mission implements Mission {
  const factory _Mission(
      {required final String id,
      required final String title,
      required final String description,
      required final int reward,
      required final String category,
      required final DateTime startDate,
      required final DateTime endDate,
      final List<String> completedUserIds}) = _$MissionImpl;

  factory _Mission.fromJson(Map<String, dynamic> json) = _$MissionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  int get reward;
  @override
  String get category;
  @override // 'weekly', 'monthly', 'special'
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  List<String> get completedUserIds;
  @override
  @JsonKey(ignore: true)
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
