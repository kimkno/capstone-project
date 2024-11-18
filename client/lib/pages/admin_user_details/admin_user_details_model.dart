import '/backend/api_requests/api_calls.dart';
import '/page_ui/page_ui_util.dart';
import 'admin_user_details_widget.dart' show AdminUserDetailsWidget;
import 'package:flutter/material.dart';

class AdminUserDetailsModel extends FlutterFlowModel<AdminUserDetailsWidget> {
  ApiCallResponse? adminAnalysisResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
