// Слой: data | Назначение: чтение/запись резюме в Firestore

import 'package:cloud_firestore/cloud_firestore.dart';

class ResumeRemoteDatasource {
  ResumeRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('resumes');

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String uid) {
    return _col.doc(uid).get();
  }

  Future<void> mergeResume(String uid, Map<String, dynamic> fields) async {
    await _col.doc(uid).set(
      {
        ...fields,
        'uid': uid,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
