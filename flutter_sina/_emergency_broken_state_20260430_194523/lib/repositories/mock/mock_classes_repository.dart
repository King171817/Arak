import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../classes/classes_repository.dart';

class MockClassesRepository implements ClassesRepository {
  final List<EducationManagedClassModel> _classes =
      List<EducationManagedClassModel>.from(mockEducationClasses);

  @override
  Future<List<EducationManagedClassModel>> fetchClasses() async {
    return List<EducationManagedClassModel>.unmodifiable(_classes);
  }

  @override
  Future<EducationManagedClassModel> createClass(
    EducationManagedClassModel classItem,
  ) async {
    _classes.add(classItem);
    return classItem;
  }

  @override
  Future<EducationManagedClassModel> updateClass(
    EducationManagedClassModel classItem,
  ) async {
    final int index = _classes.indexWhere(
      (EducationManagedClassModel item) => item.id == classItem.id,
    );

    if (index == -1) {
      _classes.add(classItem);
      return classItem;
    }

    _classes[index] = classItem;
    return classItem;
  }
}
