import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_role.dart';
import '../../models/units/student_ticket_model.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  String selectedStatus = 'all';
  String selectedFilterUnit = 'all';
  String selectedUnit = UnitKeys.education;

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  @override
  void dispose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  String statusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.submitted:
        return 'ثبت شده';
      case TicketStatus.reviewing:
        return 'در حال بررسی';
      case TicketStatus.needDocuments:
        return 'نیازمند مدارک';
      case TicketStatus.referred:
        return 'ارجاع شده';
      case TicketStatus.completed:
        return 'تکمیل شده';
      case TicketStatus.rejected:
        return 'رد شده';
    }
  }

  Color statusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.submitted:
        return Colors.blue;
      case TicketStatus.reviewing:
        return Colors.orange;
      case TicketStatus.needDocuments:
        return Colors.deepPurple;
      case TicketStatus.referred:
        return Colors.teal;
      case TicketStatus.completed:
        return Colors.green;
      case TicketStatus.rejected:
        return Colors.red;
    }
  }

  List<StudentTicketModel> filteredTickets(List<StudentTicketModel> tickets) {
    return tickets.where((StudentTicketModel ticket) {
      if (selectedStatus != 'all' && ticket.status.name != selectedStatus) {
        return false;
      }

      if (selectedFilterUnit != 'all' && ticket.unitKey != selectedFilterUnit) {
        return false;
      }

      return true;
    }).toList();
  }

  String ticketPrefix(String unitKey) {
    switch (unitKey) {
      case UnitKeys.education:
        return 'EDU';
      case UnitKeys.international:
        return 'INT';
      case UnitKeys.studentServices:
        return 'SS';
      case UnitKeys.consular:
        return 'CON';
      default:
        return 'REQ';
    }
  }

  Future<void> createTicket(AppState appState) async {
    final String title = titleCtrl.text.trim();
    final String description = descriptionCtrl.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عنوان و توضیحات درخواست را وارد کنید.')),
      );
      return;
    }

    final int nextNumber = appState.studentTickets.length + 1;
    final String prefix = ticketPrefix(selectedUnit);
    final String trackingCode =
        '$prefix-1404-${nextNumber.toString().padLeft(4, '0')}';

    await appState.addStudentTicket(
      StudentTicketModel(
        id: 't_${DateTime.now().millisecondsSinceEpoch}',
        trackingCode: trackingCode,
        studentId: 's001',
        studentName: appState.currentUser?.displayName ?? 'دانشجو',
        unitKey: selectedUnit,
        title: title,
        description: description,
        status: TicketStatus.submitted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        assignedTo: 'در انتظار ارجاع',
      ),
    );

    titleCtrl.clear();
    descriptionCtrl.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('درخواست جدید با شماره $trackingCode ثبت شد.')),
    );

    setState(() {});
  }

  void updateStatusDialog(AppState appState, StudentTicketModel ticket) {
    TicketStatus selected = ticket.status;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('تغییر وضعیت ${ticket.trackingCode}'),
              content: DropdownButtonFormField<TicketStatus>(
                initialValue: selected,
                decoration: const InputDecoration(
                  labelText: 'وضعیت جدید',
                  border: OutlineInputBorder(),
                ),
                items: TicketStatus.values.map((TicketStatus status) {
                  return DropdownMenuItem<TicketStatus>(
                    value: status,
                    child: Text(statusText(status)),
                  );
                }).toList(),
                onChanged: (TicketStatus? value) {
                  if (value == null) return;
                  setDialogState(() {
                    selected = value;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('انصراف'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await appState.updateStudentTicketStatus(
                      ticketId: ticket.id,
                      status: selected,
                      assignedTo:
                          appState.currentUser?.displayName ?? ticket.assignedTo,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(dialogContext);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('ذخیره'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem<String>> unitFilterItems() {
    return const <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(value: 'all', child: Text('همه واحدها')),
      DropdownMenuItem<String>(value: UnitKeys.education, child: Text('آموزش')),
      DropdownMenuItem<String>(
        value: UnitKeys.international,
        child: Text('امور بین‌الملل'),
      ),
      DropdownMenuItem<String>(
        value: UnitKeys.studentServices,
        child: Text('خدمات دانشجویی'),
      ),
      DropdownMenuItem<String>(value: UnitKeys.consular, child: Text('کنسولی')),
    ];
  }

  List<DropdownMenuItem<String>> unitCreateItems() {
    return const <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(value: UnitKeys.education, child: Text('آموزش')),
      DropdownMenuItem<String>(
        value: UnitKeys.international,
        child: Text('امور بین‌الملل'),
      ),
      DropdownMenuItem<String>(
        value: UnitKeys.studentServices,
        child: Text('خدمات دانشجویی'),
      ),
      DropdownMenuItem<String>(value: UnitKeys.consular, child: Text('کنسولی')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final List<StudentTicketModel> tickets =
        filteredTickets(appState.getTicketsForCurrentUser());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (appState.currentRole == AppRole.student) ...<Widget>[
          SectionCard(
            title: 'ثبت درخواست جدید',
            icon: Icons.add_circle_outline,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    initialValue: selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'واحد مقصد',
                      border: OutlineInputBorder(),
                    ),
                    items: unitCreateItems(),
                    onChanged: (String? value) {
                      if (value == null) return;
                      setState(() {
                        selectedUnit = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'عنوان درخواست',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'توضیحات درخواست',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => createTicket(appState),
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('ثبت درخواست'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SectionCard(
          title: 'فیلتر درخواست‌ها',
          icon: Icons.filter_alt_outlined,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'وضعیت درخواست',
                    border: OutlineInputBorder(),
                  ),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(
                      value: 'all',
                      child: Text('همه وضعیت‌ها'),
                    ),
                    ...TicketStatus.values.map((TicketStatus status) {
                      return DropdownMenuItem<String>(
                        value: status.name,
                        child: Text(statusText(status)),
                      );
                    }),
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedFilterUnit,
                  decoration: const InputDecoration(
                    labelText: 'واحد مقصد برای فیلتر',
                    border: OutlineInputBorder(),
                  ),
                  items: unitFilterItems(),
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      selectedFilterUnit = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'درخواست‌ها و شماره پیگیری',
          icon: Icons.confirmation_number_outlined,
          child: tickets.isEmpty
              ? const EmptyState(message: 'درخواستی با این وضعیت وجود ندارد.')
              : Column(
                  children: tickets.map((StudentTicketModel ticket) {
                    return Card(
                      margin: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              statusColor(ticket.status).withValues(alpha: 0.12),
                          child: Icon(
                            Icons.confirmation_number_outlined,
                            color: statusColor(ticket.status),
                          ),
                        ),
                        title: Text(
                          ticket.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${ticket.trackingCode}\n'
                          '${appText(lang, ticket.unitKey)} | ${statusText(ticket.status)}',
                        ),
                        childrenPadding: const EdgeInsets.all(14),
                        children: <Widget>[
                          _TicketRow(title: 'دانشجو', value: ticket.studentName),
                          _TicketRow(
                            title: 'شماره دانشجو',
                            value: ticket.studentId,
                          ),
                          _TicketRow(
                            title: 'واحد',
                            value: appText(lang, ticket.unitKey),
                          ),
                          _TicketRow(title: 'مسئول', value: ticket.assignedTo),
                          _TicketRow(
                            title: 'ثبت',
                            value: formatDateTimeShort(ticket.createdAt),
                          ),
                          _TicketRow(
                            title: 'آخرین بروزرسانی',
                            value: formatDateTimeShort(ticket.updatedAt),
                          ),
                          const Divider(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              ticket.description,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (appState.currentRole != AppRole.student)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    updateStatusDialog(appState, ticket),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('تغییر وضعیت درخواست'),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _TicketRow extends StatelessWidget {
  final String title;
  final String value;

  const _TicketRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


