import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karcisin_app/bloc/auth/auth_bloc.dart';
import 'package:karcisin_app/bloc/category/category_bloc.dart';
import 'package:karcisin_app/bloc/category/category_event.dart';
import 'package:karcisin_app/bloc/event/event_bloc.dart';
import 'package:karcisin_app/bloc/event/event_event.dart';
import 'package:karcisin_app/repositories/category_repository.dart';
import 'package:karcisin_app/repositories/event_repository.dart';
import 'package:karcisin_app/screens/main_nav.dart';
import 'package:karcisin_app/screens/splash_screen.dart';
import 'package:karcisin_app/screens/auth/login_screen.dart';
import 'package:karcisin_app/screens/auth/register_screen.dart';
import 'package:karcisin_app/shared/app_theme.dart';
import 'package:karcisin_app/screens/admin/dashboad_screen.dart';
import 'package:karcisin_app/repositories/user_repository.dart';
import 'package:karcisin_app/bloc/user/user_bloc.dart';
import 'package:karcisin_app/bloc/user/user_event.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => EventRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(
            create: (context) => EventBloc(
              eventRepository: RepositoryProvider.of<EventRepository>(context),
            )..add(FetchEvents()),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              repository: RepositoryProvider.of<CategoryRepository>(context),
            )..add(FetchCategories()),
          ),
          BlocProvider(
            create: (context) => UserBloc(
              repository: RepositoryProvider.of<UserRepository>(context),
            )..add(FetchAllUsers()), 
          ),
        ],
        child: MaterialApp(
          title: 'Karcisin',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/user-home': (context) => const MainNav(),
            '/owner-dashboard': (context) =>
                const Center(child: Text("Halaman Owner")),
            '/admin-dashboard': (context) => const AdminDashboardScreen(),
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
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
