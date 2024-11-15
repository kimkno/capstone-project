import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/page_ui/page_ui_icon_button.dart';
import '/page_ui/page_ui_theme.dart';
import '/page_ui/page_ui_util.dart';
import '/page_ui/page_ui_widgets.dart';
import 'admin_user_details_widget.dart' show AdminUserDetailsWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminUserDetailsModel extends FlutterFlowModel<AdminUserDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (analysis)] action in IconButton widget.
  ApiCallResponse? adminAnalysisResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
