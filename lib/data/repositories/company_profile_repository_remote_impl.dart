import '../../domain/entities/company_profile.dart';
import '../../domain/repositories/company_profile_repository.dart';
import '../datasources/company_profile_remote_datasource.dart';

class CompanyProfileRepositoryRemoteImpl implements CompanyProfileRepository {
  CompanyProfileRepositoryRemoteImpl(this._remoteDatasource);

  final CompanyProfileRemoteDatasource _remoteDatasource;

  @override
  Future<CompanyProfile?> getByUid(String uid) {
    return _remoteDatasource.getByUid(uid);
  }
}
