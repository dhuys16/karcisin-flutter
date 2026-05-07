import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karcisin_app/bloc/auth/auth_bloc.dart';
import 'package:karcisin_app/bloc/auth/auth_event.dart';
import 'package:karcisin_app/bloc/category/category_bloc.dart';
import 'package:karcisin_app/bloc/category/category_event.dart';
import 'package:karcisin_app/bloc/event/event_bloc.dart';
import 'package:karcisin_app/bloc/event/event_event.dart';
import 'package:karcisin_app/repositories/category_repository.dart';
import 'package:karcisin_app/repositories/event_repository.dart';
import 'package:karcisin_app/bloc/profile/profile_bloc.dart';
import 'package:karcisin_app/bloc/profile/profile_event.dart';
import 'package:karcisin_app/repositories/profile_repository.dart';
import 'package:karcisin_app/screens/main_nav.dart';
import 'package:karcisin_app/screens/splash_screen.dart';
import 'package:karcisin_app/screens/auth/login_screen.dart';
import 'package:karcisin_app/screens/auth/register_screen.dart';
import 'package:karcisin_app/shared/app_theme.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:karcisin_app/repositories/booking_repository.dart';
import 'package:karcisin_app/bloc/booking/booking_bloc.dart';

MidtransSDK? midtransGlobal;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  // print("Data SharedPreferences berhasil dihapus paksa!");

  MidtransSDK.init(
    config: MidtransConfig(
      clientKey: 'Mid-client-gx007YpTSxC-QiY3',
      merchantBaseUrl: 'https://demo-merchant-server.herokuapp.com/',
    ),
  ).then((value) {
    midtransGlobal = value; // Simpan objek hasil init ke variabel global
    print("Midtrans Siap!");
  });

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
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => BookingRepository()), 
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()..add(AppStarted())),
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
            create: (context) =>
                ProfileBloc(RepositoryProvider.of<ProfileRepository>(context))
                  ..add(ProfileFetched()),
          ),
          BlocProvider(
            create: (context) =>
                BookingBloc(RepositoryProvider.of<BookingRepository>(context)),
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
