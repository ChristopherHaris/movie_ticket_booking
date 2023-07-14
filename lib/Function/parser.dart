import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Movie>> fetchMovies() async {
  final response = await http
      .get(Uri.parse('https://seleksi-sea-2023.vercel.app/api/movies'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((data) => Movie.fromJson(data)).toList();
  } else {
    throw Exception('Failed to fetch movies');
  }
}

class Movie {
  final String title;
  final String description;
  final String releaseDate;
  final int ageRating;
  final String posterUrl;
  final double ticketPrice;

  Movie({
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.ageRating,
    required this.posterUrl,
    required this.ticketPrice,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      description: json['description'],
      releaseDate: json['release_date'],
      ageRating: json['age_rating'],
      posterUrl: json['poster_url'],
      ticketPrice: json['ticket_price'].toDouble(),
    );
  }
}
