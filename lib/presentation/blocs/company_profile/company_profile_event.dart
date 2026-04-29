part of 'company_profile_bloc.dart';

abstract class CompanyProfileEvent extends Equatable {
  const CompanyProfileEvent();

  @override
  List<Object?> get props => [];
}

class CompanyProfileLoadRequested extends CompanyProfileEvent {
  const CompanyProfileLoadRequested(this.uid);

  final String uid;

  @override
  List<Object?> get props => [uid];
}
