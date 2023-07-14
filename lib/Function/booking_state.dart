import 'package:sea_cinema/Function/booking_transaction.dart';

class BookingState {
  final Map<String, List<int>> movieSeatsMap;
  final Map<String, List<int>> selectedSeats;

  BookingState()
      : movieSeatsMap = {},
        selectedSeats = {};

  void selectSeat(String movieTitle, int seatNumber) {
    if (!movieSeatsMap.containsKey(movieTitle)) {
      movieSeatsMap[movieTitle] = [];
    }
    movieSeatsMap[movieTitle]!.add(seatNumber);

    if (!selectedSeats.containsKey(movieTitle)) {
      selectedSeats[movieTitle] = [];
    }
    selectedSeats[movieTitle]!.add(seatNumber);
  }

  void unselectSeat(String movieTitle, int seatNumber) {
    if (movieSeatsMap.containsKey(movieTitle)) {
      movieSeatsMap[movieTitle]!.remove(seatNumber);
      if (movieSeatsMap[movieTitle]!.isEmpty) {
        movieSeatsMap.remove(movieTitle);
      }
    }

    if (selectedSeats.containsKey(movieTitle)) {
      selectedSeats[movieTitle]!.remove(seatNumber);
      if (selectedSeats[movieTitle]!.isEmpty) {
        selectedSeats.remove(movieTitle);
      }
    }
  }

  void updateFromTransaction(BookingTransaction bookingTransaction) {
    for (final transaction in bookingTransaction.transactions) {
      final movieTitle = transaction.movieTitle;
      final selectedSeats = transaction.selectedSeats;
      
      if (!movieSeatsMap.containsKey(movieTitle)) {
        movieSeatsMap[movieTitle] = [];
      }
      movieSeatsMap[movieTitle]!.addAll(selectedSeats);

      if (!this.selectedSeats.containsKey(movieTitle)) {
        this.selectedSeats[movieTitle] = [];
      }
      this.selectedSeats[movieTitle]!.addAll(selectedSeats);
    }
  }

  bool isSelected(String movieTitle, int seatNumber) {
    return selectedSeats.containsKey(movieTitle) &&
        selectedSeats[movieTitle]!.contains(seatNumber);
  }
}
