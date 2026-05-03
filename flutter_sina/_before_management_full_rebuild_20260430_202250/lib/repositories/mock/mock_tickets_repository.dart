import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../tickets/tickets_repository.dart';

class MockTicketsRepository implements TicketsRepository {
  final List<StudentTicketModel> _tickets =
      List<StudentTicketModel>.from(mockTickets);

  @override
  Future<List<StudentTicketModel>> fetchTickets() async {
    return List<StudentTicketModel>.unmodifiable(_tickets);
  }

  @override
  Future<StudentTicketModel> createTicket(StudentTicketModel ticket) async {
    _tickets.add(ticket);
    return ticket;
  }

  @override
  Future<StudentTicketModel> updateTicketStatus({
    required String ticketId,
    required TicketStatus status,
    required String assignedTo,
  }) async {
    final int index = _tickets.indexWhere(
      (StudentTicketModel item) => item.id == ticketId,
    );

    if (index == -1) {
      throw Exception('ticket_not_found');
    }

    final StudentTicketModel updated = _tickets[index].copyWith(
      status: status,
      assignedTo: assignedTo,
      updatedAt: DateTime.now(),
    );

    _tickets[index] = updated;
    return updated;
  }
}
