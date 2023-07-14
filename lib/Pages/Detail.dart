import 'package:flutter/material.dart';
import 'package:sea_cinema/Function/booking_state.dart';
import 'package:sea_cinema/Function/booking_transaction.dart';

import '../Function/parser.dart';
import '../Function/balance.dart';
import 'Booking.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;
  final Balance balance;
  final BookingTransaction bookingTransaction;
  final BookingState bookingState;

  const MovieDetailsPage(
      {super.key, required this.movie,
      required this.balance,
      required this.bookingTransaction,
      required this.bookingState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  movie.posterUrl,
                  height: 350.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Age Rating: ${movie.ageRating}+',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Ticket Price: Rp ${movie.ticketPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                movie.description,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Handle booking button press
                  // You can navigate to the booking page or perform any other action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketBookingPage(
                        movie: movie,
                        balance: balance,
                        bookingTransaction: bookingTransaction,
                        bookingState: bookingState,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Book Tickets',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
