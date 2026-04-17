class EventModel {
  final int id;
  final String title;
  final String slug;
  final String description;
  final int? quota; // Di database bisa nullable
  final double latitude;
  final double longitude;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String status;
  final String image;
  final int categoryId;
  final int userId;

  EventModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    this.quota,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
    required this.image,
    required this.categoryId,
    required this.userId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      quota: json['quota'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      location: json['location'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      price: double.parse(json['price'].toString()),
      status: json['status'],
      image: json['image'],
      categoryId: json['category_id'],
      userId: json['user_id'],
    );
  }
}