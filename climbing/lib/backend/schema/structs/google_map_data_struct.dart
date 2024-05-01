// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GoogleMapDataStruct extends FFFirebaseStruct {
  GoogleMapDataStruct({
    LatLng? latLng,
    String? iconPath,
    String? title,
    String? description,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _latLng = latLng,
        _iconPath = iconPath,
        _title = title,
        _description = description,
        super(firestoreUtilData);

  // "latLng" field.
  LatLng? _latLng;
  LatLng? get latLng => _latLng;
  set latLng(LatLng? val) => _latLng = val;
  bool hasLatLng() => _latLng != null;

  // "iconPath" field.
  String? _iconPath;
  String get iconPath => _iconPath ?? '';
  set iconPath(String? val) => _iconPath = val;
  bool hasIconPath() => _iconPath != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;
  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;
  bool hasDescription() => _description != null;

  static GoogleMapDataStruct fromMap(Map<String, dynamic> data) =>
      GoogleMapDataStruct(
        latLng: data['latLng'] as LatLng?,
        iconPath: data['iconPath'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
      );

  static GoogleMapDataStruct? maybeFromMap(dynamic data) => data is Map
      ? GoogleMapDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'latLng': _latLng,
        'iconPath': _iconPath,
        'title': _title,
        'description': _description,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'latLng': serializeParam(
          _latLng,
          ParamType.LatLng,
        ),
        'iconPath': serializeParam(
          _iconPath,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
      }.withoutNulls;

  static GoogleMapDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      GoogleMapDataStruct(
        latLng: deserializeParam(
          data['latLng'],
          ParamType.LatLng,
          false,
        ),
        iconPath: deserializeParam(
          data['iconPath'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'GoogleMapDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GoogleMapDataStruct &&
        latLng == other.latLng &&
        iconPath == other.iconPath &&
        title == other.title &&
        description == other.description;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([latLng, iconPath, title, description]);
}

GoogleMapDataStruct createGoogleMapDataStruct({
  LatLng? latLng,
  String? iconPath,
  String? title,
  String? description,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GoogleMapDataStruct(
      latLng: latLng,
      iconPath: iconPath,
      title: title,
      description: description,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

GoogleMapDataStruct? updateGoogleMapDataStruct(
  GoogleMapDataStruct? googleMapData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    googleMapData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addGoogleMapDataStructData(
  Map<String, dynamic> firestoreData,
  GoogleMapDataStruct? googleMapData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (googleMapData == null) {
    return;
  }
  if (googleMapData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && googleMapData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final googleMapDataData =
      getGoogleMapDataFirestoreData(googleMapData, forFieldValue);
  final nestedData =
      googleMapDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = googleMapData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getGoogleMapDataFirestoreData(
  GoogleMapDataStruct? googleMapData, [
  bool forFieldValue = false,
]) {
  if (googleMapData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(googleMapData.toMap());

  // Add any Firestore field values
  googleMapData.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGoogleMapDataListFirestoreData(
  List<GoogleMapDataStruct>? googleMapDatas,
) =>
    googleMapDatas
        ?.map((e) => getGoogleMapDataFirestoreData(e, true))
        .toList() ??
    [];
