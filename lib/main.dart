import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karcisin_app/bloc/event/event_bloc.dart';
import 'package:karcisin_app/bloc/event/event_event.dart';
import 'package:karcisin_app/repositories/event_repositories.dart';
import 'package:karcisin_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Membungkus dengan RepositoryProvider agar Repository bisa diakses global
    return RepositoryProvider(
      create: (context) => EventRepository(),
      child: MultiBlocProvider(
        // 2. Membungkus dengan MultiBlocProvider (antisipasi jika nanti tambah AuthBloc, dll)
        providers: [
          BlocProvider(
            create: (context) => EventBloc(
              eventRepository: RepositoryProvider.of<EventRepository>(context),
            )..add(FetchEvents()), // Langsung memicu pengambilan data saat start
          ),
        ],
        child: MaterialApp(
          title: 'Karcisin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}