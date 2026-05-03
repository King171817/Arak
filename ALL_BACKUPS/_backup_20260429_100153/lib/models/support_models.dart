import 'package:flutter/material.dart';

class SupportChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  
  SupportChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class SuggestedQuestion {
  final String title;
  final String subtitle;
  final IconData icon;
  final String question;
  
  SuggestedQuestion({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.question,
  });
}
