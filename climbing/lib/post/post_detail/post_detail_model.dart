import '/flutter_flow/flutter_flow_util.dart';
import 'post_detail_widget.dart' show PostDetailWidget;
import 'package:flutter/material.dart';

class PostDetailModel extends FlutterFlowModel<PostDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
