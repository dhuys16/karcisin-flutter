class BookingRequest {
  final int ticketPackageId;
  final int quantity;

  BookingRequest({
    required this.ticketPackageId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticket_package_id': ticketPackageId, 
      'quantity': quantity,
    };
  }
}