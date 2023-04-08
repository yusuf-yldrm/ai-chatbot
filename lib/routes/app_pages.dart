import 'package:get/get.dart';
import 'package:use/pages/bottom_bar/bottom_bar_binding.dart';
import 'package:use/pages/bottom_bar/bottom_bar_page.dart';
import 'package:use/pages/onboarding/onboarding_page.dart';
import 'package:use/pages/paywall/paywall_page.dart';
import 'package:use/pages/rating/rating_page.dart';
import 'package:use/pages/article/article_page.dart';
import 'package:use/pages/chat/chat_page.dart';

import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.BottomBar,
      page: () => BottomBarPage(),
      binding: BottomBarBinding(),
    ),
    GetPage(
      name: AppRoutes.Onboarding,
      page: () => OnboardingPage(),
    ),
    GetPage(
      name: AppRoutes.Rating,
      page: () => RatingPage(),
    ),
  ];
}
