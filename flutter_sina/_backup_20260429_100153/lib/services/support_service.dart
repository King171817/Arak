import 'package:flutter/material.dart';
import '../utils/helpers.dart';
import '../models/support_models.dart';

class SupportService {
  static String getAutoResponse(String userMessage, AppLang selectedLang) {
    final lowerMsg = userMessage.toLowerCase();
    final bool isRtl = isRtlLang(selectedLang);
    
    if (lowerMsg.contains('سلام') || lowerMsg.contains('hi') || lowerMsg.contains('hello')) {
      return isRtl 
        ? 'سلام! 👋\nچطور می‌توانم به شما کمک کنم؟ سوالات خود را بپرسید.'
        : 'Hello! 👋\nHow can I help you? Ask your questions.';
    }
    
    if (lowerMsg.contains('ورود') || lowerMsg.contains('login')) {
      return isRtl
        ? '🔐 **راهنمای ورود:**\n\n• دانشجو: admin\n• مدیران: admin1 تا admin4\n• استاد: prof1 یا prof2\n• رمز عبور همه: 1234'
        : '🔐 **Login Guide:**\n\n• Student: admin\n• Managers: admin1 to admin4\n• Professor: prof1 or prof2\n• Password for all: 1234';
    }
    
    if (lowerMsg.contains('ثبت نام') || lowerMsg.contains('register')) {
      return isRtl
        ? '📝 **ثبت نام:**\n\nبرای ثبت نام جدید، لطفاً با واحد آموزش دانشگاه تماس بگیرید.\n\n📞 شماره تماس: ۰۸۶-۳۲۲۳۰۴۲۱\n✉️ ایمیل: education@araku.ac.ir'
        : '📝 **Registration:**\n\nFor new registration, please contact the Education department.\n\n📞 Phone: 086-32230421\n✉️ Email: education@araku.ac.ir';
    }
    
    if (lowerMsg.contains('رمز') || lowerMsg.contains('password') || lowerMsg.contains('فراموش')) {
      return isRtl
        ? '🔑 **بازیابی رمز عبور:**\n\n1. روی گزینه "رمز عبور را فراموش کرده‌اید؟" کلیک کنید\n2. ایمیل خود را وارد کنید\n3. رمز جدید برای شما ارسال می‌شود\n\n📞 پشتیبانی: ۰۸۶-۳۲۲۳۰۴۲۱\n✉️ support@araku.ac.ir'
        : '🔑 **Password Recovery:**\n\n1. Click on "Forgot Password"\n2. Enter your email\n3. New password will be sent to you\n\n📞 Support: 086-32230421\n✉️ support@araku.ac.ir';
    }
    
    if (lowerMsg.contains('تماس') || lowerMsg.contains('شماره') || lowerMsg.contains('phone')) {
      return isRtl
        ? '📞 **اطلاعات تماس:**\n\nپشتیبانی: ۰۸۶-۳۲۲۳۰۴۲۱\nآموزش: ۰۸۶-۳۲۲۳۰۴۲۲\nبین‌الملل: ۰۸۶-۳۲۲۳۰۴۲۳\n\n🕐 ساعت پاسخگویی: ۸ صبح تا ۱۶ عصر'
        : '📞 **Contact Information:**\n\nSupport: 086-32230421\nEducation: 086-32230422\nInternational: 086-32230423\n\n🕐 Hours: 8 AM to 4 PM';
    }
    
    if (lowerMsg.contains('ایمیل') || lowerMsg.contains('email')) {
      return isRtl
        ? '✉️ **ایمیل‌های دانشگاه:**\n\nپشتیبانی: support@araku.ac.ir\nآموزش: education@araku.ac.ir\nبین‌الملل: intl@araku.ac.ir\nاطلاعات: info@araku.ac.ir'
        : '✉️ **University Emails:**\n\nSupport: support@araku.ac.ir\nEducation: education@araku.ac.ir\nInternational: intl@araku.ac.ir\nInfo: info@araku.ac.ir';
    }
    
    if (lowerMsg.contains('مشکل') || lowerMsg.contains('problem') || lowerMsg.contains('error')) {
      return isRtl
        ? '⚠️ **ثبت مشکل:**\n\nمشکل شما ثبت شد. لطفاً جزئیات بیشتری ارسال کنید.\nکارشناسان ما در اسرع وقت با شما تماس می‌گیرند.'
        : '⚠️ **Report Issue:**\n\nYour issue has been recorded. Please send more details.\nOur experts will contact you soon.';
    }
    
    if (lowerMsg.contains('خداحافظ') || lowerMsg.contains('bye')) {
      return isRtl
        ? '👋 خداحافظ! هر زمان نیاز داشتید، ما اینجا هستیم.\nموفق باشید!'
        : '👋 Goodbye! We are here whenever you need us.\nGood luck!';
    }
    
    if (lowerMsg.contains('ممنون') || lowerMsg.contains('thank')) {
      return isRtl
        ? '🙏 خواهش می‌کنم! خوشحالم که توانستم کمک کنم.\n\nاگر سوال دیگری دارید، در خدمتم.'
        : '🙏 You\'re welcome! Glad I could help.\n\nIf you have any other questions, I\'m here.';
    }
    
    return isRtl
        ? '🤔 **سوال شما را متوجه نشدم.**\n\nلطفاً یکی از موارد زیر را مشخص کنید:\n\n🔐 راهنمای ورود\n📝 ثبت نام\n🔑 فراموشی رمز\n📞 شماره تماس\n✉️ ایمیل\n⚠️ مشکل فنی\n\nیا سوال خود را دقیق‌تر بپرسید.'
        : '🤔 **I didn\'t understand.**\n\nPlease specify one of these topics:\n\n🔐 Login guide\n📝 Registration\n🔑 Forgot password\n📞 Phone number\n✉️ Email\n⚠️ Technical issue\n\nOr ask your question more clearly.';
  }
  
  static List<SuggestedQuestion> getSuggestedQuestions(AppLang selectedLang) {
    final bool isRtl = isRtlLang(selectedLang);
    return [
      SuggestedQuestion(
        title: isRtl ? 'راهنمای ورود' : 'Login Guide',
        subtitle: isRtl ? 'اطلاعات ورود به سیستم' : 'Login information',
        icon: Icons.login,
        question: isRtl ? 'راهنمای ورود به سیستم' : 'Login guide',
      ),
      SuggestedQuestion(
        title: isRtl ? 'ثبت نام' : 'Registration',
        subtitle: isRtl ? 'نحوه ثبت نام جدید' : 'New registration',
        icon: Icons.app_registration,
        question: isRtl ? 'راهنمای ثبت نام' : 'Registration guide',
      ),
      SuggestedQuestion(
        title: isRtl ? 'فراموشی رمز' : 'Forgot Password',
        subtitle: isRtl ? 'بازیابی رمز عبور' : 'Password recovery',
        icon: Icons.lock_reset,
        question: isRtl ? 'فراموشی رمز عبور' : 'Forgot password',
      ),
      SuggestedQuestion(
        title: isRtl ? 'تماس با ما' : 'Contact Us',
        subtitle: isRtl ? 'شماره تماس و ایمیل' : 'Phone & email',
        icon: Icons.contact_phone,
        question: isRtl ? 'اطلاعات تماس' : 'Contact information',
      ),
    ];
  }
}
