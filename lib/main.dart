import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/application/Splash/splash_screen.dart';
import 'package:musix/utils/constants.dart';

import 'application/Authentication/view/login_screen.dart';
import 'application/Authentication/view/register_screen.dart';
import 'application/Home/view/home_screen.dart';
import 'application/Theme/theme_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(BlocProvider(
    create: (context) => ThemeBloc()..add(InitialThemeSetEvent()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Musix',
          theme: state,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/register': (context) => const RegisterScreen(),
          },
        );
      },
    );
  }
}
