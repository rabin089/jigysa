import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigyasa/app_state.dart';
import 'package:jigyasa/constant/style/app.style.constant.dart';
import 'package:jigyasa/modules/auth/screen/login.page.dart';
import 'package:jigyasa/modules/auth/screen/sign_up.page.dart';
import 'package:jigyasa/modules/home/screens/home_shell.page.dart';
import 'package:jigyasa/modules/profile/cubit/profile.cubit.dart';
import 'package:jigyasa/modules/profile/repository/profile.repo.dart';
import 'package:jigyasa/modules/profile/screens/profile.page.dart';
import 'package:jigyasa/services/local_storage/local_storage.services.dart';
import 'package:jigyasa/services/navigator/navigator.dart';

class App extends StatelessWidget {
  const App({super.key});

  Future<String> _determineInitialRoute() async {
    final token = await storageInstance.getData(key: 'accessToken');
    if (token != null && token.isNotEmpty) {
      return '/home';
    } else {
      return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _determineInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MainApp(initialRoute: snapshot.data!);
      },
    );
  }
}

class MainApp extends StatelessWidget {
  final String initialRoute;
  const MainApp({super.key, required this.initialRoute});                                                          

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(repository: ProfileRepository()),
        ),
      ],
      child: MaterialApp(
        title: "Jigyasa",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        navigatorKey: navigatorKey,
        initialRoute: initialRoute,
        routes: {
          '/home': (context) => const HomeShellPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
