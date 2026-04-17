import 'dart:async';
import '../models/event_model.dart';

class EventRepository {
  Future<List<EventModel>> getDummyEvents() async {
    await Future.delayed(const Duration(seconds: 2));

    // Data simulasi sesuai kolom di database Laravel temanmu
    List<Map<String, dynamic>> dummyData = [
      {
        'id': 1,
        'title': 'Konser Musik Bogor',
        'slug': 'konser-musik-bogor',
        'description': 'Nikmati malam minggu seru dengan band indie lokal.',
        'quota': 100,
        'latitude': -6.5971,
        'longitude': 106.8060,
        'location': 'Lapangan Sempur, Bogor',
        'start_date': '2026-05-20 19:00:00',
        'end_date': '2026-05-20 23:00:00',
        'price': 50000.00,
        'status': 'published',
        'image': 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4',
        'category_id': 1,
        'user_id': 1,
      },
      {
        'id': 2,
        'title': 'Workshop Flutter Dasar',
        'slug': 'workshop-flutter-dasar',
        'description': 'Belajar bikin aplikasi mobile dari nol.',
        'quota': null, // Simulasi infinite quota sesuai database
        'latitude': -6.6000,
        'longitude': 106.8100,
        'location': 'IDN Polytechnic',
        'start_date': '2026-05-25 09:00:00',
        'end_date': '2026-05-25 15:00:00',
        'price': 0.00,
        'status': 'published',
        'image': 'https://images.unsplash.com/photo-1517048676732-d65bc937f952',
        'category_id': 2,
        'user_id': 1,
      }
    ];

    return dummyData.map((e) => EventModel.fromJson(e)).toList();
  }
}