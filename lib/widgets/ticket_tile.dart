import 'package:flutter/material.dart';

class TicketTile extends StatelessWidget {
  final String eventName;
  final String status;

  const TicketTile({super.key, required this.eventName, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.confirmation_number_outlined),
      title: Text(eventName),
      subtitle: Text("Status: $status"),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {

      },
    );
  }
}
