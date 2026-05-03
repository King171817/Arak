import 'package:flutter/material.dart';
import '../utils/helpers.dart';

class AppState extends ChangeNotifier {
  AppLang _selectedLang = AppLang.fa;
  String _userRole = 'guest';
  String _userIdentifier = '';
  String _userName = '';
  bool _isDarkMode = false;
  bool _isLoggedIn = false;
  
  List<Map<String, dynamic>> _notifications = [];

  AppLang get selectedLang => _selectedLang;
  String get userRole => _userRole;
  String get userIdentifier => _userIdentifier;
  String get userName => _userName;
  bool get isDarkMode => _isDarkMode;
  bool get isLoggedIn => _isLoggedIn;
  List<Map<String, dynamic>> get notifications => _notifications;

  void setLanguage(AppLang lang) {
    if (_selectedLang != lang) {
      _selectedLang = lang;
      notifyListeners();
    }
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void login(String role, String identifier, String name) {
    _userRole = role;
    _userIdentifier = identifier;
    _userName = name;
    _isLoggedIn = true;
    _loadNotifications();
    notifyListeners();
  }

  void logout() {
    _userRole = 'guest';
    _userIdentifier = '';
    _userName = '';
    _isLoggedIn = false;
    notifyListeners();
  }
  
  void addNotification(String title, String body) {
    _notifications.insert(0, {
      'title': title,
      'body': body,
      'timestamp': DateTime.now(),
      'isRead': false,
    });
    notifyListeners();
  }
  
  void markNotificationAsRead(int index) {
    if (index < _notifications.length) {
      _notifications[index]['isRead'] = true;
      notifyListeners();
    }
  }
  
  void _loadNotifications() {
    _notifications = [
      {'title': 'خوش آمدید', 'body': 'به سامانه آموزش مجازی خوش آمدید', 'timestamp': DateTime.now(), 'isRead': false},
    ];
  }
  
  int getUnreadCount() {
    return _notifications.where((n) => n['isRead'] == false).length;
  }
}
