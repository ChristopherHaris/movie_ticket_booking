import 'package:flutter/material.dart';
import 'package:sea_cinema/Function/balance.dart';
import 'package:sea_cinema/Function/booking_state.dart';
import 'package:sea_cinema/Function/booking_transaction.dart';
import 'package:sea_cinema/Pages/Movies.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final Balance balance = Balance(amount: 0.0);
  final BookingTransaction bookingTransaction =
      BookingTransaction(transactions: []);
  final BookingState bookingState = BookingState();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MoviesPage(
        balance: balance,
        bookingTransaction: bookingTransaction,
        bookingState: bookingState,
      ),
    );
  }
}
