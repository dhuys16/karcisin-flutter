import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/booking/booking_bloc.dart';
import '../../../bloc/booking/booking_event.dart';
import '../../../bloc/booking/booking_state.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../models/response/event_response.dart';

class BookingScreen extends StatefulWidget {
  final EventResponse event;

  const BookingScreen({super.key, required this.event});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Color primaryColor = const Color(0xFF3758F9);
  int quantity = 1;

  // Asumsi untuk sekarang: menggunakan ID paket tiket pertama.
  final int defaultTicketPackageId = 1; 

  void _increment() {
    setState(() {
      if (quantity < 10) quantity++; 
    });
  }

  void _decrement() {
    setState(() {
      if (quantity > 1) quantity--; 
    });
  }

  @override
  Widget build(BuildContext context) {
    // Total harga dinamis: harga tiket dikali jumlah tiket
    final double totalPrice = widget.event.price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesan Tiket"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingWaitingPayment) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pesanan berhasil! Menunggu pembayaran."), backgroundColor: Colors.green),
            );
            Navigator.pop(context); 
          } else if (state is BookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ringkasan Pesanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(child: Text(widget.event.location, style: TextStyle(color: Colors.grey[600]))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text("Jumlah Tiket", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tiket Reguler\nRp ${widget.event.price.toStringAsFixed(0)}", style: const TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _decrement,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: quantity > 1 ? primaryColor : Colors.grey,
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: _increment,
                        icon: const Icon(Icons.add_circle_outline),
                        color: quantity < 10 ? primaryColor : Colors.grey,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Harga", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text("Rp ${totalPrice.toStringAsFixed(0)}", style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              BlocConsumer<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state is BookingFailure) {
                    // Muncul kalau Laravel atau Midtrans error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                    );
                  }
                  if (state is BookingWaitingPayment) {
                    // Opsional: Kasih tau user kalau webview mau muncul
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Menghubungkan ke Midtrans...")),
                    );
                  }
                },
                builder: (context, state) {
                  // Cegah double klik saat sedang proses loading
                  if (state is BookingLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is Authenticated) {
                        // Mengirimkan packageId, quantity, dan totalPrice ke BLoC
                        context.read<BookingBloc>().add(
                          CreateBooking(
                            token: authState.token,
                            packageId: defaultTicketPackageId,
                            quantity: quantity
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Harap login terlebih dahulu")),
                        );
                      }
                    },
                    child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}