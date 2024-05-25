import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'map_multi_link_post_model.dart';
export 'map_multi_link_post_model.dart';

class MapMultiLinkPostWidget extends StatefulWidget {
  const MapMultiLinkPostWidget({
    super.key,
    required this.upPost,
  });

  final List<PostRecord>? upPost;

  @override
  State<MapMultiLinkPostWidget> createState() => _MapMultiLinkPostWidgetState();
}

class _MapMultiLinkPostWidgetState extends State<MapMultiLinkPostWidget> {
  late MapMultiLinkPostModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapMultiLinkPostModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 411.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5.0,
            color: Color(0x3B1D2429),
            offset: Offset(
              0.0,
              -3.0,
            ),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60.0,
                child: Divider(
                  thickness: 3.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 10.0, 0.0, 0.0),
                      //stream에서 List upPost로 바꿔야함.
                  child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    itemCount: widget.upPost!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, staggeredViewIndex) {
                      final staggeredViewPostRecord =
                          widget.upPost![staggeredViewIndex];
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 10.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              'postDetail',
                              queryParameters: {
                                'postdet': serializeParam(
                                  staggeredViewPostRecord,
                                  ParamType.Document,
                                ),
                              }.withoutNulls,
                              extra: <String, dynamic>{
                                'postdet': staggeredViewPostRecord,
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              staggeredViewPostRecord.postPhoto,
                              width: 400.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}