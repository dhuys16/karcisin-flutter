class EventModel {
  final int id;
  final String title;
  final String slug;
  final String description;
  final double latitude;
  final double longitude;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String status;
  final String image;
  final int? categoryId;
  final int userId;

  EventModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
    required this.image,
    this.categoryId,
    required this.userId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Ambil harga dari tiket pertama kalau ada, kalau nggak ada kasih 0
    List tickets = json['tickets'] ?? [];
    double eventPrice = 0.0;

    if (tickets.isNotEmpty) {
      eventPrice = double.tryParse(tickets[0]['price'].toString()) ?? 0.0;
    }

    return EventModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      location: json['location'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      price: eventPrice, // Gunakan harga yang diambil dari tickets
      status: json['status'],
      image: json['image'],
      categoryId: json['category_id'],
      userId: json['user_id'],
    );
  }
}
