// Слой: domain | Назначение: загрузка и сохранение резюме

import '../entities/resume.dart';

abstract class ResumeRepository {
  Future<Resume> load(
    String documentKey, {
    required String seedName,
    required String seedEmail,
  });

  Future<void> save(String documentKey, Resume resume);
}
