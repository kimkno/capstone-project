import '/page_ui/page_ui_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/page_ui/form_field_controller.dart';
import 'request_by_text_widget.dart' show RequestByTextWidget;
import 'package:flutter/material.dart';

class RequestByTextModel extends PageUIModel<RequestByTextWidget> {
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  FocusNode? targetFocusNode;
  TextEditingController? targetTextController;
  String? Function(BuildContext, String?)? targetTextControllerValidator;
  ApiCallResponse? analysisResult;
  ApiCallResponse? recommendResults;
  FocusNode? targetUserFocusNode;
  TextEditingController? targetUserTextController;
  String? Function(BuildContext, String?)? targetUserTextControllerValidator;
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  ApiCallResponse? adminAnalysisDefaultResult;
  ApiCallResponse? adminAnalysisResultByEmail;
  ApiCallResponse? adminAnalysisSortedResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    targetFocusNode?.dispose();
    targetTextController?.dispose();

    targetUserFocusNode?.dispose();
    targetUserTextController?.dispose();
  }
}
