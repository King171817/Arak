import '../../models/models.dart';

abstract class TicketsRepository {
  Future<List<StudentTicketModel>> fetchTickets();
  Future<StudentTicketModel> createTicket(StudentTicketModel ticket);
  Future<StudentTicketModel> updateTicketStatus({
    required String ticketId,
    required TicketStatus status,
    required String assignedTo,
  });
}
