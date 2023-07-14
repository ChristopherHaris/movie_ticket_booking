import 'package:flutter/material.dart';

import '../Function/balance.dart';

class TopUpPage extends StatefulWidget {
  final Balance balance;
  final bool fromPaymentPage;

  const TopUpPage({super.key, required this.balance, required this.fromPaymentPage});

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  double topUpAmount = 0.0;

  void topUp() {
    setState(() {
      widget.balance.amount +=
          topUpAmount; // Update the balance with the top-up amount
      topUpAmount = 0.0; // Reset the top-up amount
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Top-Up Success'),
        content: const Text('Your balance has been updated.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              if (widget.fromPaymentPage) {
                Navigator.pop(context);
                Navigator.pop(context);
                // Go back to the previous route (PaymentPage)
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top-Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current Balance: ${widget.balance.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Top-Up Amount:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  topUpAmount =
                      double.tryParse(value) ?? 0.0; // Parse the top-up amount
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (topUpAmount > 0.0) {
                  topUp(); // Perform the top-up
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Invalid Top-Up Amount'),
                      content: const Text('Please enter a valid top-up amount.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Top-Up'),
            ),
          ],
        ),
      ),
    );
  }
}
