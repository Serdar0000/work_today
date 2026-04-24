// Слой: data | Назначение: репозиторий резюме через локальное хранилище

import '../../domain/entities/resume.dart';
import '../../domain/repositories/resume_repository.dart';
import '../datasources/resume_local_datasource.dart';
import '../mappers/resume_mapper.dart';

class ResumeRepositoryLocalImpl implements ResumeRepository {
  ResumeRepositoryLocalImpl(this._local);

  final ResumeLocalDatasource _local;

  @override
  Future<Resume> load(
    String documentKey, {
    required String seedName,
    required String seedEmail,
  }) async {
    final map = await _local.loadMap(documentKey);
    if (map == null) {
      return Resume.blank(seedName: seedName, seedEmail: seedEmail);
    }
    return ResumeMapper.fromFirestore(
      map,
      seedName: seedName,
      seedEmail: seedEmail,
    );
  }

  @override
  Future<void> save(String documentKey, Resume resume) {
    return _local.saveMap(documentKey, resume.toFirestoreMap());
  }
}
