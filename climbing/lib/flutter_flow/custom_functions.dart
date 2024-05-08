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
/*
Future<LatLng?> getLatLng(var uploadedFileUrl) async {
  // Download the image using http package
  final response = await http.get(Uri.parse(uploadedFileUrl));
  if (response.statusCode == 200) {
    final imageBytes = response.bodyBytes;

    // Extract EXIF data from the image bytes
    final exifData = await readExifFromBytes(imageBytes);

    // Check if the image contains GPS information
    if (exifData.containsKey('GPS GPSLatitude') && exifData.containsKey('GPS GPSLongitude')) {
      final gpsData = exifData;

      // Extract latitude and longitude values
      final latitudeRef = gpsData['GPS GPSLatitudeRef']?.toString();
      final latitudeComponents = gpsData['GPS GPSLatitude'] as List<dynamic>?;
      final longitudeRef = gpsData['GPS GPSLongitudeRef']?.toString();
      final longitudeComponents = gpsData['GPS GPSLongitude'] as List<dynamic>?;

      if (latitudeRef != null &&
          latitudeComponents != null &&
          longitudeRef != null &&
          longitudeComponents != null) {
        final latitude = _convertCoordinates(latitudeComponents);
        final longitude = _convertCoordinates(longitudeComponents);

        // Determine the sign of latitude and longitude based on reference values
        final latLng = LatLng(
          latitudeRef == 'N' ? latitude : -latitude,
          longitudeRef == 'E' ? longitude : -longitude,
        );

        return latLng;
      }
    }
  }

  return null; // Return null if GPS information is not available
}
*/

/*
Future<LatLng?> getLatLng(SelectedFile selectedMedia) async {
  // 이미지 데이터 바이트에서 직접 EXIF 데이터 추출
  final exifData = await readExifFromBytes(selectedMedia.bytes!);

  print(exifData);

  // Check if the image contains GPS information
  if (exifData.containsKey('GPS GPSLatitude') && exifData.containsKey('GPS GPSLongitude')) {
    final gpsData = exifData;

    // Extract latitude and longitude values
    final latitudeRef = gpsData['GPS GPSLatitudeRef']?.toString();
    final latitudeComponents = gpsData['GPS GPSLatitude'] as List<dynamic>?;
    final longitudeRef = gpsData['GPS GPSLongitudeRef']?.toString();
    final longitudeComponents = gpsData['GPS GPSLongitude'] as List<dynamic>?;

    if (latitudeRef != null &&
        latitudeComponents != null &&
        longitudeRef != null &&
        longitudeComponents != null) {
      final latitude = _convertCoordinates(latitudeComponents);
      final longitude = _convertCoordinates(longitudeComponents);

      // Determine the sign of latitude and longitude based on reference values
      final latLng = LatLng(
        latitudeRef == 'N' ? latitude : -latitude,
        longitudeRef == 'E' ? longitude : -longitude,
      );

      return latLng;
    }
  }

  return null; // Return null if GPS information is not available
}

double _convertCoordinates(List<dynamic> components) {
  final degrees = (components[0] as num).toDouble();
  final minutes = (components[1] as num).toDouble();
  final seconds = (components[2] as num).toDouble();

  return degrees + (minutes / 60) + (seconds / 3600);
}
*/











// parameter : SelectedFile
/*
Future<LatLng?> getLatLng(SelectedFile selectedMedia) async {
  // 이미지 데이터 바이트에서 직접 EXIF 데이터 추출
  final exifData = await readExifFromBytes(selectedMedia.bytes!);

  print(exifData);

  // Check if the image contains GPS information
  if (exifData.containsKey('GPS GPSLatitude') && exifData.containsKey('GPS GPSLongitude')) {
    final gpsData = exifData;

    // Extract latitude and longitude values
    final latitudeRef = gpsData['GPS GPSLatitudeRef']?.toString();
    final latitudeComponents = gpsData['GPS GPSLatitude']?.printable;
    final longitudeRef = gpsData['GPS GPSLongitudeRef']?.toString();
    final longitudeComponents = gpsData['GPS GPSLongitude']?.printable;

    if (latitudeRef != null &&
        latitudeComponents != null &&
        longitudeRef != null &&
        longitudeComponents != null) {
      final latitude = parseCoordinates(latitudeComponents);
      final longitude = parseCoordinates(longitudeComponents);

      // Determine the sign of latitude and longitude based on reference values
      final latLng = LatLng(
        latitudeRef == 'N' ? latitude : -latitude,
        longitudeRef == 'E' ? longitude : -longitude,
      );

      return latLng;
    }
  }

  return null; // Return null if GPS information is not available
}

double _convertCoordinates(List<dynamic> components) {
  final degrees = (components[0] as num).toDouble();
  final minutes = (components[1] as num).toDouble();
  final seconds = (components[2] as num).toDouble();

  return degrees + (minutes / 60) + (seconds / 3600);
}

double parseCoordinates(String? coordinateString) {
  if (coordinateString == null) {
    return 0.0;
  }
  // 'degrees, minutes, seconds' 형식의 문자열을 파싱
  coordinateString = coordinateString.replaceAll(RegExp(r'[\[\]\s]'), '');
  var parts = coordinateString.split(',');
  
  // 안전하게 배열의 길이를 확인
  if (parts.length < 3) {
    return 0.0; // 적절한 에러 처리나 기본값 반환
  }

  try {
    double degrees = double.parse(parts[0]);
    double minutes = double.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    // 실수형 좌표 값으로 변환
    return degrees + (minutes / 60) + (seconds / 3600);
  } catch (e) {
    // 파싱 도중 오류가 발생하면, 오류 처리
    print('좌표 파싱 중 오류 발생: $e');
    return 0.0;
  }
}
*/




// parameter : XFile
/*
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<LatLng?> getLatLng(XFile selectedMedia) async {
  // 이미지 데이터 바이트에서 직접 EXIF 데이터 추출
  final exifData = await readExifFromBytes(await selectedMedia.readAsBytes());

  print(exifData);

  // Check if the image contains GPS information
  if (exifData.containsKey('GPS GPSLatitude') && exifData.containsKey('GPS GPSLongitude')) {
    final gpsData = exifData;

    // Extract latitude and longitude values
    final latitudeRef = gpsData['GPS GPSLatitudeRef']?.toString();
    final latitudeComponents = gpsData['GPS GPSLatitude']?.printable;
    final longitudeRef = gpsData['GPS GPSLongitudeRef']?.toString();
    final longitudeComponents = gpsData['GPS GPSLongitude']?.printable;

    if (latitudeRef != null &&
        latitudeComponents != null &&
        longitudeRef != null &&
        longitudeComponents != null) {
      final latitude = parseCoordinates(latitudeComponents);
      final longitude = parseCoordinates(longitudeComponents);

      // Determine the sign of latitude and longitude based on reference values
      final latLng = LatLng(
        latitudeRef == 'N' ? latitude : -latitude,
        longitudeRef == 'E' ? longitude : -longitude,
      );

      return latLng;
    }
  }

  return null; // Return null if GPS information is not available
}

double parseCoordinates(String? coordinateString) {
  if (coordinateString == null) {
    return 0.0;
  }
  // 'degrees, minutes, seconds' 형식의 문자열을 파싱
  coordinateString = coordinateString.replaceAll(RegExp(r'[\[\]\s]'), '');
  var parts = coordinateString.split(',');
  
  // 안전하게 배열의 길이를 확인
  if (parts.length < 3) {
    return 0.0; // 적절한 에러 처리나 기본값 반환
  }

  try {
    double degrees = double.parse(parts[0]);
    double minutes = double.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    // 실수형 좌표 값으로 변환
    return degrees + (minutes / 60) + (seconds / 3600);
  } catch (e) {
    // 파싱 도중 오류가 발생하면, 오류 처리
    print('좌표 파싱 중 오류 발생: $e');
    return 0.0;
  }
}
*/






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