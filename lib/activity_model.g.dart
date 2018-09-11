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
    ..selectedColor = json['selectedColor'] == null
        ? null
        : _colorFromInt(json['selectedColor'] as int)
    ..template = json['template'] as String
    ..popped = _$enumDecodeNullable(_$PoppedEnumMap, json['popped'])
    ..isDrawing = json['isDrawing'] as bool
    ..isInteractive = json['isInteractive'] as bool
    ..unMaskImagePath = json['unMaskImagePath'] as String;
}

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'things': instance.things,
      'pathHistory': instance.pathHistory,
      'selectedColor': instance.selectedColor == null
          ? null
          : _intFromColor(instance.selectedColor),
      'id': instance.id,
      'template': instance.template,
      'popped': _$PoppedEnumMap[instance.popped],
      'isDrawing': instance.isDrawing,
      'isInteractive': instance.isInteractive,
      'unMaskImagePath': instance.unMaskImagePath
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

const _$PoppedEnumMap = <Popped, dynamic>{
  Popped.top: 'top',
  Popped.bottom: 'bottom',
  Popped.noPopup: 'noPopup'
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
      points: (json['points'] as List)
          ?.map((e) => (e as num)?.toDouble())
          ?.toList(),
      paintOption:
          _$enumDecodeNullable(_$PaintOptionEnumMap, json['paintOption']),
      blurStyle: json['blurStyle'] == null
          ? null
          : _blurStyleFromInt(json['blurStyle'] as int),
      sigma: (json['sigma'] as num)?.toDouble(),
      thickness: (json['thickness'] as num)?.toDouble(),
      color:
          json['color'] == null ? null : _colorFromInt(json['color'] as int));
}

Map<String, dynamic> _$PathInfoToJson(PathInfo instance) => <String, dynamic>{
      'points': instance.points,
      'paintOption': _$PaintOptionEnumMap[instance.paintOption],
      'blurStyle': instance.blurStyle == null
          ? null
          : _intFromBlurStyle(instance.blurStyle),
      'sigma': instance.sigma,
      'thickness': instance.thickness,
      'color': instance.color == null ? null : _intFromColor(instance.color)
    };

const _$PaintOptionEnumMap = <PaintOption, dynamic>{
  PaintOption.paint: 'paint',
  PaintOption.erase: 'erase',
  PaintOption.unMask: 'unMask'
};
