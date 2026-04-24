// Слой: presentation | События ResumeBloc

part of 'resume_bloc.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();

  @override
  List<Object?> get props => [];
}

class ResumeLoadRequested extends ResumeEvent {
  const ResumeLoadRequested();
}

class ResumeSaveRequested extends ResumeEvent {
  const ResumeSaveRequested(this.resume);

  final Resume resume;

  @override
  List<Object?> get props => [resume];
}

class ResumeToastConsumed extends ResumeEvent {
  const ResumeToastConsumed();
}
