import 'package:flutter/material.dart';
import 'package:sea_cinema/Function/booking_transaction.dart';
import 'package:sea_cinema/Pages/Ticket.dart';

class TransactionHistoryPage extends StatefulWidget {
  final BookingTransaction bookingTransaction;

  const TransactionHistoryPage({Key? key, required this.bookingTransaction})
      : super(key: key);

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const InkWell(child: Icon(Icons.arrow_back)),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.bookingTransaction.transactions.length,
        itemBuilder: (context, index) {
          final transaction = widget.bookingTransaction.transactions[index];
          return ListTile(
            title: Text('Movie: ${transaction.movieTitle}'),
            subtitle: Text('Booker: ${transaction.bookerName}'),
            trailing: Text('Cost: ${transaction.totalCost}'),
            onTap: () {
              // Navigate to the ticket detail page with the selected transaction
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketDetailPage(transaction: transaction),
                ),
              );
            },
          );
        },
      ),
    );
  }
}