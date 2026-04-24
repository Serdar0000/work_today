// Слой: presentation | Состояния ResumeBloc

part of 'resume_bloc.dart';

enum ResumeViewStatus { initial, loading, ready, saving, failure }

class ResumeState extends Equatable {
  const ResumeState({
    required this.resume,
    required this.status,
    this.errorMessage,
    this.successSaved = false,
  });

  final Resume resume;
  final ResumeViewStatus status;
  final String? errorMessage;
  final bool successSaved;

  factory ResumeState.initial(String seedName, String seedEmail) {
    return ResumeState(
      resume: Resume.blank(seedName: seedName, seedEmail: seedEmail),
      status: ResumeViewStatus.loading,
    );
  }

  ResumeState copyWith({
    Resume? resume,
    ResumeViewStatus? status,
    String? errorMessage,
    bool? successSaved,
    bool clearError = false,
  }) {
    return ResumeState(
      resume: resume ?? this.resume,
      status: status ?? this.status,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      successSaved: successSaved ?? this.successSaved,
    );
  }

  @override
  List<Object?> get props =>
      [resume, status, errorMessage, successSaved];
}
