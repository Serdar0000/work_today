import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/company_profile.dart';
import '../../../domain/repositories/company_profile_repository.dart';

part 'company_profile_event.dart';
part 'company_profile_state.dart';

class CompanyProfileBloc extends Bloc<CompanyProfileEvent, CompanyProfileState> {
  CompanyProfileBloc({required CompanyProfileRepository repository})
      : _repository = repository,
        super(const CompanyProfileInitial()) {
    on<CompanyProfileLoadRequested>(_onLoadRequested);
  }

  final CompanyProfileRepository _repository;

  Future<void> _onLoadRequested(
    CompanyProfileLoadRequested event,
    Emitter<CompanyProfileState> emit,
  ) async {
    emit(const CompanyProfileLoading());
    try {
      final profile = await _repository.getByUid(event.uid);
      if (profile == null) {
        emit(const CompanyProfileEmpty());
        return;
      }
      emit(CompanyProfileSuccess(profile));
    } catch (e) {
      emit(CompanyProfileFailure(e.toString()));
    }
  }
}
