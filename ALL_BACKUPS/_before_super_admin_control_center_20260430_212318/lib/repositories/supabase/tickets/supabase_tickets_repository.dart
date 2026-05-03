import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../tickets/tickets_repository.dart';

class SupabaseTicketsRepository implements TicketsRepository {
  @override
  Future<List<StudentTicketModel>> fetchTickets() async {
    final client = SupabaseBootstrap.client;

    if (client == null) {
      throw Exception('supabase_not_initialized');
    }

    final data = await client
        .from('student_tickets')
        .select()
        .order('created_at', ascending: false);

    return data.map<StudentTicketModel>((item) {
      return StudentTicketModel(
        id: item['id'].toString(),
        trackingCode: item['tracking_code'].toString(),
        studentId: item['student_id'].toString(),
        studentName: item['student_name'].toString(),
        unitKey: item['unit_key'].toString(),
        title: item['title'].toString(),
        description: item['description'].toString(),
        status: TicketStatus.values.firstWhere(
          (TicketStatus status) => status.name == item['status'].toString(),
          orElse: () => TicketStatus.submitted,
        ),
        createdAt: DateTime.parse(item['created_at'].toString()),
        updatedAt: DateTime.parse(item['updated_at'].toString()),
        assignedTo: item['assigned_to'].toString(),
      );
    }).toList();
  }

  @override
  Future<StudentTicketModel> createTicket(StudentTicketModel ticket) async {
    final client = SupabaseBootstrap.client;

    if (client == null) {
      throw Exception('supabase_not_initialized');
    }

    final item = await client
        .from('student_tickets')
        .insert(<String, dynamic>{
          'id': ticket.id,
          'tracking_code': ticket.trackingCode,
          'student_id': ticket.studentId,
          'student_name': ticket.studentName,
          'unit_key': ticket.unitKey,
          'title': ticket.title,
          'description': ticket.description,
          'status': ticket.status.name,
          'created_at': ticket.createdAt.toIso8601String(),
          'updated_at': ticket.updatedAt.toIso8601String(),
          'assigned_to': ticket.assignedTo,
        })
        .select()
        .single();

    return StudentTicketModel(
      id: item['id'].toString(),
      trackingCode: item['tracking_code'].toString(),
      studentId: item['student_id'].toString(),
      studentName: item['student_name'].toString(),
      unitKey: item['unit_key'].toString(),
      title: item['title'].toString(),
      description: item['description'].toString(),
      status: TicketStatus.values.firstWhere(
        (TicketStatus status) => status.name == item['status'].toString(),
        orElse: () => TicketStatus.submitted,
      ),
      createdAt: DateTime.parse(item['created_at'].toString()),
      updatedAt: DateTime.parse(item['updated_at'].toString()),
      assignedTo: item['assigned_to'].toString(),
    );
  }

  @override
  Future<StudentTicketModel> updateTicketStatus({
    required String ticketId,
    required TicketStatus status,
    required String assignedTo,
  }) async {
    final client = SupabaseBootstrap.client;

    if (client == null) {
      throw Exception('supabase_not_initialized');
    }

    final item = await client
        .from('student_tickets')
        .update(<String, dynamic>{
          'status': status.name,
          'assigned_to': assignedTo,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', ticketId)
        .select()
        .single();

    return StudentTicketModel(
      id: item['id'].toString(),
      trackingCode: item['tracking_code'].toString(),
      studentId: item['student_id'].toString(),
      studentName: item['student_name'].toString(),
      unitKey: item['unit_key'].toString(),
      title: item['title'].toString(),
      description: item['description'].toString(),
      status: TicketStatus.values.firstWhere(
        (TicketStatus status) => status.name == item['status'].toString(),
        orElse: () => TicketStatus.submitted,
      ),
      createdAt: DateTime.parse(item['created_at'].toString()),
      updatedAt: DateTime.parse(item['updated_at'].toString()),
      assignedTo: item['assigned_to'].toString(),
    );
  }
}
