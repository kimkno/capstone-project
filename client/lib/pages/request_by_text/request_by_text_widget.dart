import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/page_ui/page_ui_animations.dart';
import '/page_ui/page_ui_icon_button.dart';
import '/page_ui/page_ui_theme.dart';
import '/page_ui/page_ui_util.dart';
import '/page_ui/page_ui_widgets.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'request_by_text_model.dart';
export 'request_by_text_model.dart';

class RequestByTextWidget extends StatefulWidget {
  const RequestByTextWidget({
    super.key,
    this.targetSentence,
    this.recommends,
  });

  final String? targetSentence;
  final List<String>? recommends;

  @override
  State<RequestByTextWidget> createState() => _RequestByTextWidgetState();
}

class _RequestByTextWidgetState extends State<RequestByTextWidget>
    with TickerProviderStateMixin {
  late RequestByTextModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RequestByTextModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _model.targetTextController ??= TextEditingController();
    _model.targetFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 80.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'capstone.ai',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Ubuntu',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              if (currentUserEmail != 'admin@jelly.org')
                Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, -0.86),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            32.0, 12.0, 32.0, 32.0),
                        child: Container(
                          width: double.infinity,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 3.0),
                            child: Text(
                              '구문 분석',
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Ubuntu',
                                    color: Color(0xFF101213),
                                    fontSize: 36.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 170.0, 0.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 630.0,
                                    constraints: BoxConstraints(
                                      maxWidth: 570.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0.0,
                                            2.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: Color(0xFFF1F4F8),
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 12.0, 0.0, 0.0),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment(0.0, 0),
                                            child: TabBar(
                                              isScrollable: true,
                                              labelColor: Color(0xFF101213),
                                              unselectedLabelColor:
                                                  Color(0xFF57636C),
                                              labelPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          32.0, 0.0, 32.0, 0.0),
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                              unselectedLabelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Ubuntu',
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                              indicatorColor: Color(0xFF4B39EF),
                                              indicatorWeight: 3.0,
                                              tabs: [
                                                Tab(
                                                  text: '영어',
                                                ),
                                              ],
                                              controller:
                                                  _model.tabBarController,
                                              onTap: (i) async {
                                                [() async {}][i]();
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller:
                                                  _model.tabBarController,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, -1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                24.0,
                                                                16.0,
                                                                24.0,
                                                                0.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (responsiveVisibility(
                                                            context: context,
                                                            phone: false,
                                                            tablet: false,
                                                          ))
                                                            Container(
                                                              width: 230.0,
                                                              height: 40.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        4.0,
                                                                        0.0,
                                                                        24.0),
                                                            child: Text(
                                                              '분석하고자 하는 문장을 입력해 주세요.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Ubuntu',
                                                                    color: Color(
                                                                        0xFF57636C),
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          16.0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .targetTextController,
                                                                  focusNode: _model
                                                                      .targetFocusNode,
                                                                  autofocus:
                                                                      true,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'enter here',
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Readex Pro',
                                                                          color:
                                                                              Color(0xFF57636C),
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xFFE0E3E7),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xFF4B39EF),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xFFFF5963),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xFFFF5963),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                  ),
                                                                  style: GoogleFonts
                                                                      .getFont(
                                                                    'Plus Jakarta Sans',
                                                                    color: Color(
                                                                        0xFF57636C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                  maxLines: 16,
                                                                  minLines: 6,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .emailAddress,
                                                                  validator: _model
                                                                      .targetTextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Container(
                                                              width: 328.0,
                                                              height: 100.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              child: Container(
                                                                width: 100.0,
                                                                height: 100.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            5.0,
                                                                            16.0),
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        // Call JellyGrammar
                                                                        _model.analysisResult =
                                                                            await AnalysisCall.call(
                                                                          prompt: _model
                                                                              .targetTextController
                                                                              .text,
                                                                        );

                                                                        if ((_model.analysisResult?.succeeded ??
                                                                            true)) {
                                                                          if (getJsonField(
                                                                                (_model.analysisResult?.jsonBody ?? ''),
                                                                                r'''$.result''',
                                                                              ) !=
                                                                              null) {
                                                                            context.pushNamed(
                                                                              'ResultAnalysis',
                                                                              queryParameters: {
                                                                                'result': serializeParam(
                                                                                  getJsonField(
                                                                                    (_model.analysisResult?.jsonBody ?? ''),
                                                                                    r'''$.result.*''',
                                                                                  ),
                                                                                  ParamType.JSON,
                                                                                ),
                                                                                'inKr': serializeParam(
                                                                                  getJsonField(
                                                                                    (_model.analysisResult?.jsonBody ?? ''),
                                                                                    r'''$.kr''',
                                                                                  ).toString(),
                                                                                  ParamType.String,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );

                                                                            await DocumentsRecord.collection.doc().set({
                                                                              ...createDocumentsRecordData(
                                                                                email: currentUserEmail,
                                                                                target: _model.targetTextController.text,
                                                                              ),
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'created_time': FieldValue.serverTimestamp(),
                                                                                },
                                                                              ),
                                                                            });
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
                                                                          context
                                                                              .pushNamed(
                                                                            'RequestSplash',
                                                                            queryParameters:
                                                                                {
                                                                              'targetSentence': serializeParam(
                                                                                '네트워크 오류로 분석이 실패했습니다!',
                                                                                ParamType.String,
                                                                              ),
                                                                            }.withoutNulls,
                                                                          );
                                                                        }

                                                                        safeSetState(
                                                                            () {});
                                                                      },
                                                                      text:
                                                                          '분석 시작',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            300.0,
                                                                        height:
                                                                            52.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: Color(
                                                                            0xFF4B39EF),
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Plus Jakarta Sans',
                                                                              color: Colors.white,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Container(
                                                              width: 328.0,
                                                              height: 100.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              child: Container(
                                                                width: 100.0,
                                                                height: 100.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              5.0,
                                                                              16.0),
                                                                          child:
                                                                              FFButtonWidget(
                                                                            onPressed:
                                                                                () async {
                                                                              context.pushNamed('RequestByImage');
                                                                            },
                                                                            text:
                                                                                '이미지 전환',
                                                                            icon:
                                                                                Icon(
                                                                              Icons.photo_sharp,
                                                                              size: 15.0,
                                                                            ),
                                                                            options:
                                                                                FFButtonOptions(
                                                                              width: 148.0,
                                                                              height: 52.0,
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              color: Color(0xFF8FADFC),
                                                                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                    fontFamily: 'Plus Jakarta Sans',
                                                                                    color: Colors.white,
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                              elevation: 3.0,
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 1.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            1.0,
                                                                            0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0,
                                                                              16.0),
                                                                          child:
                                                                              FFButtonWidget(
                                                                            onPressed:
                                                                                () async {
                                                                              _model.recommendResults = await RecommendCall.call();

                                                                              if ((_model.recommendResults?.succeeded ?? true)) {
                                                                                context.pushNamed(
                                                                                  'RecommendAnalysis',
                                                                                  queryParameters: {
                                                                                    'result': serializeParam(
                                                                                      getJsonField(
                                                                                        (_model.recommendResults?.jsonBody ?? ''),
                                                                                        r'''$.data.sentences.*''',
                                                                                      ),
                                                                                      ParamType.JSON,
                                                                                    ),
                                                                                    'syntax': serializeParam(
                                                                                      getJsonField(
                                                                                        (_model.recommendResults?.jsonBody ?? ''),
                                                                                        r'''$.data.sentences''',
                                                                                        true,
                                                                                      ),
                                                                                      ParamType.JSON,
                                                                                      isList: true,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              } else {
                                                                                await showDialog(
                                                                                  context: context,
                                                                                  builder: (alertDialogContext) {
                                                                                    return AlertDialog(
                                                                                      title: Text('관리자'),
                                                                                      content: Text('서버 문제가 발생했습니다. 다시 시도해 주세요.'),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () => Navigator.pop(alertDialogContext),
                                                                                          child: Text('Ok'),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }

                                                                              safeSetState(() {});
                                                                            },
                                                                            text:
                                                                                '추천',
                                                                            icon:
                                                                                Icon(
                                                                              Icons.rocket,
                                                                              size: 15.0,
                                                                            ),
                                                                            options:
                                                                                FFButtonOptions(
                                                                              width: 148.0,
                                                                              height: 52.0,
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              color: Color(0xFF8FADFC),
                                                                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                    fontFamily: 'Plus Jakarta Sans',
                                                                                    color: Colors.white,
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                              elevation: 3.0,
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 1.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Container(
                                                              width: 328.0,
                                                              height: 100.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              child: Container(
                                                                width: 100.0,
                                                                height: 100.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            1.0,
                                                                            0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0,
                                                                              16.0),
                                                                          child:
                                                                              FFButtonWidget(
                                                                            onPressed:
                                                                                () async {
                                                                              context.pushNamed('Login');
                                                                            },
                                                                            text:
                                                                                '로그아웃',
                                                                            icon:
                                                                                Icon(
                                                                              Icons.key_off,
                                                                              size: 15.0,
                                                                            ),
                                                                            options:
                                                                                FFButtonOptions(
                                                                              width: 300.0,
                                                                              height: 52.0,
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              color: Color(0xFFA5A5A5),
                                                                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                    fontFamily: 'Plus Jakarta Sans',
                                                                                    color: Colors.white,
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                              elevation: 3.0,
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 1.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ).animateOnPageLoad(
                                                            animationsMap[
                                                                'columnOnPageLoadAnimation']!),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation']!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (currentUserEmail == 'admin@jelly.org')
                Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 1170.0,
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 40.0, 0.0, 30.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, 0.0),
                                                    child: RichText(
                                                      textScaler:
                                                          MediaQuery.of(context)
                                                              .textScaler,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'Admin Dashboard',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      20.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          )
                                                        ],
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyLarge
                                                            .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 20.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  FlutterFlowIconButton(
                                                    borderRadius: 8.0,
                                                    buttonSize: 40.0,
                                                    icon: Icon(
                                                      Icons.logout_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 24.0,
                                                    ),
                                                    onPressed: () async {
                                                      context
                                                          .pushNamed('Login');
                                                    },
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '회원 ID',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                        )
                                                      ],
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '가입 일자',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: Color(
                                                                    0xFF878787),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                        )
                                                      ],
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                  child: StreamBuilder<List<UsersRecord>>(
                                    stream: queryUsersRecord(
                                      queryBuilder: (usersRecord) =>
                                          usersRecord.orderBy('created_time'),
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
                                      List<UsersRecord>
                                          listViewUsersRecordList =
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
                                            listViewUsersRecordList.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 1.0),
                                        itemBuilder: (context, listViewIndex) {
                                          final listViewUsersRecord =
                                              listViewUsersRecordList[
                                                  listViewIndex];
                                          return Container(
                                            width: 100.0,
                                            height: 96.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 0.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  offset: Offset(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 5.0, 5.0, 5.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    10.0,
                                                                    0.0),
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
                                                            Expanded(
                                                              child: Opacity(
                                                                opacity: 0.6,
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    elevation:
                                                                        1.0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                        ),
                                                                      ),
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(12.0),
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.rectangle,
                                                                                            ),
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Text(
                                                                                              valueOrDefault<String>(
                                                                                                listViewUsersRecord.email,
                                                                                                'test@email.com',
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                    fontFamily: 'Readex Pro',
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    fontSize: 13.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                                                            child: Text(
                                                                                              valueOrDefault<String>(
                                                                                                listViewUsersRecord.createdTime?.toString(),
                                                                                                '-',
                                                                                              ),
                                                                                              textAlign: TextAlign.end,
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    fontFamily: 'Readex Pro',
                                                                                                    fontSize: 13.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                          child: StreamBuilder<List<DocumentsRecord>>(
                                                                                            stream: queryDocumentsRecord(
                                                                                              queryBuilder: (documentsRecord) => documentsRecord
                                                                                                  .where(
                                                                                                    'email',
                                                                                                    isEqualTo: listViewUsersRecord.email,
                                                                                                  )
                                                                                                  .orderBy('created_time'),
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
                                                                                              List<DocumentsRecord> iconButtonDocumentsRecordList = snapshot.data!;

                                                                                              return FlutterFlowIconButton(
                                                                                                borderColor: Colors.transparent,
                                                                                                borderRadius: 1.0,
                                                                                                icon: Icon(
                                                                                                  Icons.arrow_forward_ios,
                                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                                  size: 15.0,
                                                                                                ),
                                                                                                onPressed: () async {
                                                                                                  context.pushNamed(
                                                                                                    'AdminUserDetails',
                                                                                                    queryParameters: {
                                                                                                      'targetEmail': serializeParam(
                                                                                                        listViewUsersRecord.email,
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                    }.withoutNulls,
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
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
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
                                                  ),
                                                ],
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
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
