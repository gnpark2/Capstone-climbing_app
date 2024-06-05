import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import 'package:exif/exif.dart';
import '/flutter_flow/upload_data.dart';

import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

// parameter : PlatformFile
import 'package:file_picker/file_picker.dart';


Future<LatLng?> getLatLng(PlatformFile file) async {
    // 이미지 파일에서 Exif 데이터 가져오기
    final Uint8List bytes = await file.bytes!;
    final exifData = await readExifFromBytes(bytes);

    // Exif 데이터에서 GPS 정보 가져오기
    if (exifData != null && exifData.containsKey('GPS GPSLatitude') && exifData.containsKey('GPS GPSLongitude')) {
      final gpsLatitude = exifData['GPS GPSLatitude'] as IfdTag;
      final gpsLongitude = exifData['GPS GPSLongitude'] as IfdTag;

      // 경도 및 위도를 double 값으로 변환
      final latitude = _extractGpsCoordinate(gpsLatitude);
      final longitude = _extractGpsCoordinate(gpsLongitude);

      if (latitude != null && longitude != null) {
        return LatLng(latitude, longitude);
      }
    }
  
  return null; // GPS 정보를 찾을 수 없는 경우 null 반환
}

double? _extractGpsCoordinate(IfdTag coord) {
  final IfdValues? values = coord.values;
  if (values == null || values.length == 0) return null;
  
  final List<Ratio> ratioList = values.toList() as List<Ratio>;
  if (ratioList.length < 3) return null;
  
  final List<int> intList = ratioList.map((ratio) => ratio.numerator ~/ ratio.denominator).toList();
  final degrees = intList[0] + intList[1] / 60.0 + intList[2] / 3600.0;
  return degrees;
}