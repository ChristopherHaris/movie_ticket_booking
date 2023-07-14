import 'package:flutter/material.dart';
import 'package:sea_cinema/Function/balance.dart';
import 'package:sea_cinema/Pages/History.dart';
import 'package:sea_cinema/Pages/TopUp.dart';

import '../Function/booking_transaction.dart';

class PaymentPage extends StatefulWidget {
  final String bookerName;
  final String movieTitle;
  final List<int> seatNumbers;
  final double totalCost;
  final Balance balance;
  final Function(Transaction, BookingTransaction) onTransactionCompleted;
  final List<int> selectedSeats;
  final BookingTransaction bookingTransaction;

  const PaymentPage({super.key, 
    required this.bookerName,
    required this.movieTitle,
    required this.seatNumbers,
    required this.totalCost,
    required this.balance,
    required this.onTransactionCompleted,
    required this.selectedSeats,
    required this.bookingTransaction,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  void performPayment(BuildContext context) {
    if (widget.balance.amount >= widget.totalCost) {
      // Sufficient balance, deduct the payment
      widget.balance.amount -= widget.totalCost;
      // Create a booking transaction object
      final transaction = Transaction(
        bookerName: widget.bookerName,
        movieTitle: widget.movieTitle,
        seatNumbers: widget.selectedSeats,
        totalCost: widget.totalCost,
        selectedSeats: widget.selectedSeats,
      );

      onTransactionCompleted(transaction, widget.bookingTransaction);

      // TODO: Save the booking transaction to your database or storage

      // Show a success dialog after the payment
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Success'),
          content: const Text('Thank you for your payment.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryPage(
                      bookingTransaction: widget.bookingTransaction,
                    ),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Insufficient balance, show an error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Insufficient Balance'),
          content: const Text('Please top up your balance.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopUpPage(
                        balance: widget.balance, fromPaymentPage: true),
                  ),
                );
                // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Movie: ${widget.movieTitle}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected Seats: ${widget.seatNumbers.join(", ")}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Cost: ${widget.totalCost}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                performPayment(context); // Perform the payment
              },
              child: const Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
