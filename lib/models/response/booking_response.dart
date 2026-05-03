class Booking {
  final int? id;
  final String? ticketCode; // Sesuai $table->string('ticket_code')
  final String? status; // Enum: pending, paid, used, cancelled
  final double? price;
  final String? proofOfPayment;
  final int? ticketPackageId;
  final int? userId;
  final String? createdAt;

  Booking({
    this.id,
    this.ticketCode,
    this.status,
    this.price,
    this.proofOfPayment,
    this.ticketPackageId,
    this.userId,
    this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    ticketCode: json["ticket_code"],
    status: json["status"],
    price: double.tryParse(json["price"].toString()),
    proofOfPayment: json["proof_of_payment"],
    ticketPackageId: json["ticket_package_id"],
    userId: json["user_id"],
    createdAt: json["created_at"],
  );
}