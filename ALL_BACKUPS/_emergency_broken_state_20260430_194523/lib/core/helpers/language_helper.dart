import 'package:flutter/material.dart';
import '../../models/auth/app_lang.dart';
import '../constants/app_texts.dart';

TextDirection textDirectionOf(AppLang lang) {
  return isRtlLang(lang) ? TextDirection.rtl : TextDirection.ltr;
}

TextAlign textAlignOf(AppLang lang) {
  return isRtlLang(lang) ? TextAlign.right : TextAlign.left;
}

Alignment alignmentStartOf(AppLang lang) {
  return isRtlLang(lang) ? Alignment.centerRight : Alignment.centerLeft;
}

Alignment alignmentEndOf(AppLang lang) {
  return isRtlLang(lang) ? Alignment.centerLeft : Alignment.centerRight;
}

EdgeInsets directionalPadding({
  required AppLang lang,
  double start = 0,
  double top = 0,
  double end = 0,
  double bottom = 0,
}) {
  if (isRtlLang(lang)) {
    return EdgeInsets.fromLTRB(end, top, start, bottom);
  }

  return EdgeInsets.fromLTRB(start, top, end, bottom);
}

String t(AppLang lang, String key) {
  return appText(lang, key);
}
