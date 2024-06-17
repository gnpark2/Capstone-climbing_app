import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:climbing/map/map_link_post/map_link_post_widget.dart';

import 'package:climbing/map/map_multi_link_post/map_multi_link_post_widget.dart';

import '/backend/backend.dart';

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'map_model.dart';
export 'map_model.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  final globalKey = GlobalKey();

  String clusterDiff = "";

  Iterable<FlutterFlowMarker>? clusteredMarker;

  List<PostRecord> passClusterMarkers = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapModel());

    getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: true)
        .then((loc) => setState(() => currentUserLocationValue = loc));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _capture() async {
    // 이 부분은 화면이 완전히 렌더링된 후 실행됩니다.
    RenderRepaintBoundary? boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      ui.Image image = await boundary.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();
      File imgFile = File('$directory/screenshot1.png');
      await imgFile.writeAsBytes(pngBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Finish capture: ${imgFile.path}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to convert image to bytes')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to capture screenshot')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: Stack(
            children: [
              Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child:RepaintBoundary(
                    key: globalKey,
                    child: StreamBuilder<List<PostRecord>>(
                  stream: queryPostRecord(),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }
                    List<PostRecord> googleMapPostRecordList = snapshot.data!;

                  List<FlutterFlowMarker?> markers = googleMapPostRecordList
                          .map((postRecord) {
                        if (postRecord.latlng != null) {
                          return FlutterFlowMarker(
                            postRecord.latlng!.serialize(),
                            postRecord.latlng!,
                            postRecord.postPhoto,
                            () async {
                              if (clusterDiff == "clustering") {
                                passClusterMarkers = clusteredMarker?.map((marker) {
                                  return googleMapPostRecordList.firstWhere(
                                      (record) => record.latlng?.serialize() == marker.markerLocation.serialize(),);
                                }).whereType<PostRecord>().toList() ?? [];
                              } else {
                                passClusterMarkers = [postRecord];
                              }

                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () => _model.unfocusNode.canRequestFocus
                                        ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                                        : FocusScope.of(context).unfocus(),
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: clusterDiff == "clustering"
                                          ? MapMultiLinkPostWidget(upPost: passClusterMarkers)
                                          : MapLinkPostWidget(upPost: postRecord),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return null;
                        }
                      }).where((marker) => marker != null).toList();

                      Iterable<FlutterFlowMarker> filteredMarkers = markers.whereType<FlutterFlowMarker>();

                    return FlutterFlowGoogleMap(
                      controller: _model.googleMapsController,
                      clusterDifference: (diff) => {
                        setState(() {
                          clusterDiff = diff;
                        }),
                      },
                      //
                      clusteredMarker: (clusteredM) => {
                        setState(() {
                          clusteredMarker = clusteredM;
                        })
                      },
                      //
                      onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                      initialLocation: _model.googleMapsCenter ??=
                          currentUserLocationValue!,
                      markers: filteredMarkers.toList(),
                      markerColor: GoogleMarkerColor.red,
                      mapType: MapType.normal,
                      style: GoogleMapStyle.standard,
                      initialZoom: 14.0,
                      allowInteraction: true,
                      allowZoom: true,
                      showZoomControls: true,
                      showLocation: true,
                      showCompass: false,
                      showMapToolbar: false,
                      showTraffic: false,
                      centerMapOnMarkerTap: true,
                      );
                  },
                    ),
                  ),
                ),
                ],
              ),
              Positioned(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 50.0,
                      icon: FaIcon(
                        FontAwesomeIcons.solidCompass,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 32.0,
                      ),
                      onPressed: () {
                        const imagePath = '/data/user/0/com.mycompany.climbing/app_flutter/screenshot1.png';

                        File(imagePath).existsSync()
                        ? context.pushNamed('TestPage')
                        : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "you don't have screenshot of Map.",
                              style: TextStyle(
                                color:
                                    FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                          )
                        );
                        
                      },
                    ),
                  ]
                )
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      child: const Text("CAP"),
                      onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _capture());
                      }
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}