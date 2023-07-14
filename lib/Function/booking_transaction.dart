class Transaction {
  final String bookerName;
  final String movieTitle;
  final List<int> seatNumbers;
  final List<int> selectedSeats;
  final double totalCost;

  Transaction({
    required this.selectedSeats,
    required this.bookerName,
    required this.movieTitle,
    required this.seatNumbers,
    required this.totalCost,
  });
}

class BookingTransaction {
  final List<Transaction> transactions;

  BookingTransaction({required this.transactions});
}

void onTransactionCompleted(
    Transaction transaction, BookingTransaction bookingTransaction) {
  // Add the transaction to the booking transaction's list
  bookingTransaction.transactions.add(transaction);

  // Perform any other necessary actions, such as updating UI, saving to database, etc.
}
