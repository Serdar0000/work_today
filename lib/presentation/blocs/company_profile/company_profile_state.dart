part of 'company_profile_bloc.dart';

abstract class CompanyProfileState extends Equatable {
  const CompanyProfileState();

  @override
  List<Object?> get props => [];
}

class CompanyProfileInitial extends CompanyProfileState {
  const CompanyProfileInitial();
}

class CompanyProfileLoading extends CompanyProfileState {
  const CompanyProfileLoading();
}

class CompanyProfileSuccess extends CompanyProfileState {
  const CompanyProfileSuccess(this.profile);

  final CompanyProfile profile;

  @override
  List<Object?> get props => [profile];
}

class CompanyProfileEmpty extends CompanyProfileState {
  const CompanyProfileEmpty();
}

class CompanyProfileFailure extends CompanyProfileState {
  const CompanyProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
