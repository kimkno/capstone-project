// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/page_ui/flutter_ui_util.dart';

class ComponentStruct extends FFFirebaseStruct {
  ComponentStruct({
    String? comment,
    String? syntax,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _comment = comment,
        _syntax = syntax,
        super(firestoreUtilData);

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  set comment(String? val) => _comment = val;

  bool hasComment() => _comment != null;

  // "syntax" field.
  String? _syntax;
  String get syntax => _syntax ?? '';
  set syntax(String? val) => _syntax = val;

  bool hasSyntax() => _syntax != null;

  static ComponentStruct fromMap(Map<String, dynamic> data) => ComponentStruct(
        comment: data['comment'] as String?,
        syntax: data['syntax'] as String?,
      );

  static ComponentStruct? maybeFromMap(dynamic data) => data is Map
      ? ComponentStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'comment': _comment,
        'syntax': _syntax,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'comment': serializeParam(
          _comment,
          ParamType.String,
        ),
        'syntax': serializeParam(
          _syntax,
          ParamType.String,
        ),
      }.withoutNulls;

  static ComponentStruct fromSerializableMap(Map<String, dynamic> data) =>
      ComponentStruct(
        comment: deserializeParam(
          data['comment'],
          ParamType.String,
          false,
        ),
        syntax: deserializeParam(
          data['syntax'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ComponentStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ComponentStruct &&
        comment == other.comment &&
        syntax == other.syntax;
  }

  @override
  int get hashCode => const ListEquality().hash([comment, syntax]);
}

ComponentStruct createComponentStruct({
  String? comment,
  String? syntax,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ComponentStruct(
      comment: comment,
      syntax: syntax,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ComponentStruct? updateComponentStruct(
  ComponentStruct? component, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    component
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addComponentStructData(
  Map<String, dynamic> firestoreData,
  ComponentStruct? component,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (component == null) {
    return;
  }
  if (component.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && component.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final componentData = getComponentFirestoreData(component, forFieldValue);
  final nestedData = componentData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = component.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getComponentFirestoreData(
  ComponentStruct? component, [
  bool forFieldValue = false,
]) {
  if (component == null) {
    return {};
  }
  final firestoreData = mapToFirestore(component.toMap());

  // Add any Firestore field values
  component.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getComponentListFirestoreData(
  List<ComponentStruct>? components,
) =>
    components?.map((e) => getComponentFirestoreData(e, true)).toList() ?? [];
