import 'package:danrom/resources/colors.dart';
import 'package:flutter/material.dart';

enum Availability { loading, available, unavailable }

class LanguageDisplay {
  static const String arabic = 'ar';
  static const String chinese = 'zh';
  static const String english = 'en';
  static const String indonesian = 'id';
  static const String system = 'system';
  static const String vietnamese = 'vi';
}

Map<String, String> languageDisplayStr = {'en': 'English', 'vi': 'Tiếng Việt'};

Map<String, bool> cardSkins = {'light.svg': false, 'dark.svg': true}; // 0: normal, 1: pro

final List<String> coinSkins = ['dollar', 'indian_rupee', 'test'];

const Map<String, Map<String, dynamic>> wheelSkins = {
  'style1': {
    'colors': [Color(0xFF333333), Color(0xFFF2F2F2)]
  },
  'style2': {
    'colors': [Color(0xFFEB5757), Color(0xFFF2F2F2)]
  },
  'style3': {
    'colors': [AppColor.transparent, Color(0xFFEBE6FF)],
    'gradient': LinearGradient(
        begin: Alignment.topLeft,
        colors: [AppColor.primaryColor1, AppColor.primaryColor2, AppColor.primaryColor1, AppColor.primaryColor2],
        end: Alignment.bottomRight),
  },
  'style4': {
    'colors': [
      Color(0xFFEB5757),
      Color(0xFFF2994A),
      Color(0xFFF2C94C),
      Color(0xFF2F80ED),
      Color(0xFF2D9CDB),
      Color(0xFF56CCF2),
      Color(0xFF9B51E0),
      Color(0XFFBD6BD9),
      Color(0xFF27AE60),
      Color(0xFF6FCF97)
    ]
  },
  'style5': {
    'colors': [Color(0xFF13C5CE), Color(0xFF5BE8EF)],
    'decoration': true
  }
};

class SharedPreferenceKey {
  /* FUNCTION */

  static const String cardLoop = "cardLoop";
  static const String allCardSkins = "cardSkins";
  static const String cardSkin = "cardSkin";

  static const String coinSkin = "coinSkin";

  static const String chooserWinners = "chooserWinners";
  static const String tapMode = "tapMode";

  static const String wheelChoices = 'wheelChoices';
  static const String wheelDuration = 'wheelDuration';
  static const String wheelLoop = 'wheelLoop';
  static const String wheelSkin = 'wheelSkin';
  /* ------------ */

  /* SYSTEM */
  static const String language = 'language';
  /* ------------ */

  /* DATA */
  static const String cardRepo = 'cardRepo';
  static const String coinRepo = 'coinRepo';
  static const String wheelRepo = 'wheelRepo';
}
