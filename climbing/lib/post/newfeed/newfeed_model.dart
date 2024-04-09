import '/flutter_flow/flutter_flow_util.dart';
import 'newfeed_widget.dart' show NewfeedWidget;
import 'package:flutter/material.dart';

class NewfeedModel extends FlutterFlowModel<NewfeedWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
