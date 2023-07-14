import 'package:flutter/material.dart';
import 'package:sea_cinema/Function/booking_transaction.dart';

import '../Function/booking_state.dart';
import '../Function/parser.dart';
import '../Function/balance.dart';
import '../Widget/identity.dart';

class TicketBookingPage extends StatefulWidget {
  final Movie movie;
  final Balance balance;
  final BookingTransaction bookingTransaction;
  final BookingState bookingState;

  const TicketBookingPage({
    super.key,
    required this.movie,
    required this.balance,
    required this.bookingTransaction,
    required this.bookingState,
  });

  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  late BookingState bookingState;

  @override
  void initState() {
    super.initState();
    bookingState = BookingState();
    bookingState.updateFromTransaction(widget.bookingTransaction);
  }

  void selectSeat(String movieTitle, int seatNumber) {
    setState(() {
      bookingState.selectSeat(movieTitle, seatNumber);
    });
  }

  void unselectSeat(String movieTitle, int seatNumber) {
    setState(() {
      bookingState.unselectSeat(movieTitle, seatNumber);
    });
  }

  bool isSeatBooked(String movieTitle, int seatNumber) {
    for (final transaction in widget.bookingTransaction.transactions) {
      if (transaction.movieTitle == movieTitle &&
          transaction.selectedSeats.contains(seatNumber)) {
        return true;
      }
    }
    return false;
  }

  bool validateAge(int age) {
    return age >= widget.movie.ageRating;
  }

  void continueBooking() {
    if (bookingState.selectedSeats.length > 6) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Maximum Seats Exceeded'),
          content: const Text('You can select a maximum of 6 seats.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => IdentityFormDialog(
          validateAge: validateAge,
          movie: widget.movie,
          selectedSeats: bookingState.selectedSeats[widget.movie.title] ?? [],
          balance: widget.balance,
          bookingTransaction: widget.bookingTransaction,
          bookingState: widget.bookingState,
        ),
      ).then((confirmed) {
        if (confirmed == true) {
          // Payment completed, clear the selected seats
          bookingState.selectedSeats[widget.movie.title]?.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text('Movie: ${widget.movie.title}'),
              const Text('Available Seats:'),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    final seatNumber = index + 1;
                    final isSelected =
                        bookingState.isSelected(widget.movie.title, seatNumber);
                    final isBooked =
                        isSeatBooked(widget.movie.title, seatNumber);

                    final isSelectable = !isBooked &&
                        !isSelected &&
                        !isSeatBooked(widget.movie.title, seatNumber);

                    return InkWell(
                      onTap: () {
                        if (isSelected) {
                          unselectSeat(widget.movie.title, seatNumber);
                        } else if (isSelectable) {
                          selectSeat(widget.movie.title, seatNumber);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isBooked
                              ? Colors.grey
                              : isSelected
                                  ? Colors.green
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            seatNumber.toString(),
                            style: TextStyle(
                              color: isBooked || isSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed:
                    bookingState.selectedSeats.isEmpty ? null : continueBooking,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
