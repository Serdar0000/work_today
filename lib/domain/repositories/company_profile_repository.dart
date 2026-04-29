import '../entities/company_profile.dart';

abstract class CompanyProfileRepository {
  Future<CompanyProfile?> getByUid(String uid);
}
