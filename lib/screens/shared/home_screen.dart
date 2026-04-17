import 'package:flutter/material.dart';
import '../../widgets/event_card.dart';
import '../../repositories/event_repositories.dart';
import '../../models/event_model.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    if (_isSearching) {
      return WillPopScope(
        onWillPop: () async {
          setState(() {
            _isSearching = false;
          });
          return false;
        },
        child: Stack(
          children: [
            const SearchScreen(),
            // Tombol kembali (Back) untuk menutup pencarian
            Positioned(
              top: 40,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'karcis.in',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blueAccent, // Warna brand
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // TODO: Navigasi ke Profil
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?name=User&background=random',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Button
              InkWell(
                onTap: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Cari event impianmu...',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Kategori
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Musik', Icons.music_note),
                    _buildCategoryChip('Olahraga', Icons.sports_soccer),
                    _buildCategoryChip('Seminar', Icons.event_seat),
                    _buildCategoryChip('Teater', Icons.theater_comedy),
                    _buildCategoryChip('Festival', Icons.festival),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Event List
              const Text(
                'Event Mendatang',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              FutureBuilder<List<EventModel>>(
                future: EventRepository().getDummyEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada event yang tersedia.'));
                  }

                  final events = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
                        title: event.title,
                        date: "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}",
                        imageUrl: event.image,
                        onTap: () {
                          // TODO: Navigasi ke detail event
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: Colors.blueAccent),
        label: Text(label),
        onPressed: () {
          // TODO: Filter berdasarkan kategori
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
