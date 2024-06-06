import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'lat_lng.dart' as latlng;

export 'dart:async' show Completer;
export 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
export 'lat_lng.dart' show LatLng;

enum GoogleMapStyle {
  standard,
  silver,
  retro,
  dark,
  night,
  aubergine,
}

enum GoogleMarkerColor {
  red,
  orange,
  yellow,
  green,
  cyan,
  azure,
  blue,
  violet,
  magenta,
  rose,
}

@immutable
class MarkerImage {
  const MarkerImage({
    required this.imagePath,
    required this.isAssetImage,
    this.size = 20.0,
  });
  final String imagePath;
  final bool isAssetImage;
  final double size;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarkerImage &&
          imagePath == other.imagePath &&
          isAssetImage == other.isAssetImage &&
          size == other.size);

  @override
  int get hashCode => Object.hash(imagePath, isAssetImage, size);
}

class FlutterFlowMarker implements ClusterItem{
  const FlutterFlowMarker(this.markerId, this.markerLocation, this.imageUrl, [this.gpsDirection, this.timePosted, this.onTap] );
  final String markerId;
  final latlng.LatLng markerLocation;
  final String imageUrl;
  final double? gpsDirection;
  final DateTime? timePosted;
  final Future Function()? onTap;

  @override
  LatLng get location => markerLocation.toGoogleMaps();

  @override
  String toString() => '여기요 여기 $markerId';

  @override
  String get geohash => Geohash.encode(markerLocation.toGoogleMaps(), codeLength: ClusterManager.precision);
}

class FlutterFlowGoogleMap extends StatefulWidget {
  const FlutterFlowGoogleMap({
    required this.controller,
    this.clusterDifference,
    this.clusteredMarker,
    this.onCameraIdle,
    this.initialLocation,
    this.markers = const [],
    this.markerColor = GoogleMarkerColor.red,
    this.markerImage,
    this.mapType = MapType.normal,
    this.style = GoogleMapStyle.standard,
    this.initialZoom = 12,
    this.allowInteraction = true,
    this.allowZoom = true,
    this.showZoomControls = true,
    this.showLocation = true,
    this.showCompass = false,
    this.showMapToolbar = false,
    this.showTraffic = false,
    this.centerMapOnMarkerTap = false,
    super.key,
  });

  final Completer<GoogleMapController> controller;
  final void Function(String clusterDiff)? clusterDifference;
  final void Function(Iterable<FlutterFlowMarker> clusteredMark)? clusteredMarker;
  final Function(latlng.LatLng)? onCameraIdle;
  final latlng.LatLng? initialLocation;
  final Iterable<FlutterFlowMarker> markers;
  final GoogleMarkerColor markerColor;
  final MarkerImage? markerImage;
  final MapType mapType;
  final GoogleMapStyle style;
  final double initialZoom;
  final bool allowInteraction;
  final bool allowZoom;
  final bool showZoomControls;
  final bool showLocation;
  final bool showCompass;
  final bool showMapToolbar;
  final bool showTraffic;
  final bool centerMapOnMarkerTap;

  @override
  State<StatefulWidget> createState() => _FlutterFlowGoogleMapState();
}

class _FlutterFlowGoogleMapState extends State<FlutterFlowGoogleMap> {
  Set<Marker> markers = {};
  late Completer<GoogleMapController> _controller;
  BitmapDescriptor? _markerDescriptor;
  late LatLng currentMapCenter;
  late ClusterManager<FlutterFlowMarker> _clusterManager;

  final Map<String, BitmapDescriptor> _iconCache = {};

  double get initialZoom => max(double.minPositive, widget.initialZoom);
  LatLng get initialPosition =>
      widget.initialLocation?.toGoogleMaps() ?? const LatLng(0.0, 0.0);

  void initializeMarkerBitmap() {
    final markerImage = widget.markerImage;

    if (markerImage == null) {
      _markerDescriptor = BitmapDescriptor.defaultMarkerWithHue(
        googleMarkerColorMap[widget.markerColor]!,
      );
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final markerImageSize = Size.square(markerImage.size);
      var imageProvider = markerImage.isAssetImage
          ? Image.asset(markerImage.imagePath).image
          : CachedNetworkImageProvider(markerImage.imagePath);
      if (!kIsWeb) {
        final targetHeight =
            (markerImage.size * MediaQuery.of(context).devicePixelRatio)
                .toInt();
        imageProvider = ResizeImage(
          imageProvider,
          height: targetHeight,
          policy: ResizeImagePolicy.fit,
          allowUpscaling: true,
        );
      }
      final imageConfiguration =
          createLocalImageConfiguration(context, size: markerImageSize);
      imageProvider
          .resolve(imageConfiguration)
          .addListener(ImageStreamListener((img, _) async {
        final bytes = await img.image.toByteData(format: ImageByteFormat.png);
        if (bytes != null && mounted) {
          _markerDescriptor = BitmapDescriptor.fromBytes(
            bytes.buffer.asUint8List(),
            size: markerImageSize,
          );
          setState(() {});
        }
      }));
    });
  }

  void onCameraIdle() => widget.onCameraIdle?.call(currentMapCenter.toLatLng());

  @override
  void initState() {
    super.initState();
    currentMapCenter = initialPosition;
    _controller = widget.controller;
    initializeMarkerBitmap();
    _clusterManager = _initClusterManager();
  }

  ClusterManager<FlutterFlowMarker> _initClusterManager() {
    return ClusterManager<FlutterFlowMarker>(
      widget.markers.toList(),
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  Future<Uint8List> combineImages(Uint8List baseImageBytes, Uint8List arrowImageBytes, double direction) async {
  final baseImage = await decodeImageFromList(baseImageBytes);
  final arrowImage = await decodeImageFromList(arrowImageBytes);

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  final baseRect = Rect.fromLTWH(0, 0, baseImage.width.toDouble(), baseImage.height.toDouble());
  final arrowRect = Rect.fromLTWH(0, 0, arrowImage.width.toDouble(), arrowImage.height.toDouble());

  // Draw the base image
  canvas.drawImage(baseImage, Offset.zero, Paint());

  // Rotate and draw the arrow image
  canvas.save();
  canvas.translate(baseImage.width / 2, baseImage.height / 2);
  canvas.rotate(direction * (3.1415926535897932 / 180)); // Convert degrees to radians
  canvas.translate(-arrowImage.width / 2, -arrowImage.height / 2);
  canvas.drawImage(arrowImage, Offset.zero, Paint());
  canvas.restore();

  final picture = recorder.endRecording();
  final img = await picture.toImage(baseImage.width, baseImage.height);
  final byteData = await img.toByteData(format: ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}
  
  void _updateMarkers(Set<Marker> newMarkers) {
    if (mounted) {
    setState(() {
      markers = newMarkers;
      _clusterManager.setItems(widget.markers.toList());
    });
    } else {
      return;
    }
  }

  Future<Marker> Function(Cluster<FlutterFlowMarker>) get _markerBuilder =>
      (cluster) async {
        //clustering이거나 direction이 없으면 화살표 없는 함수를, single direction이면 화살표 추가 함수 호출
        final latestPost = cluster.items.reduce((a, b) =>
            a.timePosted!.isAfter(b.timePosted!) ? a : b);
        final markerImage = latestPost.imageUrl;
        final direction = latestPost.gpsDirection;
        final newIcon = direction == 1000 || cluster.isMultiple
        ? await createMarkerFromUrl(context, markerImage)
        : await createMarkerWithArrow(context, markerImage, direction!);
        
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            if (widget.centerMapOnMarkerTap) {
              final controller = await _controller.future;
              await controller.animateCamera(
                CameraUpdate.newLatLng(cluster.location),
              );
              currentMapCenter = cluster.location;
              onCameraIdle();
            }
            if (cluster.isMultiple) {
              widget.clusterDifference!("clustering");
              widget.clusteredMarker!(cluster.items);
            } else {
              widget.clusterDifference!("notClustering");
            }
            await cluster.items.first.onTap?.call();
          },
          icon: newIcon ?? BitmapDescriptor.defaultMarker,
        );
      };


  Future<BitmapDescriptor?> createMarkerFromUrl(BuildContext context, String imageUrl, {double size = 50.0}) async {
  final cacheKey = 'no_arrow_$imageUrl';
  
  if (_iconCache.containsKey(cacheKey)) {
    return _iconCache[cacheKey];
  }

  final imageProvider = CachedNetworkImageProvider(imageUrl);

  final targetHeight = (size * MediaQuery.of(context).devicePixelRatio).toInt();
  final resizedImageProvider = ResizeImage(
    imageProvider,
    height: targetHeight,
    policy: ResizeImagePolicy.fit,
    allowUpscaling: true,
  );

  final imageConfiguration = createLocalImageConfiguration(context, size: Size.square(size));
  final Completer<BitmapDescriptor> completer = Completer();

  resizedImageProvider.resolve(imageConfiguration).addListener(
    ImageStreamListener((ImageInfo img, bool synchronousCall) async {
      final ByteData? bytes = await img.image.toByteData(format: ImageByteFormat.png);
      if (bytes != null) {
        final BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
        _iconCache[cacheKey] = bitmapDescriptor; // Cache the image with no arrow
        completer.complete(bitmapDescriptor);
      } else {
        completer.completeError('Failed to convert image to ByteData');
      }
    }),
  );

  return completer.future;
}

Future<BitmapDescriptor?> createMarkerWithArrow(BuildContext context, String imageUrl, double direction, {double size = 50.0}) async {
  final cacheKey = 'arrow_$direction\_$imageUrl';
  
  if (_iconCache.containsKey(cacheKey)) {
    return _iconCache[cacheKey];
  }

  final baseImageProvider = CachedNetworkImageProvider(imageUrl);
  final arrowImageProvider = AssetImage('assets/images/arrow.png'); // 화살표 이미지 경로

  final targetHeight = (size * MediaQuery.of(context).devicePixelRatio).toInt();
  final baseResizedImageProvider = ResizeImage(
    baseImageProvider,
    height: targetHeight,
    policy: ResizeImagePolicy.fit,
    allowUpscaling: true,
  );
  final arrowResizedImageProvider = ResizeImage(
    arrowImageProvider,
    height: targetHeight,
    policy: ResizeImagePolicy.fit,
    allowUpscaling: true,
  );

  final baseImageConfiguration = createLocalImageConfiguration(context, size: Size.square(size));
  final arrowImageConfiguration = createLocalImageConfiguration(context, size: Size.square(size));

  final Completer<BitmapDescriptor> completer = Completer();

  baseResizedImageProvider.resolve(baseImageConfiguration).addListener(
    ImageStreamListener((ImageInfo baseImg, bool synchronousCall) async {
      final ByteData? baseBytes = await baseImg.image.toByteData(format: ImageByteFormat.png);
      arrowResizedImageProvider.resolve(arrowImageConfiguration).addListener(
        ImageStreamListener((ImageInfo arrowImg, bool synchronousCall) async {
          final ByteData? arrowBytes = await arrowImg.image.toByteData(format: ImageByteFormat.png);
          if (baseBytes != null && arrowBytes != null) {
            final combinedBytes = await combineImages(baseBytes.buffer.asUint8List(), arrowBytes.buffer.asUint8List(), direction);
            final BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(combinedBytes);
            _iconCache[cacheKey] = bitmapDescriptor; // Cache the combined image
            completer.complete(bitmapDescriptor);
          } else {
            completer.completeError('Failed to convert image to ByteData');
          }
        }),
      );
    }),
  );

  return completer.future;
}

  @override
  void didUpdateWidget(FlutterFlowGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.markerImage != oldWidget.markerImage) {
      initializeMarkerBitmap();
      setState(() {});
    }
    if (widget.markers != oldWidget.markers) {
      _clusterManager.setItems(widget.markers.toList());
    }
  }

  @override
  Widget build(BuildContext context) => AbsorbPointer(
        absorbing: !widget.allowInteraction,
        child: GoogleMap(
          onMapCreated: (controller) async {
            _controller.complete(controller);
            await controller.setMapStyle(googleMapStyleStrings[widget.style]);
            _clusterManager.setMapId(controller.mapId);
          },
          onCameraIdle: onCameraIdle,
          onCameraMove: _clusterManager.onCameraMove,
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: initialZoom,
          ),
          mapType: widget.mapType,
          zoomGesturesEnabled: widget.allowZoom,
          zoomControlsEnabled: widget.showZoomControls,
          myLocationEnabled: widget.showLocation,
          compassEnabled: widget.showCompass,
          mapToolbarEnabled: widget.showMapToolbar,
          trafficEnabled: widget.showTraffic,
          markers: markers,
        ),
      );

  @override
  void dispose() {
    _controller.future.then((controller) {
      controller.dispose();
        }).catchError((_) {});
    super.dispose();
  }
}

extension ToGoogleMapsLatLng on latlng.LatLng {
  LatLng toGoogleMaps() => LatLng(latitude, longitude);
}

extension GoogleMapsToLatLng on LatLng {
  latlng.LatLng toLatLng() => latlng.LatLng(latitude, longitude);
}

Map<GoogleMapStyle, String> googleMapStyleStrings = {
  GoogleMapStyle.standard: '[]',
  GoogleMapStyle.silver:
      r'[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]',
  GoogleMapStyle.retro:
      r'[{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#e9bc62"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]',
  GoogleMapStyle.dark:
      r'[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]',
  GoogleMapStyle.night:
      r'[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]',
  GoogleMapStyle.aubergine:
      r'[{"elementType":"geometry","stylers":[{"color":"#1d2c4d"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#1a3646"}]},{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"color":"#4b6878"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#64779e"}]},{"featureType":"administrative.province","elementType":"geometry.stroke","stylers":[{"color":"#4b6878"}]},{"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"color":"#334e87"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#023e58"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#283d6a"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#6f9ba5"}]},{"featureType":"poi","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#023e58"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#3C7680"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#304a7d"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#98a5be"}]},{"featureType":"road","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#2c6675"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#255763"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#b0d5ce"}]},{"featureType":"road.highway","elementType":"labels.text.stroke","stylers":[{"color":"#023e58"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#98a5be"}]},{"featureType":"transit","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"transit.line","elementType":"geometry.fill","stylers":[{"color":"#283d6a"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#3a4762"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#0e1626"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#4e6d70"}]}]',
};

Map<GoogleMarkerColor, double> googleMarkerColorMap = {
  GoogleMarkerColor.red: 0.0,
  GoogleMarkerColor.orange: 30.0,
  GoogleMarkerColor.yellow: 60.0,
  GoogleMarkerColor.green: 120.0,
  GoogleMarkerColor.cyan: 180.0,
  GoogleMarkerColor.azure: 210.0,
  GoogleMarkerColor.blue: 240.0,
  GoogleMarkerColor.violet: 270.0,
  GoogleMarkerColor.magenta: 300.0,
  GoogleMarkerColor.rose: 330.0,
};
//방향 test