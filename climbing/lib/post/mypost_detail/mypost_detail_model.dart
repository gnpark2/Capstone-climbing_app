import '/flutter_flow/flutter_flow_util.dart';
import 'mypost_detail_widget.dart' show MypostDetailWidget;
import 'package:flutter/material.dart';

class MypostDetailModel extends FlutterFlowModel<MypostDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
