import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karcisin_app/bloc/auth/auth_bloc.dart'; 
import 'package:karcisin_app/bloc/event/event_bloc.dart';
import 'package:karcisin_app/bloc/event/event_event.dart';
import 'package:karcisin_app/repositories/event_repository.dart';
import 'package:karcisin_app/screens/main_nav.dart';
import 'package:karcisin_app/screens/splash_screen.dart';
import 'package:karcisin_app/screens/auth/login_screen.dart';

import 'package:karcisin_app/screens/auth/register_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => EventRepository(),
      child: MultiBlocProvider(
        providers: [
          // 2. DAFTARKAN AUTHBLOC DI SINI
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          // EventBloc biarkan seperti semula
          BlocProvider(
            create: (context) => EventBloc(
              eventRepository: RepositoryProvider.of<EventRepository>(context),
            )..add(FetchEvents()),
          ),
        ],
        child: MaterialApp(
          title: 'Karcisin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/user-home': (context) => const MainNav(),
            '/owner-dashboard': (context) => const Center(child: Text("Halaman Owner")), 
            '/admin-dashboard': (context) => const Center(child: Text("Halaman Admin")),
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}