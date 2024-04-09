import '/flutter_flow/flutter_flow_util.dart';
import 'following_widget.dart' show FollowingWidget;
import 'package:flutter/material.dart';

class FollowingModel extends FlutterFlowModel<FollowingWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
