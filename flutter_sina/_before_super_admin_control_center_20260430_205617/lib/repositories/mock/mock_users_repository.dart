import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../users/users_repository.dart';

class MockUsersRepository implements UsersRepository {
  final List<EducationOfficerModel> _officers =
      List<EducationOfficerModel>.from(mockEducationOfficers);

  @override
  Future<List<AppUserModel>> fetchUsers() async {
    return const <AppUserModel>[];
  }

  @override
  Future<List<EducationOfficerModel>> fetchEducationOfficers() async {
    return List<EducationOfficerModel>.unmodifiable(_officers);
  }

  @override
  Future<EducationOfficerModel> createEducationOfficer(
    EducationOfficerModel officer,
  ) async {
    _officers.add(officer);
    return officer;
  }
}
