// Слой: presentation | Назначение: загрузка и сохранение резюме

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/resume.dart';
import '../../../domain/repositories/resume_repository.dart';

part 'resume_event.dart';
part 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  ResumeBloc({
    required ResumeRepository repository,
    required this.documentKey,
    required String seedName,
    required String seedEmail,
  })  : _repository = repository,
        _seedName = seedName,
        _seedEmail = seedEmail,
        super(ResumeState.initial(seedName, seedEmail)) {
    on<ResumeLoadRequested>(_onLoad);
    on<ResumeSaveRequested>(_onSave);
    on<ResumeToastConsumed>(_onToastConsumed);
  }

  final ResumeRepository _repository;
  final String documentKey;
  final String _seedName;
  final String _seedEmail;

  Future<void> _onLoad(
    ResumeLoadRequested event,
    Emitter<ResumeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResumeViewStatus.loading,
        clearError: true,
        successSaved: false,
      ),
    );
    try {
      final resume = await _repository.load(
        documentKey,
        seedName: _seedName,
        seedEmail: _seedEmail,
      );
      emit(
        ResumeState(
          resume: resume,
          status: ResumeViewStatus.ready,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResumeViewStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSave(
    ResumeSaveRequested event,
    Emitter<ResumeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResumeViewStatus.saving,
        clearError: true,
        successSaved: false,
      ),
    );
    try {
      await _repository.save(documentKey, event.resume);
      emit(
        ResumeState(
          resume: event.resume,
          status: ResumeViewStatus.ready,
          successSaved: true,
        ),
      );
    } catch (e) {
      emit(
        ResumeState(
          resume: event.resume,
          status: ResumeViewStatus.ready,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onToastConsumed(
    ResumeToastConsumed event,
    Emitter<ResumeState> emit,
  ) {
    emit(state.copyWith(successSaved: false));
  }
}
