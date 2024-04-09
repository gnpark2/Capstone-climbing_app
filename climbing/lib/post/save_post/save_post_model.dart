import '/flutter_flow/flutter_flow_util.dart';
import 'save_post_widget.dart' show SavePostWidget;
import 'package:flutter/material.dart';

class SavePostModel extends FlutterFlowModel<SavePostWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
