import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/page_ui/page_ui_util.dart';

class DocumentsRecord extends FirestoreRecord {
  DocumentsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "translates" field.
  List<String>? _translates;
  List<String> get translates => _translates ?? const [];
  bool hasTranslates() => _translates != null;

  // "histories" field.
  List<ComponentStruct>? _histories;
  List<ComponentStruct> get histories => _histories ?? const [];
  bool hasHistories() => _histories != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "history" field.
  List<String>? _history;
  List<String> get history => _history ?? const [];
  bool hasHistory() => _history != null;

  // "target" field.
  String? _target;
  String get target => _target ?? '';
  bool hasTarget() => _target != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _translates = getDataList(snapshotData['translates']);
    _histories = getStructList(
      snapshotData['histories'],
      ComponentStruct.fromMap,
    );
    _createdTime = snapshotData['created_time'] as DateTime?;
    _history = getDataList(snapshotData['history']);
    _target = snapshotData['target'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('documents');

  static Stream<DocumentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DocumentsRecord.fromSnapshot(s));

  static Future<DocumentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DocumentsRecord.fromSnapshot(s));

  static DocumentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DocumentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DocumentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DocumentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DocumentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DocumentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDocumentsRecordData({
  String? email,
  DateTime? createdTime,
  String? target,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'created_time': createdTime,
      'target': target,
    }.withoutNulls,
  );

  return firestoreData;
}

class DocumentsRecordDocumentEquality implements Equality<DocumentsRecord> {
  const DocumentsRecordDocumentEquality();

  @override
  bool equals(DocumentsRecord? e1, DocumentsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        listEquality.equals(e1?.translates, e2?.translates) &&
        listEquality.equals(e1?.histories, e2?.histories) &&
        e1?.createdTime == e2?.createdTime &&
        listEquality.equals(e1?.history, e2?.history) &&
        e1?.target == e2?.target;
  }

  @override
  int hash(DocumentsRecord? e) => const ListEquality().hash([
        e?.email,
        e?.translates,
        e?.histories,
        e?.createdTime,
        e?.history,
        e?.target
      ]);

  @override
  bool isValidKey(Object? o) => o is DocumentsRecord;
}
