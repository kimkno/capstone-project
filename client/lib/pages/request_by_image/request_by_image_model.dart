import '/backend/api_requests/api_calls.dart';
import '/page_ui/page_ui_util.dart';
import 'package:capstone_test/image_processing//widgets/index.dart' as img_widgets;
import 'request_by_image_widget.dart' show RequestByImageWidget;
import 'package:flutter/material.dart';

class RequestByImageModel extends FlutterFlowModel<RequestByImageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  FocusNode? targetFocusNode;
  TextEditingController? targetTextController;
  String? Function(BuildContext, String?)? targetTextControllerValidator;
  ApiCallResponse? analysisResult;
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
