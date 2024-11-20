import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/gemini/gemini.dart';
import '/page_ui/page_ui_animations.dart';
import '/page_ui/page_ui_theme.dart';
import '/page_ui/page_ui_util.dart';
import '/page_ui/page_ui_widgets.dart';
import '/page_ui/upload_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'request_by_image_model.dart';
export 'request_by_image_model.dart';

class RequestByImageWidget extends StatefulWidget {
  const RequestByImageWidget({super.key,});

  @override
  State<RequestByImageWidget> createState() => _RequestByImageWidgetState();
}

class _RequestByImageWidgetState extends State<RequestByImageWidget>
    with TickerProviderStateMixin {
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
              Align(
                alignment: AlignmentDirectional(0.0, -0.86),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(32.0, 12.0, 32.0, 32.0),
                  child: Container(
                    width: double.infinity,
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 3.0),
                      child: Text(
                        '구문 분석',
                        style:
                            FlutterFlowTheme.of(context).displaySmall.override(
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 170.0, 0.0, 0.0),
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
                                        unselectedLabelColor: Color(0xFF57636C),
                                        labelPadding:
                                            EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
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
                                                .override(fontFamily: 'Ubuntu',
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                        indicatorColor: Color(0xFF4B39EF),
                                        indicatorWeight: 3.0,
                                        tabs: [
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
                                            alignment: AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 0.0),
                                              child: SingleChildScrollView(child:Column(mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                        child: InkWell(
                                                          splashColor: Colors.transparent,
                                                          focusColor: Colors.transparent,
                                                          hoverColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                          onTap: () async {
                                                            final selectedMedia = await selectMediaWithSourceBottomSheet(
                                                              context: context,
                                                              allowPhoto: true,
                                                            );
                                                            if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                                              safeSetState(() => _model.isDataUploading = true);
                                                              var selectedUploadedFiles = <FFUploadedFile>[];
                                                              var downloadUrls = <String>[];
                                                              try {
                                                                selectedUploadedFiles = selectedMedia.map((m) => FFUploadedFile(
                                                                  name: m.storagePath.split('/').last,
                                                                  bytes: m.bytes,
                                                                  height: m.dimensions?.height,
                                                                  width: m.dimensions?.width,
                                                                  blurHash: m.blurHash,
                                                                )).toList();
                                                                downloadUrls = (
                                                                    await Future.wait(
                                                                      selectedMedia.map((m) async => await uploadData(
                                                                          m.storagePath, 
                                                                          m.bytes
                                                                      )),
                                                                    )
                                                                ).where((u) => u != null).map((u) => u!).toList();
                                                              } finally {
                                                                _model.isDataUploading = false;
                                                              }
                                                              if (selectedUploadedFiles.length == selectedMedia.length && downloadUrls.length == selectedMedia.length) {
                                                                safeSetState(() {
                                                                  _model.uploadedLocalFile =   selectedUploadedFiles.first;
                                                                  _model.uploadedFileUrl =   downloadUrls.first;
                                                                });
                                                              } else {
                                                                safeSetState(() {});
                                                                return;
                                                              }
                                                            }

                                                            await showDialog(
                                                              context: context,
                                                              builder: (alertDialogContext) {
                                                                return AlertDialog(title: Text('Admin'),
                                                                  content: Text('텍스트 추출 중입니다. 텍스트가 채워질 때까지 대기해 주세요.'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(alertDialogContext),
                                                                      child: Text('확인'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            await geminiTextFromImage(
                                                              context,
                                                              '이미지에서 텍스트 추출하고 아무 코멘트 없이 추출한 문장 한 문장으로 반환해 줘',
                                                              imageNetworkUrl: _model.uploadedFileUrl,
                                                            ).then((generatedText) {
                                                              safeSetState(() => _model.textFromImage = generatedText);
                                                            });

                                                            safeSetState(() {
                                                              _model.targetTextController?.text = _model.textFromImage!;
                                                              _model.targetFocusNode?.requestFocus();
                                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                _model.targetTextController?.selection = TextSelection.collapsed(offset: _model.targetTextController!.text.length,
                                                                );
                                                              });
                                                            });
                                                            safeSetState(() {});
                                                          },
                                                          child: Container(width: 200.0,
                                                            height: 100.0,
                                                            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,
                                                                image: Image.network(_model.uploadedFileUrl,).image,
                                                              ),
                                                              borderRadius: BorderRadius.circular(4.0),
                                                              border: Border.all(color: Color(0x79979797),
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: Container(decoration: BoxDecoration(),
                                                        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              if (_model.uploadedFileUrl != null && _model.uploadedFileUrl != '')
                                                                Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                                  child: Container(
                                                                    width: double.infinity, 
                                                                    child: TextFormField(
                                                                      controller: _model.targetTextController,
                                                                      focusNode: _model.targetFocusNode,
                                                                      autofocus: true,
                                                                      obscureText: false,
                                                                      decoration: InputDecoration(
                                                                        labelText: 'enter here', 
                                                                        labelStyle: GoogleFonts.getFont(
                                                                          'Plus Jakarta Sans',
                                                                          color: Color(0xFF57636C),
                                                                          fontWeight: FontWeight.normal,fontSize: 14.0,
                                                                        ), 
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Color(0xFFE0E3E7), width: 2.0,),
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ), 
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Color(0xFF4B39EF), width: 2.0,),
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ), 
                                                                        errorBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Color(0xFFFF5963), width: 2.0,),
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ), 
                                                                        focusedErrorBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Color(0xFFFF5963), width: 2.0,),
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ), 
                                                                        filled: true, 
                                                                        fillColor: Colors.white, 
                                                                        contentPadding: EdgeInsets.all(12.0),
                                                                      ),
                                                                      style: GoogleFonts.getFont(
                                                                        'Plus Jakarta Sans', 
                                                                        color: Color(0xFF57636C), 
                                                                        fontWeight: FontWeight.normal, 
                                                                        fontSize: 14.0,
                                                                      ),
                                                                      textAlign: TextAlign.justify,
                                                                      maxLines: 16,
                                                                      minLines: 6,
                                                                      keyboardType: TextInputType.emailAddress,
                                                                      validator: _model.targetTextControllerValidator.asValidator(context),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: Container(width: 328.0,
                                                        height: 100.0,
                                                        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondaryBackground,
                                                        ),
                                                        child: Container(width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                          child: Align(
                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                            child: Padding(
                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0,0.0,5.0,16.0),
                                                              child: FFButtonWidget(
                                                                onPressed: () async {
                                                                  _model.analysisResult = await AnalysisCall.call(
                                                                    prompt: _model.targetTextController.text,
                                                                  );
                                                                  if ((_model.analysisResult?.succeeded ?? true)) {
                                                                    if (getJsonField((_model.analysisResult?.jsonBody ?? ''),r'''$.result''', ) != null) {
                                                                      context.pushNamed('ResultAnalysis', queryParameters: {
                                                                          'inKr': serializeParam(getJsonField((_model.analysisResult?.jsonBody ?? ''),   r'''$.kr''', ).toString(), ParamType.String,),'result': serializeParam(getJsonField((_model.analysisResult?.jsonBody ?? ''),   r'''$.result.*''', ), ParamType.JSON,), }.withoutNulls,   );

                                                                      await DocumentsRecord.collection.doc().set({...createDocumentsRecordData(
                                                                          email: currentUserEmail,
                                                                          target: _model.targetTextController.text,
                                                                          imgUrl: _model.uploadedFileUrl, 
                                                                        ), ...mapToFirestore({
                                                                            'created_time': FieldValue.serverTimestamp(),
                                                                        })
                                                                      });
                                                                    } else {
                                                                      context.pushNamed('RequestSplash', queryParameters: {
                                                                          'targetSentence': serializeParam(
                                                                            '유효하지 않은 문장입니다!', 
                                                                            ParamType.String
                                                                          )
                                                                      }.withoutNulls);
                                                                    }
                                                                  } else {
                                                                    context.pushNamed(
                                                                      'RequestSplash',
                                                                      queryParameters: {
                                                                        'targetSentence': serializeParam(
                                                                          '네트워크 오류로 분석이 실패했습니다!',
                                                                          ParamType.String
                                                                        )
                                                                      }.withoutNulls);
                                                                  }

                                                                  safeSetState(() {});
                                                                },
                                                                text: '분석 시작',
                                                                options: FFButtonOptions(width: 300.0,
                                                                  height: 52.0,
                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0,0.0,0.0,0.0),
                                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0,0.0,0.0,0.0),
                                                                  color: Color(0xFF4B39EF),
                                                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(fontFamily: 'Plus Jakarta Sans', color: Colors.white, fontSize: 16.0, letterSpacing: 0.0, fontWeight: FontWeight.w500,   ),
                                                                  elevation: 3.0,
                                                                  borderSide: BorderSide(color: Colors.transparent, width: 1.0,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: Container(width: 328.0,
                                                        height: 100.0,
                                                        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondaryBackground,
                                                        ),
                                                        child: Container(width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                          child: Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                            child: Row(mainAxisSize:  MainAxisSize.min,
                                                              children: [
                                                                Align(alignment: AlignmentDirectional(0.0,0.0),
                                                                  child: Padding(
                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 16.0), 
                                                                    child: FFButtonWidget(
                                                                      onPressed: () async {
                                                                        context.pushNamed('RequestByText');
                                                                      },
                                                                      text: '텍스트 전환',
                                                                      icon: Icon(Icons.text_fields, size: 15.0),
                                                                      options: FFButtonOptions(
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
                                                                          fontWeight: FontWeight.w500
                                                                        ), elevation: 3.0, 
                                                                        borderSide: BorderSide(color: Colors.transparent,width: 1.0, ), 
                                                                        borderRadius: BorderRadius.circular(10.0)
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(alignment: AlignmentDirectional(1.0,0.0),
                                                                  child: Padding(
                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 16.0),
                                                                    child: FFButtonWidget(
                                                                      onPressed: () async {
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
                                                                              )
                                                                            }.withoutNulls);
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
                                                                                    child: Text('Ok')
                                                                                  )
                                                                                ]);
                                                                            });
                                                                        }
                                                                        safeSetState(() {});
                                                                      },
                                                                      text: '추천',
                                                                      icon: Icon(Icons.rocket, size: 15.0),
                                                                      options: FFButtonOptions(
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
                                                                          fontWeight: FontWeight.w500
                                                                        ),
                                                                        elevation: 3.0,
                                                                        borderSide: BorderSide(color: Colors.transparent,width: 1.0, ),
                                                                        borderRadius: BorderRadius.circular(10.0)
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: Container(width: 328.0,
                                                        height: 100.0,
                                                        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondaryBackground,
                                                        ),
                                                        child: Container(width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                          child: Align(alignment: AlignmentDirectional(0.0, 0.0),
                                                            child: Row(mainAxisSize:  MainAxisSize.min,
                                                              children: [
                                                                Align(alignment: AlignmentDirectional(1.0,0.0),
                                                                  child: Padding(
                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 16.0),
                                                                    child: FFButtonWidget(
                                                                      onPressed: () async {context.pushNamed('Login');},
                                                                      text: '로그아웃',
                                                                      icon: Icon(Icons.key_off, size: 15.0
                                                                      ),
                                                                      options: FFButtonOptions(
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
                                                                          fontWeight: FontWeight.w500
                                                                        ),
                                                                        elevation: 3.0,
                                                                        borderSide: BorderSide(color: Colors.transparent,width: 1.0, ),
                                                                        borderRadius: BorderRadius.circular(10.0)
                                                                      )
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
                                              ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
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
}
