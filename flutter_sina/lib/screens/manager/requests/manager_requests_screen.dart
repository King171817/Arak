import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/classes/professor_request_model.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ManagerRequestsScreen extends StatefulWidget {
  const ManagerRequestsScreen({super.key});

  @override
  State<ManagerRequestsScreen> createState() => _ManagerRequestsScreenState();
}

class _ManagerRequestsScreenState extends State<ManagerRequestsScreen> {
  void approveRequest(ProfessorRequestModel request, AppState appState) {
    final updatedRequest = request.copyWith(
      status: RequestStatus.approved,
      reviewedAt: DateTime.now(),
      reviewerId: appState.currentUser?.id,
      reviewerName: appState.currentUser?.displayName,
    );
    appState.updateProfessorRequest(updatedRequest);
  }

  void rejectRequest(ProfessorRequestModel request, AppState appState) {
    final updatedRequest = request.copyWith(
      status: RequestStatus.rejected,
      reviewedAt: DateTime.now(),
      reviewerId: appState.currentUser?.id,
      reviewerName: appState.currentUser?.displayName,
    );
    appState.updateProfessorRequest(updatedRequest);
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final requests = appState.professorRequests;

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.request_page_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت درخواست‌های اساتید',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (requests.isEmpty)
            const EmptyState(message: 'درخواستی ثبت نشده است.')
          else
            ...requests.map((request) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: AppDecorations.cardDecoration,
                child: ListTile(
                  leading: Icon(
                    request.type == RequestType.extraClass
                        ? Icons.school_outlined
                        : Icons.quiz_outlined,
                  ),
                  title: Text('${request.professorName} - ${request.classTitle}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(request.description),
                      Text(
                        'وضعیت: ${request.status == RequestStatus.pending ? 'در انتظار' : request.status == RequestStatus.approved ? 'تایید شده' : 'رد شده'}',
                        style: TextStyle(
                          color: request.status == RequestStatus.pending
                              ? Colors.orange
                              : request.status == RequestStatus.approved
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: request.status == RequestStatus.pending
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => approveRequest(request, appState),
                              tooltip: 'تایید',
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => rejectRequest(request, appState),
                              tooltip: 'رد',
                            ),
                          ],
                        )
                      : null,
                ),
              );
            }),
        ],
      ),
    );
  }
}