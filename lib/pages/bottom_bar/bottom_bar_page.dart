import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:use/pages/chatgpt/chatgpt_page.dart';
import 'package:use/pages/dalle/dalle_page.dart';
import 'package:use/pages/settings/settings_page.dart';

import 'bottom_bar_controller.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => BottomBarPageState();
}

class BottomBarPageState extends State<BottomBarPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                ChatGPTPage(),
                DallePage(),
                SettingsPage(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor:
                CupertinoColors.systemBackground.withOpacity(0.6),
            selectedItemColor: CupertinoColors.systemBackground,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey[201],
            elevation: 0,
            items: [
              _bottomNavigationBarItem(
                icon: CupertinoIcons.chat_bubble,
                label: 'GPT-3',
              ),
              _bottomNavigationBarItem(
                icon: CupertinoIcons.photo_on_rectangle,
                label: 'DALL·E 2',
              ),
              _bottomNavigationBarItem(
                icon: CupertinoIcons.settings_solid,
                label: 'Settings',
              ),
            ],
            unselectedLabelStyle: TextStyle(fontSize: 11),
            selectedLabelStyle: TextStyle(fontSize: 11),
          ),
        );
      },
    );
  }

  _bottomNavigationBarItem({IconData? icon, String? label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
