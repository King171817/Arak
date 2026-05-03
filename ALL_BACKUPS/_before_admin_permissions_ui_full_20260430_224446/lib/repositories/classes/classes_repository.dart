import '../../models/models.dart';

abstract class ClassesRepository {
  Future<List<EducationManagedClassModel>> fetchClasses();
  Future<EducationManagedClassModel> createClass(EducationManagedClassModel classItem);
  Future<EducationManagedClassModel> updateClass(EducationManagedClassModel classItem);
}
