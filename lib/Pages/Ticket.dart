import 'package:flutter/material.dart';

import '../Function/booking_transaction.dart';

class TicketDetailPage extends StatelessWidget {
  final Transaction transaction;

  const TicketDetailPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movie: ${transaction.movieTitle}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Booker: ${transaction.bookerName}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Seat Numbers: ${transaction.seatNumbers.join(", ")}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Selected Seats: ${transaction.selectedSeats.join(", ")}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Total Cost: \Rp${transaction.totalCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            // Add more ticket details as needed
          ],
        ),
      ),
    );
  }
}
