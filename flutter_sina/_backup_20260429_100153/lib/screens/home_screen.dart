import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/user_models.dart';
import '../data/mock_data.dart';
import 'class_session_screen.dart';
import 'profile_screen.dart';
import 'support_chat_screen.dart';
import '../widgets/header_widget.dart';
import '../widgets/manager_chat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? activeTopPanel;
  int _selectedBottomNavIndex = 0;
  late List<ClassModel> _myClasses;
  
  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _myClasses = getClassesForStudent(appState.userIdentifier);
  }

  void togglePanel(String key) {
    setState(() {
      activeTopPanel = activeTopPanel == key ? null : key;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedLang = appState.selectedLang;
    final isRtl = isRtlLang(selectedLang);
    final userRole = appState.userRole;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: <Widget>[
            HeaderWithInteractiveSidePanel(
              activePanel: activeTopPanel,
              onPanelToggle: togglePanel,
            ),
            const SizedBox(height: 20),
            _buildBody(),
            const SizedBox(height: 70),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (int index) {
            setState(() {
              _selectedBottomNavIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '???????'),
            BottomNavigationBarItem(icon: Icon(Icons.forum_outlined), activeIcon: Icon(Icons.forum), label: '?????? ?? ??????'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: '?????'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupportChatScreen()),
            );
          },
          icon: const Icon(Icons.support_agent_outlined),
          label: Text('????????'),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedBottomNavIndex) {
      case 0:
        return _buildClassesPage();
      case 1:
        return _buildManagersCommunicationPage();
      default:
        return _buildMorePage();
    }
  }

  // ==================== ???? ??????? ====================
  
  Widget _buildClassesPage() {
    if (_myClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              '??? ????? ???? ??? ??? ???? ???',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '???????? ??',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 12),
        ..._myClasses.map((classItem) => _buildClassCard(classItem)),
      ],
    );
  }

  Widget _buildClassCard(ClassModel classItem) {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClassSessionScreen(
                classId: classItem.id,
                className: classItem.name,
                professorName: classItem.professorName,
                isActive: classItem.isActive,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.class_, color: Colors.green, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classItem.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '?????: ${classItem.professorName}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: classItem.isActive ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      classItem.isActive ? '????' : '?? ??????',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    classItem.schedule,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${classItem.studentIds.length} ??????',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClassSessionScreen(
                              classId: classItem.id,
                              className: classItem.name,
                              professorName: classItem.professorName,
                              isActive: classItem.isActive,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('???? ?? ????'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== ?????? ?? ?????? ====================
  
  Widget _buildManagersCommunicationPage() {
    final selectedLang = Provider.of<AppState>(context).selectedLang;
    final isRtl = isRtlLang(selectedLang);

    final allManagers = [
      {'unitKey': 'international', 'unitName': '???? ?????????', 'icon': Icons.public},
      {'unitKey': 'student_services', 'unitName': '????? ????????', 'icon': Icons.support_agent},
      {'unitKey': 'education', 'unitName': '?????', 'icon': Icons.school},
      {'unitKey': 'consular', 'unitName': '??????', 'icon': Icons.badge},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isRtl ? '?????? ?????? ?? ?????? ??????' : 'Direct Communication with Unit Managers',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 8),
        Text(
          isRtl ? '???? ?????? ?????? ? ?????? ?????????? ?? ???? ?? ???? ?? ?????? ?????' : 'Contact managers directly',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: allManagers.map((manager) {
              return ManagerChatCard(
                managerName: manager['unitName']!.toString(),
                icon: manager['icon'] as IconData,
                unreadCount: 0,
                onTap: () {
                  _showManagerChatDialog(manager['unitKey']!.toString(), manager['unitName']!.toString());
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showManagerChatDialog(String unitKey, String unitName) {
    final TextEditingController messageController = TextEditingController();
    final isRtl = isRtlLang(Provider.of<AppState>(context).selectedLang);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [
          Icon(Icons.chat, color: Colors.green),
          const SizedBox(width: 8),
          Text('${isRtl ? '????? ???? ??' : 'Send message to'} $unitName')
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(isRtl ? '???? ??? ???????? ?? ???? ???? ????? ????? ??.' : 'Your message will be sent directly to the manager.'),
          const SizedBox(height: 12),
          TextField(controller: messageController, maxLines: 4, decoration: InputDecoration(hintText: isRtl ? '???? ??? ?? ???????...' : 'Write your message...')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isRtl ? '??????' : 'Cancel')),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                final appState = Provider.of<AppState>(context, listen: false);
                appState.addNotification('???? ????', '????? ?? ??? ?????? ???? $unitName');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isRtl ? '???? ??? ????? ??' : 'Message sent'), backgroundColor: Colors.green));
              }
            },
            child: Text(isRtl ? '?????' : 'Send'),
          ),
        ],
      ),
    );
  }

  // ==================== ???? ????? ====================
  
  Widget _buildMorePage() {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(),
          const SizedBox(height: 16),
          _buildSettingsSection(),
          const SizedBox(height: 16),
          _buildOtherServicesSection(),
          const SizedBox(height: 16),
          _buildLogoutSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(16), child: Text('??????? ??????', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person, color: Colors.white)),
            title: const Text('???? ??????'),
            subtitle: const Text('??????? ?????????'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
    return StatefulBuilder(
      builder: (context, setState) {
        bool notificationsEnabled = true;
        bool darkModeEnabled = appState.isDarkMode;
        
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(16), child: Text('???????', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              const Divider(height: 1),
              SwitchListTile(title: const Text('????????'), value: notificationsEnabled, onChanged: (value) => setState(() => notificationsEnabled = value), activeColor: Colors.green),
              SwitchListTile(title: const Text('???? ??'), value: darkModeEnabled, onChanged: (value) { setState(() => darkModeEnabled = value); appState.toggleTheme(); }, activeColor: Colors.green),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtherServicesSection() {
    final selectedLang = Provider.of<AppState>(context).selectedLang;
    final isRtl = isRtlLang(selectedLang);
    
    final services = [
      {'key': 'taxi', 'icon': Icons.local_taxi, 'color': Colors.orange, 'title': '????? ???????'},
      {'key': 'library', 'icon': Icons.library_books, 'color': Colors.indigo, 'title': '????????'},
      {'key': 'restaurant', 'icon': Icons.restaurant, 'color': Colors.brown, 'title': '???????'},
      {'key': 'gym', 'icon': Icons.fitness_center, 'color': Colors.teal, 'title': '???? ?????'},
    ];
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(16), child: Text('???? ?????', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          const Divider(height: 1),
          ...services.map((service) => ListTile(
            leading: Icon(service['icon'] as IconData, color: service['color'] as Color),
            title: Text(service['title']!.toString()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(),
          )),
        ],
      ),
    );
  }

  Widget _buildLogoutSection() {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: Text(isRtl ? '???? ?? ???? ??????' : 'Logout', style: const TextStyle(color: Colors.red)),
        trailing: const Icon(Icons.chevron_right, color: Colors.red),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(isRtl ? '???? ?? ??????' : 'Logout'),
              content: Text(isRtl ? '??? ?? ???? ??? ??????? ??????' : 'Are you sure?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(isRtl ? '??????' : 'Cancel')),
                ElevatedButton(onPressed: () { appState.logout(); Navigator.pop(context); }, child: Text(isRtl ? '????' : 'Logout')),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('??? ??? ?? ???? ???? ??????'), backgroundColor: Colors.orange),
    );
  }
}

