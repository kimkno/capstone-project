import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/page_ui/page_ui_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class AnalysisCall {
  static Future<ApiCallResponse> call({
    String? prompt = '',
  }) async {
    final ffApiRequestBody = '''
{
  "prompt": "${prompt}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'analysis',
      apiUrl:
          'https://3c4poujwac.execute-api.ap-northeast-2.amazonaws.com/default/capstone-grammar?model=gemini-pro&max_output_tokens=8192',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'nyQUGXv71x159ow6944v77BtfT3lNe5RaAhSTMLS',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? result(dynamic response) => getJsonField(
        response,
        r'''$.result.*''',
        true,
      ) as List?;
  static String? kr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.kr''',
      ));
}

class RecommendCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'recommend',
      apiUrl:
          'https://bls6x9koja.execute-api.ap-northeast-2.amazonaws.com/default/capstone-recommend?model=gemini-pro&max_output_tokens=8192',
      callType: ApiCallType.POST,
      headers: {
        'x-api-key': 'nyQUGXv71x159ow6944v77BtfT3lNe5RaAhSTMLS',
        'Content-Type': 'application/json',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? results(dynamic response) => (getJsonField(
        response,
        r'''$.data.sentences''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
