// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) {
  return ActivityModel(
      pathHistory: json['pathHistory'] == null
          ? null
          : PathHistory.fromJson(json['pathHistory'] as Map<String, dynamic>),
      id: json['id'] as String)
    ..things = (json['things'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList()
    ..template = json['template'] as String;
}

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'things': instance.things,
      'pathHistory': instance.pathHistory,
      'id': instance.id,
      'template': instance.template
    };

PathHistory _$PathHistoryFromJson(Map<String, dynamic> json) {
  return PathHistory()
    ..paths = (json['paths'] as List)
        ?.map((e) =>
            e == null ? null : PathInfo.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PathHistoryToJson(PathHistory instance) =>
    <String, dynamic>{'paths': instance.paths};

PathInfo _$PathInfoFromJson(Map<String, dynamic> json) {
  return PathInfo(
      paint: json['paint'] == null
          ? null
          : _paintFromMap(json['paint'] as Map<String, dynamic>),
      points: (json['points'] as List)
          ?.map((e) => (e as num)?.toDouble())
          ?.toList());
}

Map<String, dynamic> _$PathInfoToJson(PathInfo instance) => <String, dynamic>{
      'paint': instance.paint == null ? null : _paintToMap(instance.paint),
      'points': instance.points
    };
