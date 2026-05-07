class BookingResponse {
  final String? title;
  final String? message;
  final String? order_id;
  final String? snapToken; // Ini yang paling penting buat dipanggil Midtrans SDK[cite: 1, 2]
  final BookingData? data;

  BookingResponse({this.title, this.message, this.order_id, this.snapToken, this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      title: json['title'],
      message: json['message'],
      order_id: json['order_id'],
      snapToken: json['snap_token'], // Mapping dari snake_case ke camelCase[cite: 1, 2]
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
    );
  }
}

class BookingData {
  int userId;
  String ticketCode;
  String ticketPackageId;
  int price;
  String status;
  int quantity;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String snapToken;

  BookingData({
    required this.userId,
    required this.ticketCode,
    required this.ticketPackageId,
    required this.price,
    required this.status,
    required this.quantity,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.snapToken,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      // Samakan key dengan JSON Laravel (snake_case)
      userId: json['user_id'] ?? 0,
      ticketCode: json['ticket_code'] ?? '',

      // Karena di JSON postman tadi "1" (String), kita paksa ke String
      ticketPackageId: json['ticket_package_id']?.toString() ?? '',

      price: json['price'] ?? 0,
      status: json['status'] ?? '',
      quantity: json['quantity'] ?? 0,

      // Parsing String tanggal dari Laravel ke objek DateTime
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),

      id: json['id'] ?? 0,

      // Ini kuncinya biar webview Midtrans bisa jalan!
      snapToken: json['snap_token'] ?? '',
    );
  }

}