import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/page_ui/page_ui_animations.dart';
import '/page_ui/page_ui_icon_button.dart';
import '/page_ui/page_ui_theme.dart';
import '/page_ui/page_ui_util.dart';
import '/page_ui/page_ui_widgets.dart';
import 'dart:math';
import 'request_by_text_widget.dart' show RequestByTextWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RequestByTextModel extends FlutterFlowModel<RequestByTextWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for target widget.
  FocusNode? targetFocusNode;
  TextEditingController? targetTextController;
  String? Function(BuildContext, String?)? targetTextControllerValidator;
  // Stores action output result for [Backend Call - API (analysis)] action in Button widget.
  ApiCallResponse? analysisResult;
  // Stores action output result for [Backend Call - API (recommend)] action in Button widget.
  ApiCallResponse? recommendResults;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    targetFocusNode?.dispose();
    targetTextController?.dispose();
  }
}
