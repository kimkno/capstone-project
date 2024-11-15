// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/page_ui/page_ui_util.dart';

class StoreSchemaStruct extends FFFirebaseStruct {
  StoreSchemaStruct({
    String? word,
    String? syntax,
    String? comment,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _word = word,
        _syntax = syntax,
        _comment = comment,
        super(firestoreUtilData);

  // "word" field.
  String? _word;
  String get word => _word ?? '';
  set word(String? val) => _word = val;

  bool hasWord() => _word != null;

  // "syntax" field.
  String? _syntax;
  String get syntax => _syntax ?? '';
  set syntax(String? val) => _syntax = val;

  bool hasSyntax() => _syntax != null;

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  set comment(String? val) => _comment = val;

  bool hasComment() => _comment != null;

  static StoreSchemaStruct fromMap(Map<String, dynamic> data) =>
      StoreSchemaStruct(
        word: data['word'] as String?,
        syntax: data['syntax'] as String?,
        comment: data['comment'] as String?,
      );

  static StoreSchemaStruct? maybeFromMap(dynamic data) => data is Map
      ? StoreSchemaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'word': _word,
        'syntax': _syntax,
        'comment': _comment,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'word': serializeParam(
          _word,
          ParamType.String,
        ),
        'syntax': serializeParam(
          _syntax,
          ParamType.String,
        ),
        'comment': serializeParam(
          _comment,
          ParamType.String,
        ),
      }.withoutNulls;

  static StoreSchemaStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoreSchemaStruct(
        word: deserializeParam(
          data['word'],
          ParamType.String,
          false,
        ),
        syntax: deserializeParam(
          data['syntax'],
          ParamType.String,
          false,
        ),
        comment: deserializeParam(
          data['comment'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StoreSchemaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StoreSchemaStruct &&
        word == other.word &&
        syntax == other.syntax &&
        comment == other.comment;
  }

  @override
  int get hashCode => const ListEquality().hash([word, syntax, comment]);
}

StoreSchemaStruct createStoreSchemaStruct({
  String? word,
  String? syntax,
  String? comment,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StoreSchemaStruct(
      word: word,
      syntax: syntax,
      comment: comment,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StoreSchemaStruct? updateStoreSchemaStruct(
  StoreSchemaStruct? storeSchema, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    storeSchema
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStoreSchemaStructData(
  Map<String, dynamic> firestoreData,
  StoreSchemaStruct? storeSchema,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (storeSchema == null) {
    return;
  }
  if (storeSchema.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && storeSchema.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final storeSchemaData =
      getStoreSchemaFirestoreData(storeSchema, forFieldValue);
  final nestedData =
      storeSchemaData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = storeSchema.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStoreSchemaFirestoreData(
  StoreSchemaStruct? storeSchema, [
  bool forFieldValue = false,
]) {
  if (storeSchema == null) {
    return {};
  }
  final firestoreData = mapToFirestore(storeSchema.toMap());

  // Add any Firestore field values
  storeSchema.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStoreSchemaListFirestoreData(
  List<StoreSchemaStruct>? storeSchemas,
) =>
    storeSchemas?.map((e) => getStoreSchemaFirestoreData(e, true)).toList() ??
    [];
