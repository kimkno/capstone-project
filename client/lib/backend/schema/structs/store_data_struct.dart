// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/page_ui/page_ui_util.dart';

class StoreDataStruct extends FFFirebaseStruct {
  StoreDataStruct({
    List<StoreSchemaStruct>? comp,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _comp = comp,
        super(firestoreUtilData);

  // "comp" field.
  List<StoreSchemaStruct>? _comp;
  List<StoreSchemaStruct> get comp => _comp ?? const [];
  set comp(List<StoreSchemaStruct>? val) => _comp = val;

  void updateComp(Function(List<StoreSchemaStruct>) updateFn) {
    updateFn(_comp ??= []);
  }

  bool hasComp() => _comp != null;

  static StoreDataStruct fromMap(Map<String, dynamic> data) => StoreDataStruct(
        comp: getStructList(
          data['comp'],
          StoreSchemaStruct.fromMap,
        ),
      );

  static StoreDataStruct? maybeFromMap(dynamic data) => data is Map
      ? StoreDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'comp': _comp?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'comp': serializeParam(
          _comp,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static StoreDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoreDataStruct(
        comp: deserializeStructParam<StoreSchemaStruct>(
          data['comp'],
          ParamType.DataStruct,
          true,
          structBuilder: StoreSchemaStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'StoreDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is StoreDataStruct && listEquality.equals(comp, other.comp);
  }

  @override
  int get hashCode => const ListEquality().hash([comp]);
}

StoreDataStruct createStoreDataStruct({
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StoreDataStruct(
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StoreDataStruct? updateStoreDataStruct(
  StoreDataStruct? storeData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    storeData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStoreDataStructData(
  Map<String, dynamic> firestoreData,
  StoreDataStruct? storeData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (storeData == null) {
    return;
  }
  if (storeData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && storeData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final storeDataData = getStoreDataFirestoreData(storeData, forFieldValue);
  final nestedData = storeDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = storeData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStoreDataFirestoreData(
  StoreDataStruct? storeData, [
  bool forFieldValue = false,
]) {
  if (storeData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(storeData.toMap());

  // Add any Firestore field values
  storeData.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStoreDataListFirestoreData(
  List<StoreDataStruct>? storeDatas,
) =>
    storeDatas?.map((e) => getStoreDataFirestoreData(e, true)).toList() ?? [];
