import '../comment/comment_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'newfeed_model.dart';
export 'newfeed_model.dart';

class NewfeedWidget extends StatefulWidget {
  const NewfeedWidget({
    super.key,
    this.postdetail,
  });

  final PostRecord? postdetail;

  @override
  State<NewfeedWidget> createState() => _NewfeedWidgetState();
}

class _NewfeedWidgetState extends State<NewfeedWidget> {
  late NewfeedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewfeedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15.0, 16.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Climbing',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Outfit',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.bookmarks_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pushNamed('savePost');
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<PostRecord>>(
                  stream: queryPostRecord(
                    queryBuilder: (postRecord) => postRecord.orderBy('time_posted', descending: true),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      );
                    }
                    List<PostRecord> listViewPostRecordList = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      itemCount: listViewPostRecordList.length,
                      itemBuilder: (context, listViewIndex) {
                        final listViewPostRecord = listViewPostRecordList[listViewIndex];
                        return Visibility(
                          visible: currentUserUid != listViewPostRecord.postUser?.id,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            child: StreamBuilder<UsersRecord>(
                              stream: UsersRecord.getDocument(listViewPostRecord.postUser!),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  );
                                }
                                final containerUsersRecord = snapshot.data!;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  splashColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () async {
                                                    context.pushNamed(
                                                      'otherUserProfile',
                                                      queryParameters: {
                                                        'userss': serializeParam(
                                                          containerUsersRecord,
                                                          ParamType.Document,
                                                        ),
                                                      }.withoutNulls,
                                                      extra: <String, dynamic>{
                                                        'userss': containerUsersRecord,
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.network(
                                                      containerUsersRecord.photoUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.0),
                                                Text(
                                                  valueOrDefault<String>(
                                                    containerUsersRecord.username,
                                                    '[username]',
                                                  ),
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        InkWell(
                                          onTap: () async {
                                            context.pushNamed(
                                              'postDetail',
                                              queryParameters: {
                                                'postdet': serializeParam(
                                                  listViewPostRecord,
                                                  ParamType.Document,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                'postdet': listViewPostRecord,
                                                kTransitionInfoKey: const TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType: PageTransitionType.fade,
                                                ),
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.network(
                                              listViewPostRecord.postPhoto,
                                              width: double.infinity,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          listViewPostRecord.postTitle,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ToggleIcon(
                                                onPressed: () async {
                                                  final postLikedByElement = currentUserReference;
                                                  final postLikedByUpdate = listViewPostRecord.postLikedBy.contains(postLikedByElement)
                                                      ? FieldValue.arrayRemove([postLikedByElement])
                                                      : FieldValue.arrayUnion([postLikedByElement]);
                                                  await listViewPostRecord.reference.update({
                                                    'Post_liked_by': postLikedByUpdate,
                                                  });
                                                },
                                                value: listViewPostRecord.postLikedBy.contains(currentUserReference),
                                                onIcon: Icon(
                                                  Icons.favorite,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  size: 25.0,
                                                ),
                                                offIcon: Icon(
                                                  Icons.favorite_border,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  size: 25.0,
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                formatNumber(
                                                  listViewPostRecord.postLikedBy.length,
                                                  formatType: FormatType.compact,
                                                ),
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              SizedBox(width: 20.0),
                                              FlutterFlowIconButton(
                                                borderRadius: 20.0,
                                                borderWidth: 1.0,
                                                buttonSize: 40.0,
                                                icon: Icon(
                                                  Icons.mode_comment_outlined,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  size: 24.0,
                                                ),
                                                onPressed: () async {
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
                                                          child: CommentWidget(
                                                            commentparameter: listViewPostRecord,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) => setState(() {}));
                                                },
                                              ),
                                              StreamBuilder<List<CommentsRecord>>(
                                                stream: queryCommentsRecord(
                                                  queryBuilder: (commentsRecord) => commentsRecord.where(
                                                    'post_type',
                                                    isEqualTo: listViewPostRecord.reference,
                                                  ),
                                                ),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          FlutterFlowTheme.of(context).primary,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<CommentsRecord> textCommentsRecordList = snapshot.data!;
                                                  return Text(
                                                    formatNumber(
                                                      textCommentsRecordList.length,
                                                      formatType: FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Readex Pro',
                                                      fontSize: 14.0,
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(width: 20.0),
                                              ToggleIcon(
                                                onPressed: () async {
                                                  setState(
                                                        () => FFAppState().SavedPost.contains(listViewPostRecord.reference)
                                                        ? FFAppState().removeFromSavedPost(listViewPostRecord.reference)
                                                        : FFAppState().addToSavedPost(listViewPostRecord.reference),
                                                  );
                                                },
                                                value: FFAppState().SavedPost.contains(listViewPostRecord.reference),
                                                onIcon: FaIcon(
                                                  FontAwesomeIcons.solidBookmark,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  size: 25.0,
                                                ),
                                                offIcon: FaIcon(
                                                  FontAwesomeIcons.bookmark,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  size: 25.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'newfeed_model.dart';
export 'newfeed_model.dart';

class NewfeedWidget extends StatefulWidget {
  const NewfeedWidget({
    super.key,
    this.postdetail,
  });

  final PostRecord? postdetail;

  @override
  State<NewfeedWidget> createState() => _NewfeedWidgetState();
}

class _NewfeedWidgetState extends State<NewfeedWidget> {
  late NewfeedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewfeedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15.0, 16.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Climbing',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Outfit',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.bookmarks_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pushNamed('savePost');
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
              child: StreamBuilder<List<PostRecord>>(
                stream: queryPostRecord(
                  queryBuilder: (postRecord) =>
                      postRecord.orderBy('time_posted', descending: true),
                ),
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
                  List<PostRecord> listViewPostRecordList = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewPostRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewPostRecord =
                          listViewPostRecordList[listViewIndex];
                      return Visibility(
                        visible:
                            currentUserUid != listViewPostRecord.postUser?.id,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15.0, 10.0, 15.0, 0.0),
                          child: StreamBuilder<UsersRecord>(
                            stream: UsersRecord.getDocument(
                                listViewPostRecord.postUser!),
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
                              final containerUsersRecord = snapshot.data!;
                              return Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      15.0, 0.0, 15.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.network(
                                                    containerUsersRecord
                                                        .photoUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          containerUsersRecord
                                                              .username,
                                                          '[username]',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          containerUsersRecord
                                                              .displayName,
                                                          '[displayname]',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ToggleIcon(
                                              onPressed: () async {
                                                setState(
                                                  () => FFAppState()
                                                          .SavedPost
                                                          .contains(
                                                              listViewPostRecord
                                                                  .reference)
                                                      ? FFAppState()
                                                          .removeFromSavedPost(
                                                              listViewPostRecord
                                                                  .reference)
                                                      : FFAppState()
                                                          .addToSavedPost(
                                                              listViewPostRecord
                                                                  .reference),
                                                );
                                              },
                                              value: FFAppState()
                                                  .SavedPost
                                                  .contains(listViewPostRecord
                                                      .reference),
                                              onIcon: FaIcon(
                                                FontAwesomeIcons.solidBookmark,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 25.0,
                                              ),
                                              offIcon: FaIcon(
                                                FontAwesomeIcons.bookmark,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 25.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
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
                                                  listViewPostRecord,
                                                  ParamType.Document,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                'postdet': listViewPostRecord,
                                                kTransitionInfoKey:
                                                    const TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType.fade,
                                                ),
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              listViewPostRecord.postPhoto,
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
                                        child: Text(
                                          listViewPostRecord.postTitle,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ToggleIcon(
                                                  onPressed: () async {
                                                    final postLikedByElement =
                                                        currentUserReference;
                                                    final postLikedByUpdate =
                                                        listViewPostRecord
                                                                .postLikedBy
                                                                .contains(
                                                                    postLikedByElement)
                                                            ? FieldValue
                                                                .arrayRemove([
                                                                postLikedByElement
                                                              ])
                                                            : FieldValue
                                                                .arrayUnion([
                                                                postLikedByElement
                                                              ]);
                                                    await listViewPostRecord
                                                        .reference
                                                        .update({
                                                      ...mapToFirestore(
                                                        {
                                                          'Post_liked_by':
                                                              postLikedByUpdate,
                                                        },
                                                      ),
                                                    });
                                                  },
                                                  value: listViewPostRecord
                                                      .postLikedBy
                                                      .contains(
                                                          currentUserReference),
                                                  onIcon: Icon(
                                                    Icons.favorite,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 25.0,
                                                  ),
                                                  offIcon: Icon(
                                                    Icons.favorite_border,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 25.0,
                                                  ),
                                                ),
                                                Text(
                                                  formatNumber(
                                                    listViewPostRecord
                                                        .postLikedBy.length,
                                                    formatType:
                                                        FormatType.compact,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  icon: Icon(
                                                    Icons.mode_comment_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () {
                                                    print(
                                                        'IconButton pressed ...');
                                                  },
                                                ),
                                                StreamBuilder<
                                                      List<CommentsRecord>>(
                                                    stream: queryCommentsRecord(
                                                      queryBuilder:
                                                          (commentsRecord) =>
                                                              commentsRecord
                                                                  .where(
                                                        'post_type',
                                                        isEqualTo:
                                                            listViewPostRecord
                                                                .reference,
                                                      ),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      List<CommentsRecord>
                                                          textCommentsRecordList =
                                                          snapshot.data!;
                                                      return Text(
                                                  formatNumber(
                                                          textCommentsRecordList
                                                              .length,
                                                          formatType: FormatType
                                                              .compact,
                                                        ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0.0,
                                                      ),
                                                );
                                                        },
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
