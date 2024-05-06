// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:ui';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
import '/flutter_flow/lat_lng.dart' as latlng;
import 'dart:async';
export 'dart:async' show Completer;
export 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
export '/flutter_flow/lat_lng.dart' show LatLng;

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

class MarkedMapWidget extends StatefulWidget {
  const MarkedMapWidget({
    Key? key,
    this.width,
    this.height,
    this.mapData,
    this.allowZoom = true,
    this.showZoomControls = true,
    this.showLocation = true,
    this.showCompass = false,
    this.showMapToolbar = false,
    this.showTraffic = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<GoogleMapDataStruct>? mapData;
  final bool allowZoom;
  final bool showZoomControls;
  final bool showLocation;
  final bool showCompass;
  final bool showMapToolbar;
  final bool showTraffic;

  @override
  _MarkedMapWidgetState createState() => _MarkedMapWidgetState();
}

class _MarkedMapWidgetState extends State<MarkedMapWidget> {
  final Completer<google_maps_flutter.GoogleMapController> _controller =
      Completer();
  final Map<String, google_maps_flutter.BitmapDescriptor> _customIcons = {};
  Set<google_maps_flutter.Marker> _markers = {};

  late google_maps_flutter.LatLng _center;

  @override
  void initState() {
    super.initState();
    //
    _getCurrentLocation();
    //
    _loadMarkerIcons();
  }

  //
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _center = google_maps_flutter.LatLng(
        position.latitude,
        position.longitude,
      );
    });
  }

  //

  Future<void> _loadMarkerIcons() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> userSnapshot
        in snapshot.docs) {
      QuerySnapshot<Map<String, dynamic>> postSnapshot =
          await userSnapshot.reference.collection('post').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> postDoc
          in postSnapshot.docs) {
        String imagePath = postDoc.data()['post_photo'];

        if (imagePath.isNotEmpty) {
          if (imagePath.contains("https")) {
            Uint8List? imageData = await loadNetworkImage(imagePath);
            if (imageData != null) {
              google_maps_flutter.BitmapDescriptor descriptor =
                  google_maps_flutter.BitmapDescriptor.fromBytes(imageData);
              _customIcons[imagePath] = descriptor;
            }
          } else {
            google_maps_flutter.BitmapDescriptor descriptor =
                await google_maps_flutter.BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(devicePixelRatio: 2.5),
              "assets/images/$imagePath",
            );
            _customIcons[imagePath] = descriptor;
          }
        }
      }
    }

    _updateMarkers(); // Update markers once icons are loaded
  }

  Future<Uint8List?> loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(ImageStreamListener(
        (ImageInfo info, bool _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData =
        await imageInfo.image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  void _updateMarkers() {
    setState(() {
      _markers = _createMarkers();
    });
  }

  void _onMapCreated(google_maps_flutter.GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: google_maps_flutter.GoogleMap(
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: widget.allowZoom,
        zoomControlsEnabled: widget.showZoomControls,
        myLocationEnabled: widget.showLocation,
        compassEnabled: widget.showCompass,
        mapToolbarEnabled: widget.showMapToolbar,
        trafficEnabled: widget.showTraffic,
        initialCameraPosition: google_maps_flutter.CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }

  Set<google_maps_flutter.Marker> _createMarkers() {
    var tmp = <google_maps_flutter.Marker>{};

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> userSnapshot
          in snapshot.docs) {
        userSnapshot.reference
            .collection('post')
            .get()
            .then((QuerySnapshot<Map<String, dynamic>> postSnapshot) {
          for (QueryDocumentSnapshot<Map<String, dynamic>> postDoc
              in postSnapshot.docs) {
            String imagePath = postDoc.data()['post_photo'];
            double latitude = postDoc.data()['latitude'];
            double longitude = postDoc.data()['longitude'];

            if (latitude != null && longitude != null) {
              google_maps_flutter.LatLng googleMapsLatLng =
                  google_maps_flutter.LatLng(latitude, longitude);

              google_maps_flutter.BitmapDescriptor icon =
                  _customIcons[imagePath] ??
                      google_maps_flutter.BitmapDescriptor.defaultMarker;

              final google_maps_flutter.Marker marker =
                  google_maps_flutter.Marker(
                markerId: google_maps_flutter.MarkerId(imagePath),
                position: googleMapsLatLng,
                icon: icon,
                infoWindow: google_maps_flutter.InfoWindow(
                  title: imagePath,
                  snippet: 'Location: $latitude, $longitude',
                ),
              );

              tmp.add(marker);
            }
          }
        });
      }
    });

    return tmp;
  }
}
