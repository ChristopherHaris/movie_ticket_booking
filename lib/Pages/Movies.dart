import 'package:flutter/material.dart';
import 'package:sea_cinema/Function/booking_state.dart';
import 'package:sea_cinema/Function/booking_transaction.dart';
import 'package:sea_cinema/Pages/History.dart';
import 'package:sea_cinema/Pages/TopUp.dart';

import 'package:sea_cinema/Function/balance.dart';

import '../Function/parser.dart';
import 'Detail.dart';

class MoviesPage extends StatefulWidget {
  final BookingTransaction bookingTransaction;
  final Balance balance;
  final BookingState bookingState;
  final movies = fetchMovies();

  MoviesPage({super.key, 
    required this.balance,
    required this.bookingTransaction, required this.bookingState,
  });

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  List<String> purchasedTickets = [];

  void addTicket(String ticket) {
    setState(() {
      purchasedTickets.add(ticket);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch movie data from an API or use local data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'history',
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Transaction History'),
                ),
              ),
              const PopupMenuItem(
                value: 'topup',
                child: ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text('Top Up'),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryPage(
                      bookingTransaction: widget.bookingTransaction,
                    ),
                  ),
                );
              } else if (value == 'topup') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TopUpPage(
                          balance: widget.balance, fromPaymentPage: false)),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: widget.movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load movies'),
            );
          } else {
            final movies = snapshot.data;
            if (movies != null && movies.isNotEmpty) {
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return ListTile(
                    leading: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                      ),
                      child:
                          Image.network(movie.posterUrl, fit: BoxFit.fitHeight),
                    ),
                    title: Text(movie.title),
                    subtitle: Text(movie.description),
                    trailing: Text('Age Rating: ${movie.ageRating}+'),
                    onTap: () {
                      // Navigate to the movie details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsPage(
                            movie: movie,
                            balance: widget.balance,
                            bookingTransaction: widget.bookingTransaction,
                            bookingState: widget.bookingState,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No movies available'),
              );
            }
          }
        },
      ),
    );
  }
}
