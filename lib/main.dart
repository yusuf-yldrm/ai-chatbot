import 'package:ai_chatbot/screens/chat/speech_screen.dart';
import 'package:ai_chatbot/screens/discover/discover_screen.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatbot/screens/paywall/paywall_screen.dart';
import 'package:ai_chatbot/screens/settings/settings_screen.dart';
import 'package:ai_chatbot/utils/store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Store(),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SiriScreen(),
        '/paywall': (context) => PaywallPage(),
        '/settings': (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
