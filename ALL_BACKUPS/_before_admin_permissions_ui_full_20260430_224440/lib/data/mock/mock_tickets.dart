import '../../core/constants/unit_keys.dart';
import '../../models/units/student_ticket_model.dart';

final List<StudentTicketModel> mockTickets = <StudentTicketModel>[
  StudentTicketModel(
    id: 't001',
    trackingCode: 'EDU-1404-0001',
    studentId: 's001',
    studentName: 'رضا حسینی',
    unitKey: UnitKeys.education,
    title: 'درخواست گواهی اشتغال به تحصیل',
    description: 'نیاز به گواهی برای تمدید اقامت دارم.',
    status: TicketStatus.reviewing,
    createdAt: DateTime(2026, 4, 10, 9, 0),
    updatedAt: DateTime(2026, 4, 11, 10, 30),
    assignedTo: 'کارشناس آموزش ۱',
  ),
  StudentTicketModel(
    id: 't002',
    trackingCode: 'INT-1404-0002',
    studentId: 's002',
    studentName: 'علی احمدی',
    unitKey: UnitKeys.international,
    title: 'تکمیل مدارک پذیرش',
    description: 'مدارک جدید بارگذاری شده و نیاز به بررسی دارد.',
    status: TicketStatus.needDocuments,
    createdAt: DateTime(2026, 4, 12, 11, 0),
    updatedAt: DateTime(2026, 4, 13, 8, 45),
    assignedTo: 'مدیر امور بین‌الملل',
  ),
  StudentTicketModel(
    id: 't003',
    trackingCode: 'SS-1404-0003',
    studentId: 's003',
    studentName: 'فاطمه رضایی',
    unitKey: UnitKeys.studentServices,
    title: 'پیگیری خوابگاه',
    description: 'درخواست خوابگاه ثبت شده اما نتیجه اعلام نشده است.',
    status: TicketStatus.submitted,
    createdAt: DateTime(2026, 4, 13, 12, 15),
    updatedAt: DateTime(2026, 4, 13, 12, 15),
    assignedTo: 'در انتظار ارجاع',
  ),
];
