import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _SavedPost = prefs
              .getStringList('ff_SavedPost')
              ?.map((path) => path.ref)
              .toList() ??
          _SavedPost;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<DocumentReference> _SavedPost = [];
  List<DocumentReference> get SavedPost => _SavedPost;
  set SavedPost(List<DocumentReference> value) {
    _SavedPost = value;
    prefs.setStringList('ff_SavedPost', value.map((x) => x.path).toList());
  }

  void addToSavedPost(DocumentReference value) {
    _SavedPost.add(value);
    prefs.setStringList('ff_SavedPost', _SavedPost.map((x) => x.path).toList());
  }

  void removeFromSavedPost(DocumentReference value) {
    _SavedPost.remove(value);
    prefs.setStringList('ff_SavedPost', _SavedPost.map((x) => x.path).toList());
  }

  void removeAtIndexFromSavedPost(int index) {
    _SavedPost.removeAt(index);
    prefs.setStringList('ff_SavedPost', _SavedPost.map((x) => x.path).toList());
  }

  void updateSavedPostAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    _SavedPost[index] = updateFn(_SavedPost[index]);
    prefs.setStringList('ff_SavedPost', _SavedPost.map((x) => x.path).toList());
  }

  void insertAtIndexInSavedPost(int index, DocumentReference value) {
    _SavedPost.insert(index, value);
    prefs.setStringList('ff_SavedPost', _SavedPost.map((x) => x.path).toList());
  }

  List<GoogleMapDataStruct> _googleMapData = [
    GoogleMapDataStruct.fromSerializableMap(jsonDecode(
        '{\"latLng\":\"36,-115\",\"iconPath\":\"https://picsum.photos/seed/459/600\",\"title\":\"first\",\"discription\":\"test one\"}')),
    GoogleMapDataStruct.fromSerializableMap(jsonDecode(
        '{\"latLng\":\"36,-116\",\"iconPath\":\"https://picsum.photos/seed/451/600\",\"title\":\"test2\",\"discription\":\"test two\"}'))
  ];
  List<GoogleMapDataStruct> get googleMapData => _googleMapData;
  set googleMapData(List<GoogleMapDataStruct> value) {
    _googleMapData = value;
  }

  void addToGoogleMapData(GoogleMapDataStruct value) {
    _googleMapData.add(value);
  }

  void removeFromGoogleMapData(GoogleMapDataStruct value) {
    _googleMapData.remove(value);
  }

  void removeAtIndexFromGoogleMapData(int index) {
    _googleMapData.removeAt(index);
  }

  void updateGoogleMapDataAtIndex(
    int index,
    GoogleMapDataStruct Function(GoogleMapDataStruct) updateFn,
  ) {
    _googleMapData[index] = updateFn(_googleMapData[index]);
  }

  void insertAtIndexInGoogleMapData(int index, GoogleMapDataStruct value) {
    _googleMapData.insert(index, value);
  }

  final _userDocQueryManager = FutureRequestManager<UsersRecord>();
  Future<UsersRecord> userDocQuery({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<UsersRecord> Function() requestFn,
  }) =>
      _userDocQueryManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUserDocQueryCache() => _userDocQueryManager.clear();
  void clearUserDocQueryCacheKey(String? uniqueKey) =>
      _userDocQueryManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
