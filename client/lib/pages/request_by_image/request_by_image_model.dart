import '/backend/api_requests/api_calls.dart';
import '/page_ui/flutter_ui_util.dart';
import 'request_by_image_widget.dart' show RequestByImageWidget;
import 'package:flutter/material.dart';

class RequestByImageModel extends FlutterFlowModel<RequestByImageWidget> {
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
