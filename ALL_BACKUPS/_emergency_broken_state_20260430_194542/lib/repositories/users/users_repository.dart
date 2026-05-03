import '../../models/models.dart';

abstract class UsersRepository {
  Future<List<AppUserModel>> fetchUsers();
  Future<List<EducationOfficerModel>> fetchEducationOfficers();
  Future<EducationOfficerModel> createEducationOfficer(EducationOfficerModel officer);
}
