import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'other_user_profile_model.dart';
export 'other_user_profile_model.dart';

class OtherUserProfileWidget extends StatefulWidget {
  const OtherUserProfileWidget({
    super.key,
    required this.userss,
    this.chatsss,
  });

  final UsersRecord? userss;
  final ChatsRecord? chatsss;

  @override
  State<OtherUserProfileWidget> createState() => _OtherUserProfileWidgetState();
}

class _OtherUserProfileWidgetState extends State<OtherUserProfileWidget> {
  late OtherUserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OtherUserProfileModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF0F0F0), // Light grey background color
        body: FutureBuilder<UsersRecord>(
          future: (_model.documentRequestCompleter ??= Completer<UsersRecord>()
            ..complete(
                UsersRecord.getDocumentOnce(widget.userss!.reference)))
              .future,
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
            final columnUsersRecord = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10.0, 13.0, 10.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          icon: const Icon(
                            Icons.arrow_back_ios_sharp,
                            color: Colors.black, // Black color for icon
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.safePop();
                          },
                        ), // Add a spacer to push the text to the right
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "@${columnUsersRecord.username}",
                              style: const TextStyle(
                                color: Colors.black, // Black color for text
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10.0, 30.0, 10.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            columnUsersRecord.photoUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  StreamBuilder<List<PostRecord>>(
                                    stream: queryPostRecord(
                                      parent: widget.userss?.reference,
                                    ),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text(
                                          '0',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        );
                                      }
                                      return Text(
                                        snapshot.data!.length.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    columnUsersRecord.followedUsers.length.toString(),
                                    style: TextStyle(
                                      color: Colors.black, // Black color for text
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                      color: Colors.black, // Black color for text
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  columnUsersRecord.following.length.toString(),
                                  style: TextStyle(
                                    color: Colors.black, // Black color for text
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    color: Colors.black, // Black color for text
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(22.0, 15.0, 15.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                columnUsersRecord.displayName,
                                'ghost user',
                              ),
                              style: TextStyle(
                                color: Colors.black, // Black color for text
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (currentUserUid != columnUsersRecord.uid)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(currentUserDocument?.following?.contains(widget.userss?.reference) ?? false))
                                AuthUserStreamWidget(
                                  builder: (context) => FFButtonWidget(
                                    onPressed: () async {
                                      await currentUserReference!.update({
                                        'following': FieldValue.arrayUnion([widget.userss?.reference]),
                                      });

                                      await widget.userss!.reference.update({
                                        'followedUsers': FieldValue.arrayUnion([currentUserReference]),
                                      });
                                      setState(() => _model.documentRequestCompleter = null);
                                      await _model.waitForDocumentRequestCompleted();
                                    },
                                    text: 'Follow',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      elevation: 3.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              if (currentUserDocument?.following?.contains(widget.userss?.reference) ?? false)
                                AuthUserStreamWidget(
                                  builder: (context) => FFButtonWidget(
                                    onPressed: () async {
                                      await currentUserReference!.update({
                                        'following': FieldValue.arrayRemove([widget.userss?.reference]),
                                      });

                                      await widget.userss!.reference.update({
                                        'followedUsers': FieldValue.arrayRemove([currentUserReference]),
                                      });
                                      setState(() => _model.documentRequestCompleter = null);
                                      await _model.waitForDocumentRequestCompleted();
                                    },
                                    text: 'UnFollow',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      elevation: 3.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(22.0, 15.0, 15.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            valueOrDefault<String>(
                              columnUsersRecord.bio,
                              'details',
                            ),
                            style: TextStyle(
                              color: Colors.black, // Black color for text
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(22.0, 15.0, 15.0, 0.0),
                    child: StreamBuilder<List<PostRecord>>(
                      stream: queryPostRecord(
                        parent: widget.userss?.reference,
                        queryBuilder: (postRecord) => postRecord.orderBy('time_posted'),
                      ),
                      builder: (context, snapshot) {
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
                        List<PostRecord> postRecords = snapshot.data!;
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // 3 columns
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 1.0, // Maintain square aspect ratio
                              ),
                              itemCount: postRecords.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(), // Disable the grid view scrolling
                              itemBuilder: (context, gridViewIndex) {
                                final gridViewPostRecord = postRecords[gridViewIndex];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      'postDetail',
                                      queryParameters: {
                                        'postdet': serializeParam(
                                          gridViewPostRecord,
                                          ParamType.Document,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        'postdet': gridViewPostRecord,
                                      },
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      gridViewPostRecord.postPhoto,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

