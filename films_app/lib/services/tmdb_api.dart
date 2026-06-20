import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbApi {
  // TODO: Replace this with your TMDB API key before running the app.
  static const String apiKey = 'b64d0b94d22b90bb9143169cec286e9a';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _imageBase = 'https://image.tmdb.org/t/p/w500';

  final http.Client _client;

  TmdbApi({http.Client? client}) : _client = client ?? http.Client();

  String imageUrl(String? path) => path == null ? '' : '$_imageBase$path';

  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final uri = Uri.parse('$_baseUrl/movie/popular?api_key=$apiKey&page=$page');
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load movies: ${res.statusCode}');
    }
    final jsonBody = json.decode(res.body) as Map<String, dynamic>;
    final results = (jsonBody['results'] as List<dynamic>?) ?? [];
    return results.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }
}
