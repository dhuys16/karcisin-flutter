class CreateEventRequest {
  final String title;
  final String description;
  final int categoryId;
  final double price;
  final String startDate;
  final String location;
  final double latitude;
  final double longitude;

  CreateEventRequest({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.startDate,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category_id': categoryId,
      'price': price,
      'start_date': startDate,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
