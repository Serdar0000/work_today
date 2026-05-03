// Слой: presentation | Сохранение экрана «Редактировать профиль»

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/update_account_profile_usecase.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object?> get props => [];
}

class ProfileEditInitial extends ProfileEditState {
  const ProfileEditInitial();
}

class ProfileEditSaving extends ProfileEditState {
  const ProfileEditSaving();
}

class ProfileEditSuccess extends ProfileEditState {
  const ProfileEditSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class ProfileEditFailure extends ProfileEditState {
  const ProfileEditFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit(this._useCase) : super(const ProfileEditInitial());

  final UpdateAccountProfileUseCase _useCase;

  Future<void> submit({required String name, required String email}) async {
    if (state is ProfileEditSaving) return;
    emit(const ProfileEditSaving());
    try {
      final user = await _useCase(
        UpdateAccountProfileParams(name: name, email: email),
      );
      emit(ProfileEditSuccess(user));
    } catch (e) {
      emit(ProfileEditFailure(e.toString()));
      emit(const ProfileEditInitial());
    }
  }
}
