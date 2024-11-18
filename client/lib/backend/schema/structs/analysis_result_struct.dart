import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/page_ui/page_ui_util.dart';

class AnalysisResultStruct extends FFFirebaseStruct {
  AnalysisResultStruct({
    String? word,
    ComponentStruct? result,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _word = word,
        _result = result,
        super(firestoreUtilData);

  // "word" field.
  String? _word;
  String get word => _word ?? '';
  set word(String? val) => _word = val;

  bool hasWord() => _word != null;

  // "result" field.
  ComponentStruct? _result;
  ComponentStruct get result => _result ?? ComponentStruct();
  set result(ComponentStruct? val) => _result = val;

  void updateResult(Function(ComponentStruct) updateFn) {
    updateFn(_result ??= ComponentStruct());
  }

  bool hasResult() => _result != null;

  static AnalysisResultStruct fromMap(Map<String, dynamic> data) =>
      AnalysisResultStruct(
        word: data['word'] as String?,
        result: ComponentStruct.maybeFromMap(data['result']),
      );

  static AnalysisResultStruct? maybeFromMap(dynamic data) => data is Map
      ? AnalysisResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'word': _word,
        'result': _result?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'word': serializeParam(
          _word,
          ParamType.String,
        ),
        'result': serializeParam(
          _result,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static AnalysisResultStruct fromSerializableMap(Map<String, dynamic> data) =>
      AnalysisResultStruct(
        word: deserializeParam(
          data['word'],
          ParamType.String,
          false,
        ),
        result: deserializeStructParam(
          data['result'],
          ParamType.DataStruct,
          false,
          structBuilder: ComponentStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'AnalysisResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnalysisResultStruct &&
        word == other.word &&
        result == other.result;
  }

  @override
  int get hashCode => const ListEquality().hash([word, result]);
}

AnalysisResultStruct createAnalysisResultStruct({
  String? word,
  ComponentStruct? result,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AnalysisResultStruct(
      word: word,
      result: result ?? (clearUnsetFields ? ComponentStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AnalysisResultStruct? updateAnalysisResultStruct(
  AnalysisResultStruct? analysisResult, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    analysisResult
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAnalysisResultStructData(
  Map<String, dynamic> firestoreData,
  AnalysisResultStruct? analysisResult,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (analysisResult == null) {
    return;
  }
  if (analysisResult.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && analysisResult.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final analysisResultData =
      getAnalysisResultFirestoreData(analysisResult, forFieldValue);
  final nestedData =
      analysisResultData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = analysisResult.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAnalysisResultFirestoreData(
  AnalysisResultStruct? analysisResult, [
  bool forFieldValue = false,
]) {
  if (analysisResult == null) {
    return {};
  }
  final firestoreData = mapToFirestore(analysisResult.toMap());

  // Handle nested data for "result" field.
  addComponentStructData(
    firestoreData,
    analysisResult.hasResult() ? analysisResult.result : null,
    'result',
    forFieldValue,
  );

  // Add any Firestore field values
  analysisResult.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAnalysisResultListFirestoreData(
  List<AnalysisResultStruct>? analysisResults,
) =>
    analysisResults
        ?.map((e) => getAnalysisResultFirestoreData(e, true))
        .toList() ??
    [];
