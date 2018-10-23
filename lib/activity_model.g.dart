// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaintData _$PaintDataFromJson(Map<String, dynamic> json) {
  return PaintData(
      id: json['id'] as String,
      things: (json['things'] as List)
          ?.map((e) => e as Map<String, dynamic>)
          ?.toList(),
      template: json['template'] as String,
      pathHistory: json['pathHistory'] == null
          ? null
          : PathHistory.fromJson(json['pathHistory'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PaintDataToJson(PaintData instance) => <String, dynamic>{
      'id': instance.id,
      'things': instance.things,
      'template': instance.template,
      'pathHistory': instance.pathHistory
    };

PathHistory _$PathHistoryFromJson(Map<String, dynamic> json) {
  return PathHistory()
    ..paths = (json['paths'] as List)
        ?.map((e) =>
            e == null ? null : PathInfo.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..startX = (json['startX'] as num)?.toDouble()
    ..startY = (json['startY'] as num)?.toDouble()
    ..x = (json['x'] as num)?.toDouble()
    ..y = (json['y'] as num)?.toDouble();
}

Map<String, dynamic> _$PathHistoryToJson(PathHistory instance) =>
    <String, dynamic>{
      'paths': instance.paths,
      'startX': instance.startX,
      'startY': instance.startY,
      'x': instance.x,
      'y': instance.y
    };

PathInfo _$PathInfoFromJson(Map<String, dynamic> json) {
  return PathInfo(
      points: (json['points'] as List)?.map((e) => e as int)?.toList(),
      paintOption:
          _$enumDecodeNullable(_$PaintOptionEnumMap, json['paintOption']),
      blurStyle: json['blurStyle'] == null
          ? null
          : _blurStyleFromInt(json['blurStyle'] as int),
      sigma: (json['sigma'] as num)?.toDouble(),
      thickness: (json['thickness'] as num)?.toDouble(),
      color: json['color'] == null ? null : _colorFromInt(json['color'] as int),
      maskImage: json['maskImage'] as String);
}

Map<String, dynamic> _$PathInfoToJson(PathInfo instance) => <String, dynamic>{
      'points': instance.points,
      'paintOption': _$PaintOptionEnumMap[instance.paintOption],
      'blurStyle': instance.blurStyle == null
          ? null
          : _intFromBlurStyle(instance.blurStyle),
      'sigma': instance.sigma,
      'maskImage': instance.maskImage,
      'thickness': instance.thickness,
      'color': instance.color == null ? null : _intFromColor(instance.color)
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$PaintOptionEnumMap = <PaintOption, dynamic>{
  PaintOption.paint: 'paint',
  PaintOption.erase: 'erase',
  PaintOption.masking: 'masking'
};
