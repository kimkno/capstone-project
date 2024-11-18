import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/page_ui/page_ui_animations.dart';
import '/page_ui/page_ui_icon_button.dart';
import '/page_ui/page_ui_theme.dart';
import '/page_ui/page_ui_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'admin_user_details_model.dart';
export 'admin_user_details_model.dart';

class AdminUserDetailsWidget extends StatefulWidget {
  const AdminUserDetailsWidget({
    super.key,
    required this.targetEmail,
  });

  final String? targetEmail;

  @override
  State<AdminUserDetailsWidget> createState() => _AdminUserDetailsWidgetState();
}

class _AdminUserDetailsWidgetState extends State<AdminUserDetailsWidget>
    with TickerProviderStateMixin {
  late AdminUserDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminUserDetailsModel());

    animationsMap.addAll({
      'gridPopAnimation_v1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'gridPopAnimation_v2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Color(0x00FFFFFF),
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Admin Dashboard',
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Readex Pro',
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 1170.0,
                    ),
                    decoration: BoxDecoration(),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 30.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Align(
                                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                                  child: RichText(
                                                    textScaler: MediaQuery.of(context).textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'User Management',
                                                          style: FlutterFlowTheme.of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: 'Readex Pro',
                                                                color: FlutterFlowTheme.of(context).primary,
                                                                fontSize: 20.0,
                                                                letterSpacing: 0.0,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                        )
                                                      ],
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily: 'Readex Pro',
                                                            fontSize: 20.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                              child: GridView(
                                padding: EdgeInsets.zero,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.0,
                                ),
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Container(
                                    width: MediaQuery.sizeOf(context).width * 0.4,
                                    height: 160.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 2.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.menu_book,
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              size: 30.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                                              child: FutureBuilder<int>(
                                                future:
                                                    queryDocumentsRecordCount(
                                                      queryBuilder: (documentsRecord) =>
                                                          documentsRecord.where(
                                                            'email',
                                                            isEqualTo: widget!.targetEmail,
                                                          ),
                                                    ),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                              valueColor:
                                                              AlwaysStoppedAnimation<Color>(
                                                                FlutterFlowTheme.of(context).primary,
                                                              ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  int studyTimeCount =
                                                      snapshot.data!;

                                                  return Text(
                                                    valueOrDefault<String>(
                                                      studyTimeCount.toString(),
                                                      '-',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(
                                              '학습 (회)',
                                              textAlign: TextAlign.center,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Readex Pro',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap['gridPopAnimation_v1']!),
                                  Container(
                                    width: MediaQuery.sizeOf(context).width * 0.4,
                                    height: 160.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primary,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 2.0,),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            color: FlutterFlowTheme.of(context).info,
                                            size: 30.0,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                                              child: StreamBuilder<List<DocumentsRecord>>(
                                                stream: queryDocumentsRecord(
                                                  queryBuilder: (documentsRecord) =>
                                                          documentsRecord.where('email', isEqualTo: widget!.targetEmail,)
                                                              .orderBy('created_time', descending: true),
                                                ),
                                                builder: (context, snapshot) {
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
                                                  List<DocumentsRecord>
                                                      lastStudyDocumentsRecordList =
                                                      snapshot.data!;

                                                  return Text(
                                                    valueOrDefault<String>(
                                                      dateTimeFormat(
                                                          "relative",
                                                          lastStudyDocumentsRecordList
                                                              .take(1)
                                                              .toList()
                                                              .first
                                                              .createdTime
                                                      ),
                                                      '-',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displaySmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .info,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '마지막 학습 기록',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap['gridPopAnimation_v2']!),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 12.0, 16.0, 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'History',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                'Readex Pro',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                      ),
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<List<DocumentsRecord>>(
                                stream: queryDocumentsRecord(
                                  queryBuilder: (documentsRecord) =>
                                      documentsRecord.where(
                                    'email',
                                    isEqualTo: widget!.targetEmail,
                                    isNull: (widget!.targetEmail) == null,
                                  ),
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<DocumentsRecord>
                                      adminListViewDocumentsRecordList =
                                      snapshot.data!;

                                  return ListView.separated(
                                    padding: EdgeInsets.fromLTRB(
                                      0,
                                      10.0,
                                      0,
                                      10.0,
                                    ),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        adminListViewDocumentsRecordList.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 1.0),
                                    itemBuilder: (context, adminListViewIndex) {
                                      final adminListViewDocumentsRecord =
                                          adminListViewDocumentsRecordList[
                                              adminListViewIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 4.0, 16.0, 8.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x32000000),
                                                offset: Offset(
                                                  0.0,
                                                  2.0,
                                                ),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 8.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            adminListViewDocumentsRecord
                                                                .createdTime
                                                                ?.toString(),
                                                            '(No data)',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: Color(
                                                                    0xFF7E7E7E),
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                adminListViewDocumentsRecord
                                                                    .target,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          1.0, 0.0),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 10.0,
                                                    borderWidth: 20.0,
                                                    buttonSize: 46.0,
                                                    icon: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 15.0,
                                                    ),
                                                    onPressed: () async {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text('capstone.ai'),
                                                            content: Text('기록 불러오는 중'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                child: Text('확인'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      _model.adminAnalysisResult =
                                                          await AnalysisCall.call(prompt: adminListViewDocumentsRecord.target,);

                                                      if ((_model.adminAnalysisResult?.succeeded ?? true)) {
                                                        if (getJsonField(
                                                              (_model.adminAnalysisResult?.jsonBody ?? ''),
                                                              r'''$.result''',
                                                            ) != null
                                                        ) {
                                                          context.pushNamed(
                                                            'ResultAnalysis',
                                                            queryParameters: {
                                                              'result': serializeParam(
                                                                getJsonField(
                                                                  (_model.adminAnalysisResult?.jsonBody ?? ''),
                                                                  r'''$.result.*''',
                                                                ),
                                                                ParamType.JSON,
                                                              ),
                                                              'inKr': serializeParam(
                                                                getJsonField(
                                                                  (_model.adminAnalysisResult?.jsonBody ?? ''),
                                                                  r'''$.kr''',
                                                                ).toString(),
                                                                ParamType.String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        } else {
                                                          context.pushNamed(
                                                            'RequestSplash',
                                                            queryParameters: {
                                                              'targetSentence': serializeParam(
                                                                '유효하지 않은 문장입니다!',
                                                                ParamType.String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        }
                                                      } else {
                                                        context.pushNamed(
                                                          'RequestSplash',
                                                          queryParameters: {
                                                            'targetSentence':
                                                                serializeParam(
                                                              '네트워크 오류로 분석이 실패했습니다!',
                                                              ParamType.String,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      }

                                                      safeSetState(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
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
