import '/backend/api_requests/api_calls.dart';
import '/page_ui/flutter_ui_animations.dart';
import '/page_ui/flutter_ui_theme.dart';
import '/page_ui/flutter_ui_util.dart';
import '/page_ui/flutter_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'request_by_image_model.dart';
export 'request_by_image_model.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RequestByImageWidget extends StatefulWidget {
  const RequestByImageWidget({
    super.key,
    this.targetSentence,
    this.recommends,
  });

  final String? targetSentence;
  final List<String>? recommends;

  @override
  State<RequestByImageWidget> createState() => _RequestByImageWidgetState();
}

class _RequestByImageWidgetState extends State<RequestByImageWidget>
    with TickerProviderStateMixin {
  File? selectedMedia;
  late RequestByImageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RequestByImageModel());

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
            begin: const Offset(0.0, 80.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
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
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
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
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print('<< Attempting to pick media...');
            List<MediaFile>? media = await GalleryPicker.pickMedia(
                context: context,
                singleMedia: true
            );
            if (media != null && media.isNotEmpty) {
              print('<< Media selected: ${media.length} file(s)');
              var data = await media.first.getFile();
              print('<< File path: ${data.path}');
              setState(() {
                selectedMedia = data;
              });
              if (selectedMedia != null) {
                print('<< Selected media file: ${selectedMedia?.path}');
                print('<< Selected media file size: ${selectedMedia?.lengthSync()} bytes');
                String extractedText = await _extractText(selectedMedia!);
                print('<< Extracted text: $extractedText');
                setState(() {
                  _model.targetTextController.text = extractedText;
                });
              }
            } else {
              print('<< No media selected');
            }
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(0.0, -0.86),
                child: Padding(
                  padding:
                  const EdgeInsetsDirectional.fromSTEB(32.0, 12.0, 32.0, 32.0),
                  child: Container(
                    width: double.infinity,
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 3.0),
                      child: Text(
                        '구문 분석',
                        style:
                        FlutterFlowTheme.of(context).displaySmall.override(
                          fontFamily: 'Ubuntu',
                          color: const Color(0xFF101213),
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
                alignment: const AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 170.0, 0.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: double.infinity,
                              height: 630.0,
                              constraints: const BoxConstraints(
                                maxWidth: 570.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
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
                                  color: const Color(0xFFF1F4F8),
                                  width: 2.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: const Alignment(0.0, 0),
                                      child: TabBar(
                                        isScrollable: true,
                                        labelColor: const Color(0xFF101213),
                                        unselectedLabelColor: const Color(0xFF57636C),
                                        labelPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            32.0, 0.0, 32.0, 0.0),
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        unselectedLabelStyle:
                                        FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                          fontFamily: 'Ubuntu',
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        indicatorColor: const Color(0xFF4B39EF),
                                        indicatorWeight: 3.0,
                                        tabs: const [
                                          Tab(
                                            text: '영어',
                                          ),
                                        ],
                                        controller: _model.tabBarController,
                                        onTap: (i) async {
                                          [() async {}][i]();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _model.tabBarController,
                                        children: [
                                          Align(
                                            alignment:
                                            const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  24.0, 16.0, 24.0, 0.0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                        const BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0,
                                                          4.0,
                                                          0.0,
                                                          24.0),
                                                      child: Text(
                                                        '우측 하단 버튼을 클릭해 분석 이미지를 업로드 하세요.',
                                                        textAlign:
                                                        TextAlign.start,
                                                        style: FlutterFlowTheme
                                                            .of(context)
                                                            .labelMedium
                                                            .override(
                                                          fontFamily:
                                                          'Ubuntu',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
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
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0,
                                                            0.0,
                                                            0.0,
                                                            16.0),
                                                        child: SizedBox(
                                                          width:
                                                          double.infinity,
                                                          child: TextFormField(
                                                            controller: _model
                                                                .targetTextController,
                                                            focusNode: _model
                                                                .targetFocusNode,
                                                            autofocus: true,
                                                            obscureText: false,
                                                            decoration:
                                                            InputDecoration(
                                                              labelText:
                                                              'enter here',
                                                              labelStyle:
                                                              FlutterFlowTheme.of(
                                                                  context)
                                                                  .bodyMedium
                                                                  .override(
                                                                fontFamily:
                                                                'Readex Pro',
                                                                color: const Color(
                                                                    0xFF57636C),
                                                                letterSpacing:
                                                                0.0,
                                                              ),
                                                              enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                const BorderSide(
                                                                  color: Color(
                                                                      0xFFE0E3E7),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    8.0),
                                                              ),
                                                              focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                const BorderSide(
                                                                  color: Color(
                                                                      0xFF4B39EF),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    8.0),
                                                              ),
                                                              errorBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                const BorderSide(
                                                                  color: Color(
                                                                      0xFFFF5963),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    8.0),
                                                              ),
                                                              focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                const BorderSide(
                                                                  color: Color(
                                                                      0xFFFF5963),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    8.0),
                                                              ),
                                                              filled: true,
                                                              fillColor:
                                                              Colors.white,
                                                              contentPadding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  12.0),
                                                            ),
                                                            style: GoogleFonts
                                                                .getFont(
                                                              'Plus Jakarta Sans',
                                                              color: const Color(
                                                                  0xFF57636C),
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              fontSize: 14.0,
                                                            ),
                                                            textAlign: TextAlign
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
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                      child: Container(
                                                        width: 328.0,
                                                        height: 100.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: FlutterFlowTheme
                                                              .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
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
                                                                  await AnalysisCall
                                                                      .call(
                                                                    prompt: _model
                                                                        .targetTextController
                                                                        .text,
                                                                  );

                                                                  if ((_model
                                                                      .analysisResult
                                                                      ?.succeeded ??
                                                                      true)) {
                                                                    if (getJsonField(
                                                                      (_model.analysisResult?.jsonBody ??
                                                                          ''),
                                                                      r'''$.result''',
                                                                    ) !=
                                                                        null) {
                                                                      context
                                                                          .pushNamed(
                                                                        'ResultAnalysisByText',
                                                                        queryParameters:
                                                                        {
                                                                          'result':
                                                                          serializeParam(
                                                                            getJsonField(
                                                                              (_model.analysisResult?.jsonBody ?? ''),
                                                                              r'''$.result.*''',
                                                                            ),
                                                                            ParamType.JSON,
                                                                          ),
                                                                          'inKr':
                                                                          serializeParam(
                                                                            getJsonField(
                                                                              (_model.analysisResult?.jsonBody ?? ''),
                                                                              r'''$.kr''',
                                                                            ).toString(),
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    } else {
                                                                      context
                                                                          .pushNamed(
                                                                        'RequestSplash',
                                                                        queryParameters:
                                                                        {
                                                                          'targetSentence':
                                                                          serializeParam(
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
                                                                        'targetSentence':
                                                                        serializeParam(
                                                                          '네트워크 오류로 분석이 실패했습니다!',
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  }

                                                                  safeSetState(
                                                                          () {});
                                                                },
                                                                text: '분석 시작',
                                                                options:
                                                                FFButtonOptions(
                                                                  width: 300.0,
                                                                  height: 52.0,
                                                                  padding: const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                                  iconPadding: const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                                  color: const Color(
                                                                      0xFF4B39EF),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                      context)
                                                                      .titleSmall
                                                                      .override(
                                                                    fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    16.0,
                                                                    letterSpacing:
                                                                    0.0,
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                  ),
                                                                  elevation:
                                                                  3.0,
                                                                  borderSide:
                                                                  const BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                      child: Container(
                                                        width: 328.0,
                                                        height: 100.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: FlutterFlowTheme
                                                              .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0,
                                                                      0.0),
                                                                  child:
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        16.0),
                                                                    child:
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        context.pushNamed(
                                                                            'RequestByText');
                                                                      },
                                                                      text:
                                                                      '텍스트 전환',
                                                                      icon:
                                                                      const Icon(
                                                                        Icons
                                                                            .text_fields,
                                                                        size:
                                                                        15.0,
                                                                      ),
                                                                      options:
                                                                      FFButtonOptions(
                                                                        width:
                                                                        148.0,
                                                                        height:
                                                                        52.0,
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: const Color(
                                                                            0xFF8FADFC),
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
                                                                        const BorderSide(
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
                                                                Align(
                                                                  alignment:
                                                                  const AlignmentDirectional(
                                                                      1.0,
                                                                      0.0),
                                                                  child:
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        16.0),
                                                                    child:
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        _model.recommendResults =
                                                                        await RecommendCall.call();

                                                                        if ((_model.recommendResults?.succeeded ??
                                                                            true)) {
                                                                          context
                                                                              .pushNamed(
                                                                            'RecommendAnalysisByImage',
                                                                            queryParameters:
                                                                            {
                                                                              'syntax': serializeParam(
                                                                                getJsonField(
                                                                                  (_model.recommendResults?.jsonBody ?? ''),
                                                                                  r'''$.data.sentences''',
                                                                                  true,
                                                                                ),
                                                                                ParamType.JSON,
                                                                                isList: true,
                                                                              ),
                                                                              'result': serializeParam(
                                                                                getJsonField(
                                                                                  (_model.recommendResults?.jsonBody ?? ''),
                                                                                  r'''$.data.sentences.*''',
                                                                                ),
                                                                                ParamType.JSON,
                                                                              ),
                                                                            }.withoutNulls,
                                                                          );
                                                                        } else {
                                                                          await showDialog(
                                                                            context:
                                                                            context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: const Text('관리자'),
                                                                                content: const Text('서버 문제가 발생했습니다. 다시 시도해 주세요.'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext),
                                                                                    child: const Text('Ok'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        }

                                                                        safeSetState(
                                                                                () {});
                                                                      },
                                                                      text:
                                                                      '추천',
                                                                      icon:
                                                                      const Icon(
                                                                        Icons
                                                                            .rocket,
                                                                        size:
                                                                        15.0,
                                                                      ),
                                                                      options:
                                                                      FFButtonOptions(
                                                                        width:
                                                                        148.0,
                                                                        height:
                                                                        52.0,
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: const Color(
                                                                            0xFF8FADFC),
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
                                                                        const BorderSide(
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
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                      child: Container(
                                                        width: 328.0,
                                                        height: 100.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: FlutterFlowTheme
                                                              .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                  const AlignmentDirectional(
                                                                      1.0,
                                                                      0.0),
                                                                  child:
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        16.0),
                                                                    child:
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        context.pushNamed(
                                                                            'Login');
                                                                      },
                                                                      text:
                                                                      '로그아웃',
                                                                      icon:
                                                                      const Icon(
                                                                        Icons
                                                                            .key_off,
                                                                        size:
                                                                        15.0,
                                                                      ),
                                                                      options:
                                                                      FFButtonOptions(
                                                                        width:
                                                                        300.0,
                                                                        height:
                                                                        52.0,
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: const Color(
                                                                            0xFFA5A5A5),
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
                                                                        const BorderSide(
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
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ).animateOnPageLoad(animationsMap[
                                              'columnOnPageLoadAnimation']!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation']!),
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
      ),
    );
  }

  Future<String> _extractText(File imageFile) async {
    print('<< Extracting text from image...');
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    print('<< Extracted text: ${recognizedText.text}');
    return recognizedText.text;
  }
}
