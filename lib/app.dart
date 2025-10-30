import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jigyasa/constant/style/app.style.constant.dart';
import 'package:jigyasa/modules/auth/screen/login.page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jigyasa',
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const LoginPage(),
    );
  }
}