import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final TmdbApi api;

  const MovieDetailScreen({Key? key, required this.movie, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: movie.posterPath == null || movie.posterPath!.isEmpty
                  ? const Icon(Icons.movie, size: 160)
                  : CachedNetworkImage(
                      imageUrl: api.imageUrl(movie.posterPath),
                      width: 200,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    RatingBarIndicator(
                      rating: movie.voteAverage / 2.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    const SizedBox(height: 4),
                    Text('${movie.voteAverage}/10')
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            if (movie.releaseDate != null)
              Text('Release: ${movie.releaseDate}'),
            const SizedBox(height: 12),
            Text(
              movie.overview,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
