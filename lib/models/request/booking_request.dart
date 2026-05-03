class BookingRequest {
  final int ticketPackageId;
  final int quantity;
  final double totalPrice;

  BookingRequest({
    required this.ticketPackageId,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticket_package_id': ticketPackageId, 
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}