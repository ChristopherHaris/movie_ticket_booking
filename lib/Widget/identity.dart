import 'package:flutter/material.dart';
import 'package:sea_cinema/Function/booking_state.dart';
import 'package:sea_cinema/Function/parser.dart';
import 'package:sea_cinema/Pages/Payment.dart';

import '../Function/balance.dart';
import '../Function/booking_transaction.dart';

class IdentityFormDialog extends StatefulWidget {
  final bool Function(int) validateAge;
  final Movie movie;
  final List<int> selectedSeats;
  final Balance balance;
  final BookingTransaction bookingTransaction;
  final BookingState bookingState;

  const IdentityFormDialog({
    super.key,
    required this.validateAge,
    required this.movie,
    required this.selectedSeats,
    required this.balance,
    required this.bookingTransaction,
    required this.bookingState,
  });

  @override
  _IdentityFormDialogState createState() => _IdentityFormDialogState();
}

class _IdentityFormDialogState extends State<IdentityFormDialog> {
  late TextEditingController nameController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void submitForm() {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text) ?? 0;
    final isAgeValid = widget.validateAge(age);
    final selectedSeats = widget.selectedSeats;

    if (name.isNotEmpty && isAgeValid) {
      // Perform ticket booking and payment logic

      Navigator.pop(context);
      double totalCost = widget.movie.ticketPrice * selectedSeats.length;

      // Create a BookingTransaction object with the booking details
      Transaction transaction = Transaction(
        bookerName: name, // Replace with the actual booker's name
        movieTitle: widget.movie.title,
        seatNumbers: selectedSeats,
        totalCost: totalCost, 
        selectedSeats: selectedSeats,
      );
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => PaymentPage(
            bookerName: name, // Replace with the actual booker's name
            movieTitle: widget.movie.title,
            seatNumbers: selectedSeats,
            totalCost: totalCost,
            balance: widget.balance,
            selectedSeats: widget.selectedSeats,
            bookingTransaction: widget.bookingTransaction,
            onTransactionCompleted: (Transaction, BookingTransaction) {
              widget.bookingTransaction.transactions.add(transaction);
            },
          ),
        ),
      ); // Close the dialog
    } else {
      if (name.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Name'),
            content: Text('Please Enter Your Name.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        if (age < widget.movie.ageRating && age > 0) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Age Restriction'),
              content: Text('You are not eligible to watch this movie.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Invalid Information'),
              content: Text('Please enter a valid name and age.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Your Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: ageController,
            decoration: InputDecoration(
              labelText: 'Age',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            submitForm();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
