import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karcisin_app/utils/date_helper.dart';
import '../../bloc/event/event_bloc.dart';
import '../../bloc/event/event_state.dart';
import '../../widgets/event_card.dart';
import '../../widgets/loading_state_widget.dart';
import '../../widgets/error_state_widget.dart';
import '../../bloc/event/event_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<EventBloc>().add(FetchEvents());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Karcis.in"),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          // 1. Kondisi saat Loading
          if (state is EventLoading) {
            return const LoadingStateWidget();
          }

          // 2. Kondisi saat Data Berhasil Dimuat
          if (state is EventLoaded) {
            if (state.events.isEmpty) {
              return const Center(child: Text("Belum ada Event"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return EventCard(
                  title: event.title,
                  date: event.startDate.toFullEventDate(),
                  imageUrl: event.image,
                  onTap: () {
                    // Navigasi ke Detail Event (shared folder)
                  },
                );
              },
            );
          }

          // 3. Kondisi saat terjadi Error
          if (state is EventError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () {
                context.read<EventBloc>().add(FetchEvents());
              },
            );
            // print("Error: ${state.message}");
          }

          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }
}


