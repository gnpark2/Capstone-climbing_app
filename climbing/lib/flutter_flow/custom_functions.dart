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