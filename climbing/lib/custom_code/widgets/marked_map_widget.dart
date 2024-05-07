/*
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
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

class showImageWidget extends StatefulWidget {
  final String imagePath;

  const showImageWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);


  @override
  _showImageWidgetState createState() => _showImageWidgetState();
}

class _showImageWidgetState extends State<showImageWidget> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Center(
        child: Image.file(File(widget.imagePath)),
      ),
    );
  }
}
스크린샷 긁어오기까지 되는 코드*/

/*
//나침반 추가. (asset에 나침반 이미지 필요.)
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_compass/flutter_compass.dart';
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

class showImageWidget extends StatefulWidget {
  final String imagePath;

  const showImageWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);


  @override
  _showImageWidgetState createState() => _showImageWidgetState();
}

class _showImageWidgetState extends State<showImageWidget> {
  double _compassValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startCompass();

  }

  @override
  void dispose() {
    _stopCompass();
    super.dispose();
  }

  void _startCompass() {
  FlutterCompass.events?.listen((CompassEvent? event) {
    if (event != null) {
      setState(() {
        _compassValue = event.heading ?? 0.0;
      });
    }
  });
}

void _stopCompass() {
  FlutterCompass.events?.listen(null);
}

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(File(widget.imagePath)),
              SizedBox(height: 20),
              Text(
                'Compass Value: $_compassValue',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

//나침반 추가. (asset에 나침반 이미지 필요.)
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'package:flutter/services.dart';
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

class showImageWidget extends StatefulWidget {
  final String imagePath;

  const showImageWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);


  @override
  _showImageWidgetState createState() => _showImageWidgetState();
}

class _showImageWidgetState extends State<showImageWidget> {
  double _compassValue = 0.0;
  late StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _startCompass();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _stopCompass();
    super.dispose();
  }

  void _startCompass() {
  _compassSubscription = FlutterCompass.events?.listen((CompassEvent? event) {
    if (event != null) {
      setState(() {
        _compassValue = event.heading ?? 0.0;
      });
    }
  });
}

void _stopCompass() {
  _compassSubscription?.cancel();
}

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Stack(
        children: [
          Image.file(
            File(widget.imagePath),
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),/*
          Positioned(
            top: 16,
            left: 16,
            child: Text(
            'Compass Value: $_compassValue',
            style: TextStyle(fontSize: 20),
            ),
          ),*/
          Positioned(
            right: 16,
            bottom: 16,
            child: Transform.rotate(
              angle: ((_compassValue ?? 0.0) * (3.14159 / 180) * -1),
              child: Image.asset(
                'assets/images/compass.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}