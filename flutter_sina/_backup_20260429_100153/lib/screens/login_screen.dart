import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../models/user_models.dart';
import '../data/mock_data.dart';
import 'home_screen.dart';
import '../professors/professor_home_screen.dart';
import '../education/education_admin_screen.dart';
import '../managers/manager_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showRegister = false;
  bool _showSupportChat = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final List<Map<String, dynamic>> _chatMessages = [];
  final ScrollController _scrollController = ScrollController();

  final Map<String, Map<String, String>> _users = {
    'admin': {'role': 'student', 'id': 's001', 'name': 'رضا حسینی', 'password': '1234'},
    'admin1': {'role': 'manager', 'id': 'international', 'name': 'مدیر امور بین‌الملل', 'password': '1234'},
    'admin2': {'role': 'manager', 'id': 'education', 'name': 'مدیر آموزش', 'password': '1234'},
    'admin3': {'role': 'manager', 'id': 'student_services', 'name': 'مدیر خدمات دانشجویی', 'password': '1234'},
    'admin4': {'role': 'manager', 'id': 'consular', 'name': 'مدیر کنسولی', 'password': '1234'},
    'prof1': {'role': 'professor', 'id': 'p001', 'name': 'دکتر محمدی', 'password': '1234'},
    'prof2': {'role': 'professor', 'id': 'p002', 'name': 'Dr. Johnson', 'password': '1234'},
    'edu_admin': {'role': 'education_admin', 'id': 'edu001', 'name': 'مدیر آموزش', 'password': '1234'},
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    _chatMessages.add({
      'text': 'سلام! 👋\nمن دستیار پشتیبانی دانشگاه اراک هستم.\nچطور می‌توانم به شما کمک کنم؟',
      'isUser': false,
      'timestamp': DateTime.now(),
    });
  }

  void _sendChatMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _chatMessages.add({
        'text': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _chatController.clear();
    });
    
    _scrollToBottom();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _chatMessages.add({
            'text': _getAutoResponse(text),
            'isUser': false,
            'timestamp': DateTime.now(),
          });
        });
        _scrollToBottom();
      }
    });
  }
  
  String _getAutoResponse(String message) {
    final msg = message.toLowerCase();
    if (msg.contains('ورود') || msg.contains('login')) {
      return '🔐 راهنمای ورود:\n\n• دانشجو: admin\n• مدیران: admin1 تا admin4\n• استاد: prof1 یا prof2\n• رمز عبور همه: 1234';
    }
    if (msg.contains('ثبت نام') || msg.contains('register')) {
      return '📝 برای ثبت نام، لطفاً با واحد آموزش دانشگاه تماس بگیرید.\n\n📞 شماره تماس: ۰۸۶-۳۲۲۳۰۴۲۱';
    }
    if (msg.contains('رمز') || msg.contains('فراموش')) {
      return '🔑 برای بازیابی رمز عبور، روی گزینه "فراموشی رمز" کلیک کنید.\n\n📧 ایمیل: support@araku.ac.ir';
    }
    if (msg.contains('تماس') || msg.contains('شماره')) {
      return '📞 اطلاعات تماس:\n\nپشتیبانی: ۰۸۶-۳۲۲۳۰۴۲۱\nآموزش: ۰۸۶-۳۲۲۳۰۴۲۲\nبین‌الملل: ۰۸۶-۳۲۲۳۰۴۲۳';
    }
    if (msg.contains('سلام') || msg.contains('hello') || msg.contains('hi')) {
      return 'سلام! 👋 چطور می‌توانم به شما کمک کنم؟';
    }
    return '🤔 سوال شما را متوجه نشدم.\n\nلطفاً یکی از موارد زیر را انتخاب کنید:\n• راهنمای ورود\n• ثبت نام\n• فراموشی رمز\n• تماس با ما';
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    if (username.isEmpty || password.isEmpty) {
      _showError('لطفاً نام کاربری و رمز عبور را وارد کنید');
      return;
    }
    
    final user = _users[username];
    if (user == null) {
      _showError('نام کاربری یا رمز عبور اشتباه است');
      return;
    }
    
    if (password != user['password']) {
      _showError('نام کاربری یا رمز عبور اشتباه است');
      return;
    }
    
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    final appState = Provider.of<AppState>(context, listen: false);
    appState.login(user['role']!, user['id']!, user['name']!);
    
    if (!mounted) return;
    
    Widget nextScreen;
    switch (user['role']) {
      case 'student':
        nextScreen = const HomeScreen();
        break;
      case 'professor':
        nextScreen = const ProfessorHomeScreen();
        break;
      case 'education_admin':
        nextScreen = const EducationAdminScreen();
        break;
      case 'manager':
        nextScreen = ManagerHomeScreen(managerUnitKey: user['id']!);
        break;
      default:
        nextScreen = const LoginScreen();
    }
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => nextScreen));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedLang = appState.selectedLang;
    final isRtl = isRtlLang(selectedLang);
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE8F5E9), Colors.white],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.account_balance_outlined,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'دانشگاه اراک',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'سامانه آموزش مجازی',
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      if (!_showSupportChat)
                        _buildLoginForm(appState, selectedLang, isRtl)
                      else
                        _buildSupportChat(isRtl),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                
                // دکمه پشتیبانی شناور
                if (!_showSupportChat)
                  Positioned(
                    bottom: 20,
                    right: isRtl ? null : 20,
                    left: isRtl ? 20 : null,
                    child: FloatingActionButton(
                      onPressed: () => setState(() => _showSupportChat = true),
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.support_agent, color: Colors.white),
                      tooltip: 'پشتیبانی',
                    ),
                  ),
                
                // دکمه بازگشت در حالت چت
                if (_showSupportChat)
                  Positioned(
                    bottom: 20,
                    right: isRtl ? null : 20,
                    left: isRtl ? 20 : null,
                    child: FloatingActionButton(
                      onPressed: () => setState(() => _showSupportChat = false),
                      backgroundColor: Colors.grey,
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                      tooltip: 'بازگشت',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AppState appState, AppLang selectedLang, bool isRtl) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AppLang.values.map((lang) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(langCode(lang)),
                  selected: appState.selectedLang == lang,
                  onSelected: (_) => appState.setLanguage(lang),
                  selectedColor: Colors.green,
                  labelStyle: TextStyle(color: appState.selectedLang == lang ? Colors.white : Colors.black),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'نام کاربری',
              hintText: 'admin, prof1, edu_admin, ...',
              prefixIcon: const Icon(Icons.person, color: Colors.green),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'رمز عبور',
              hintText: '1234',
              prefixIcon: const Icon(Icons.lock, color: Colors.green),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                  : const Text('ورود به سامانه', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          
          OutlinedButton(
            onPressed: () => setState(() => _showRegister = !_showRegister),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(_showRegister ? 'قبلاً ثبت‌نام کرده‌ام' : 'ثبت‌نام کاربر جدید'),
          ),
          
          if (_showRegister) ...[
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'شماره دانشجویی',
                prefixIcon: const Icon(Icons.badge, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'ایمیل',
                prefixIcon: const Icon(Icons.email, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showError('ثبت‌نام فعلاً به صورت مفهومی انجام شد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('ثبت‌نام'),
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('📋 راهنمای ورود:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'دانشجو: admin\nاستاد: prof1, prof2\nمدیر آموزش: edu_admin\nمدیران واحد: admin1 تا admin4\nرمز عبور: 1234',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportChat(bool isRtl) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.support_agent, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'پشتیبانی دانشگاه اراک',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('آنلاین', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
          ),
          
          // سوالات سریع
          Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickChip('راهنمای ورود', () => _sendQuickMessage('راهنمای ورود')),
                  _buildQuickChip('ثبت نام', () => _sendQuickMessage('ثبت نام')),
                  _buildQuickChip('فراموشی رمز', () => _sendQuickMessage('فراموشی رمز')),
                  _buildQuickChip('تماس با ما', () => _sendQuickMessage('تماس با ما')),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final msg = _chatMessages[index];
                return _buildMessageBubble(msg, isRtl);
              },
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'پیام خود را بنویسید...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendChatMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: _sendChatMessage,
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: Colors.green.shade50,
        side: BorderSide(color: Colors.green.shade200),
      ),
    );
  }

  void _sendQuickMessage(String message) {
    setState(() {
      _chatMessages.add({
        'text': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _chatMessages.add({
            'text': _getAutoResponse(message),
            'isUser': false,
            'timestamp': DateTime.now(),
          });
        });
        _scrollToBottom();
      }
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isRtl) {
    final isUser = msg['isUser'] as bool;
    return Align(
      alignment: isUser ? (isRtl ? Alignment.centerRight : Alignment.centerLeft) : (isRtl ? Alignment.centerLeft : Alignment.centerRight),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(msg['text'], style: const TextStyle(fontSize: 14, height: 1.4)),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg['timestamp']),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
