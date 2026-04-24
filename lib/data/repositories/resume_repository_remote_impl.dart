// Слой: data | Назначение: репозиторий резюме через Firestore

import '../../domain/entities/resume.dart';
import '../../domain/repositories/resume_repository.dart';
import '../datasources/resume_remote_datasource.dart';
import '../mappers/resume_mapper.dart';

class ResumeRepositoryRemoteImpl implements ResumeRepository {
  ResumeRepositoryRemoteImpl(this._remote);

  final ResumeRemoteDatasource _remote;

  @override
  Future<Resume> load(
    String documentKey, {
    required String seedName,
    required String seedEmail,
  }) async {
    final snap = await _remote.getDocument(documentKey);
    final data = snap.data();
    if (data == null) {
      return Resume.blank(seedName: seedName, seedEmail: seedEmail);
    }
    return ResumeMapper.fromFirestore(
      data,
      seedName: seedName,
      seedEmail: seedEmail,
    );
  }

  @override
  Future<void> save(String documentKey, Resume resume) {
    return _remote.mergeResume(documentKey, resume.toFirestoreMap());
  }
}
