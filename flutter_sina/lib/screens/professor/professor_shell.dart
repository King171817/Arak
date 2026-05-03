import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/theme.dart';
import '../../models/auth/app_lang.dart';
import '../../models/classes/education_class_model.dart';
import '../../state/app_state.dart';
import '../../state/live_class_state.dart';
import '../../widgets/widgets.dart';
import '../classroom/live_class_screen.dart';
import 'exams/professor_exams_screen.dart';

enum ProfessorMorePage {
  menu,
  services,
  settings,
  help,
  about,
}

class ProfessorShell extends StatefulWidget {
  const ProfessorShell({super.key});

  @override
  State<ProfessorShell> createState() => _ProfessorShellState();
}

class _ProfessorShellState extends State<ProfessorShell> {
  int currentIndex = 0;
  ProfessorMorePage morePage = ProfessorMorePage.menu;

  void setTab(int index) {
    setState(() {
      currentIndex = index;
      if (index != 3) {
        morePage = ProfessorMorePage.menu;
      }
    });
  }

  void openMorePage(ProfessorMorePage page) {
    setState(() {
      currentIndex = 3;
      morePage = page;
    });
  }

  void backToMoreMenu() {
    setState(() {
      morePage = ProfessorMorePage.menu;
    });
  }

  void _openExamsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ProfessorExamsScreen(),
      ),
    );
  }

  Future<void> _submitEducationRequest(
    BuildContext context, {
    required String title,
    required String hint,
  }) async {
    final TextEditingController detail = TextEditingController();
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: detail,
            autofocus: true,
            minLines: 3,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('ارسال برای مدیر آموزش'),
            ),
          ],
        );
      },
    );

    final String text = detail.text.trim();
    detail.dispose();

    if (ok != true || !context.mounted || text.isEmpty) {
      if (ok == true && text.isEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('متن درخواست را وارد کنید')),
        );
      }
      return;
    }

    await context.read<AppState>().submitProfessorEducationRequest(
          title: title,
          description: text,
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('درخواست ثبت شد — مدیر آموزش پیگیری می‌کند')),
    );
  }

  Widget buildMoreBody(AppState appState) {
    switch (morePage) {
      case ProfessorMorePage.services:
        return _ProfessorServicesPage(onBack: backToMoreMenu);

      case ProfessorMorePage.settings:
        return _ProfessorSettingsPage(onBack: backToMoreMenu);

      case ProfessorMorePage.help:
        return _ProfessorSimplePage(
          title: 'راهنما',
          icon: Icons.help_outline,
          text:
              'در پنل استاد می‌توانید کلاس‌های خود را ببینید، کلاس را شروع کنید، با مدیران پیام بدهید و از خدمات مورد نیاز استفاده کنید.',
          onBack: backToMoreMenu,
        );

      case ProfessorMorePage.about:
        return _ProfessorSimplePage(
          title: 'درباره',
          icon: Icons.info_outline,
          text:
              'این بخش برای مدیریت ارتباط استاد با واحدهای دانشگاه، کلاس‌ها و پیام‌های مدیریتی طراحی شده است.',
          onBack: backToMoreMenu,
        );

      case ProfessorMorePage.menu:
        return _ProfessorMoreMenu(
          onOpenServices: () => openMorePage(ProfessorMorePage.services),
          onOpenSettings: () => openMorePage(ProfessorMorePage.settings),
          onOpenHelp: () => openMorePage(ProfessorMorePage.help),
          onOpenAbout: () => openMorePage(ProfessorMorePage.about),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    final List<_ProfessorTab> tabs = <_ProfessorTab>[
      _ProfessorTab(
        keyName: 'dashboard',
        label: appText(lang, 'dashboard'),
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        page: _ProfessorDashboardPage(
          onOpenClasses: () => setTab(1),
          onOpenMessages: () => setTab(2),
          onOpenServices: () => openMorePage(ProfessorMorePage.services),
          onOpenExams: () => _openExamsScreen(context),
          onRequestExam: () => _submitEducationRequest(
            context,
            title: 'درخواست امتحان / آزمون',
            hint: 'زمان، ترتیب سوالات، حضوری/آنلاین، نیازهای ویژه…',
          ),
          onRequestMeetingRoom: () => _submitEducationRequest(
            context,
            title: 'رزرو اتاق جلسات',
            hint: 'تاریخ، بازهٔ زمانی، ظرفیت، تجهیزات…',
          ),
          onRequestExtraClass: () => _submitEducationRequest(
            context,
            title: 'کلاس فوق‌العاده',
            hint: 'دلیل، زمان پیشنهادی، دانشجویان هدف…',
          ),
          professorId: appState.currentUser?.id ?? 'p001',
        ),
      ),
      _ProfessorTab(
        keyName: 'classes',
        label: appText(lang, 'classes'),
        icon: Icons.school_outlined,
        activeIcon: Icons.school,
        page: const _ProfessorClassesPage(),
      ),
      _ProfessorTab(
        keyName: 'messages',
        label: isRtlLang(lang) ? 'پیام‌ها' : 'Messages',
        icon: Icons.chat_bubble_outline,
        activeIcon: Icons.chat_bubble,
        page: const _ProfessorMessagesPage(),
      ),
      _ProfessorTab(
        keyName: 'more',
        label: appText(lang, 'more'),
        icon: Icons.more_horiz,
        activeIcon: Icons.more,
        page: buildMoreBody(appState),
      ),
    ];

    if (currentIndex >= tabs.length) {
      currentIndex = 0;
    }

    return RoleShellLayout(
      titleKey: 'university_app',
      currentIndex: currentIndex,
      onBottomTap: setTab,
      body: tabs[currentIndex].page,
      bottomItems: tabs.map((_ProfessorTab tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}

class _ProfessorDashboardPage extends StatelessWidget {
  final VoidCallback onOpenClasses;
  final VoidCallback onOpenMessages;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenExams;
  final VoidCallback onRequestExam;
  final VoidCallback onRequestMeetingRoom;
  final VoidCallback onRequestExtraClass;
  final String professorId;

  const _ProfessorDashboardPage({
    required this.onOpenClasses,
    required this.onOpenMessages,
    required this.onOpenServices,
    required this.onOpenExams,
    required this.onRequestExam,
    required this.onRequestMeetingRoom,
    required this.onRequestExtraClass,
    required this.professorId,
  });

  int _distinctStudentCount(List<EducationManagedClassModel> classes) {
    final Set<String> ids = <String>{};
    for (final EducationManagedClassModel c in classes) {
      ids.addAll(c.studentIds);
    }
    return ids.length;
  }

  int _activeLiveCount(LiveClassState live, String profId) {
    return live.sessions
        .where(
          (s) => s.professorId == profId && s.status == 'active',
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final LiveClassState live = context.watch<LiveClassState>();
    final AppLang lang = appState.selectedLang;
    final String name = appState.currentUser?.displayName ?? 'استاد';
    final List<EducationManagedClassModel> myClasses =
        appState.getProfessorClasses(professorId);
    final int studentsN = _distinctStudentCount(myClasses);
    final int liveN = _activeLiveCount(live, professorId);
    final bool rtl = isRtlLang(lang);

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.30),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_pin_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rtl
                            ? 'کلاس‌های تعیین‌شده توسط مدیر آموزش، کلاس زنده و ارتباط با مدیریت'
                            : 'Classes assigned by education admin, live session, manager chat',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatChip(
                  icon: Icons.school_outlined,
                  label: rtl ? 'کلاس' : 'Classes',
                  value: '${myClasses.length}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatChip(
                  icon: Icons.groups_outlined,
                  label: rtl ? 'دانشجو' : 'Students',
                  value: '$studentsN',
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatChip(
                  icon: Icons.videocam_outlined,
                  label: rtl ? 'زنده' : 'Live',
                  value: '$liveN',
                  color: liveN > 0 ? Colors.redAccent : Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            rtl ? 'عملیات اصلی' : 'Main actions',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _CompactDashboardTile(
            icon: Icons.school_outlined,
            title: appText(lang, 'classes'),
            subtitle: rtl
                ? 'شروع/پایان کلاس زنده، لیست دانشجویان هر درس'
                : 'Live class start/end, roster per course',
            onTap: onOpenClasses,
          ),
          _CompactDashboardTile(
            icon: Icons.quiz_outlined,
            title: rtl ? 'امتحانات و آزمون' : 'Exams',
            subtitle: rtl
                ? 'سوالات، زمان‌بندی و نمره‌دهی'
                : 'Questions, schedule, grading',
            onTap: onOpenExams,
          ),
          _CompactDashboardTile(
            icon: Icons.assignment_outlined,
            title: rtl ? 'درخواست امتحان / آزمون' : 'Exam request',
            subtitle: rtl
                ? 'ارسال به مدیر آموزش برای هماهنگی'
                : 'Send to education manager',
            onTap: onRequestExam,
          ),
          _CompactDashboardTile(
            icon: Icons.meeting_room_outlined,
            title: rtl ? 'اتاق جلسات' : 'Meeting room',
            subtitle: rtl ? 'رزرو و هماهنگی با مدیر آموزش' : 'Booking via education admin',
            onTap: onRequestMeetingRoom,
          ),
          _CompactDashboardTile(
            icon: Icons.event_repeat_outlined,
            title: rtl ? 'کلاس فوق‌العاده' : 'Extra session',
            subtitle: rtl
                ? 'درخواست جلسهٔ اضافه برای دانشجویان همان درس'
                : 'Request extra class for assigned students',
            onTap: onRequestExtraClass,
          ),
          _CompactDashboardTile(
            icon: Icons.chat_bubble_outline,
            title: rtl ? 'پیام مدیران' : 'Managers chat',
            subtitle: rtl
                ? 'مدیر آموزش و واحدها'
                : 'Education admin & units',
            onTap: onOpenMessages,
          ),
          _CompactDashboardTile(
            icon: Icons.apps_outlined,
            title: appText(lang, 'other_services'),
            subtitle: rtl
                ? 'ترجمه، پرینت، رفاهی و پشتیبانی'
                : 'Translation, printing, welfare',
            onTap: onOpenServices,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessorClassesPage extends StatelessWidget {
  const _ProfessorClassesPage();

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final String professorId = appState.currentUser?.id ?? 'p001';
    final classes = appState.getProfessorClasses(professorId);

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
            leading: const Icon(Icons.school_outlined, size: 22),
            title: Text(
              isRtlLang(lang) ? 'کلاس‌های من' : 'My Classes',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              isRtlLang(lang)
                  ? 'برای شروع هر کلاس، دکمه شروع را بزنید.'
                  : 'Tap start to begin each class.',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          const Divider(height: 12),
          if (classes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('کلاسی برای شما ثبت نشده است.'),
              ),
            )
          else
            ...classes.map((EducationManagedClassModel item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const Icon(Icons.event_note_outlined, size: 22),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '${item.weekDay} | ${formatTimeOfDay(item.startTime)} - ${formatTimeOfDay(item.endTime)}\n'
                    '${item.studentIds.length} ${isRtlLang(lang) ? 'دانشجو توسط مدیر آموزش' : 'students assigned'}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  children: <Widget>[
                    if (item.studentNames.isEmpty)
                      ListTile(
                        dense: true,
                        title: Text(
                          isRtlLang(lang)
                              ? 'هنوز دانشجویی برای این درس ثبت نشده است.'
                              : 'No students assigned yet.',
                          style: const TextStyle(fontSize: 11),
                        ),
                      )
                    else
                      ...item.studentNames.map((String studentName) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.person_outline, size: 18),
                          title: Text(
                            studentName,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => LiveClassScreen(
                                  classId: item.id,
                                  classTitle: item.title,
                                  professorId: item.professorId,
                                  professorName: item.professorName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.video_call_outlined, size: 20),
                          label: Text(
                            isRtlLang(lang)
                                ? 'شروع / ورود به کلاس زنده'
                                : 'Enter live class',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _ProfessorMessagesPage extends StatefulWidget {
  const _ProfessorMessagesPage();

  @override
  State<_ProfessorMessagesPage> createState() => _ProfessorMessagesPageState();
}

class _ProfessorMessagesPageState extends State<_ProfessorMessagesPage> {
  final TextEditingController ctrl = TextEditingController();
  final List<String> messages = <String>[
    'سلام، برای هماهنگی کلاس امروز پیام ارسال کنید.',
  ];

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void send() {
    final String text = ctrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: const Icon(Icons.chat_bubble_outline, size: 22),
            title: Text(
              isRtlLang(lang) ? 'پیام مدیران' : 'Managers Chat',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              isRtlLang(lang)
                  ? 'ارتباط استاد با مدیر آموزش، مدیران واحدها و مدیر اصلی'
                  : 'Professor chat with education manager, unit managers and super admin',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final bool mine = index != 0;

                return Align(
                  alignment: mine
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(maxWidth: 420),
                    decoration: BoxDecoration(
                      color: mine
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.12)
                          : Colors.grey.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      messages[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'پیام خود را بنویسید...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: send,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessorMoreMenu extends StatelessWidget {
  final VoidCallback onOpenServices;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenHelp;
  final VoidCallback onOpenAbout;

  const _ProfessorMoreMenu({
    required this.onOpenServices,
    required this.onOpenSettings,
    required this.onOpenHelp,
    required this.onOpenAbout,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        _MoreTile(
          icon: Icons.apps_outlined,
          title: appText(lang, 'other_services'),
          subtitle: 'ترجمه، پرینت، رفاهی و پشتیبانی',
          onTap: onOpenServices,
        ),
        _MoreTile(
          icon: Icons.settings_outlined,
          title: appText(lang, 'settings'),
          subtitle: 'زبان، تم روز و شب، اعلان‌ها و امنیت',
          onTap: onOpenSettings,
        ),
        _MoreTile(
          icon: Icons.help_outline,
          title: 'راهنما',
          subtitle: 'راهنمای استفاده از پنل استاد',
          onTap: onOpenHelp,
        ),
        _MoreTile(
          icon: Icons.info_outline,
          title: 'درباره',
          subtitle: 'درباره بخش استاد',
          onTap: onOpenAbout,
        ),
        _MoreTile(
          icon: Icons.logout,
          title: appText(lang, 'logout'),
          subtitle: 'خروج از حساب کاربری',
          onTap: appState.logout,
        ),
      ],
    );
  }
}

class _ProfessorServicesPage extends StatelessWidget {
  final VoidCallback onBack;

  const _ProfessorServicesPage({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final List<_ServiceItem> services = <_ServiceItem>[
      _ServiceItem(Icons.translate, 'ترجمه مدارک'),
      _ServiceItem(Icons.print_outlined, 'پرینت و کپی'),
      _ServiceItem(Icons.volunteer_activism_outlined, 'خدمات رفاهی'),
      _ServiceItem(Icons.local_library_outlined, 'کتابخانه'),
      _ServiceItem(Icons.support_agent_outlined, 'پشتیبانی'),
    ];

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        ListTile(
          dense: true,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
          leading: const Icon(Icons.arrow_back, size: 20),
          title: const Text('بازگشت', style: TextStyle(fontSize: 13)),
          onTap: onBack,
        ),
        const Divider(height: 12),
        GridView.builder(
          itemCount: services.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 4.2,
          ),
          itemBuilder: (BuildContext context, int index) {
            final _ServiceItem item = services[index];

            return Container(
              decoration: AppDecorations.cardDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(item.icon, size: 15, color: AppColors.primary),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ProfessorSettingsPage extends StatelessWidget {
  final VoidCallback onBack;

  const _ProfessorSettingsPage({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        ListTile(
          dense: true,
          leading: const Icon(Icons.arrow_back, size: 20),
          title: const Text('بازگشت', style: TextStyle(fontSize: 13)),
          onTap: onBack,
        ),
        const SizedBox(height: 8),
        SectionCard(
          title: appText(lang, 'settings'),
          icon: Icons.settings_outlined,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: Text(isRtlLang(lang) ? 'حالت تیره' : 'Dark Mode'),
                subtitle: Text(
                  isRtlLang(lang)
                      ? 'همچنین از آیکن خورشید/ماه در بالای صفحه می‌توانید تم را عوض کنید.'
                      : 'Use sun/moon in the header to switch theme.',
                ),
                value: appState.isDarkMode,
                onChanged: appState.setDarkMode,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    appText(lang, 'language'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppLang.values.map((AppLang item) {
                    return ChoiceChip(
                      label: Text(langCode(item)),
                      selected: lang == item,
                      onSelected: (_) => appState.setLanguage(item),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: isRtlLang(lang) ? 'اعلان‌ها' : 'Notifications',
          icon: Icons.notifications_none,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: Text(
                  isRtlLang(lang) ? 'اعلان کلاس و پیام مدیر' : 'Class & manager alerts',
                ),
                value: true,
                onChanged: (_) {},
              ),
              SwitchListTile(
                title: Text(
                  isRtlLang(lang) ? 'اعلان درخواست امتحان/اتاق' : 'Exam / room requests',
                ),
                value: true,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: isRtlLang(lang) ? 'امنیت' : 'Security',
          icon: Icons.security_outlined,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(
                  isRtlLang(lang) ? 'تغییر رمز عبور' : 'Change password',
                ),
                subtitle: Text(
                  isRtlLang(lang)
                      ? 'با اتصال Supabase از طریق Auth یا جدول کاربران'
                      : 'Via Supabase Auth or users table',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfessorSimplePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;
  final VoidCallback onBack;

  const _ProfessorSimplePage({
    required this.title,
    required this.icon,
    required this.text,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        ListTile(
          dense: true,
          leading: const Icon(Icons.arrow_back, size: 20),
          title: const Text('بازگشت', style: TextStyle(fontSize: 13)),
          onTap: onBack,
        ),
        const Divider(height: 1),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(text),
        ),
      ],
    );
  }
}

class _CompactDashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CompactDashboardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppDecorations.cardDecoration,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Row(
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 15, color: AppColors.primary),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
      trailing: const Icon(Icons.chevron_right, size: 17),
      onTap: onTap,
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String title;

  const _ServiceItem(this.icon, this.title);
}

class _ProfessorTab {
  final String keyName;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;

  const _ProfessorTab({
    required this.keyName,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });
}
