import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';
import 'movie_detail.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TmdbApi _api = TmdbApi();
  late Future<List<Movie>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: FutureBuilder<List<Movie>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return const Center(child: Text('No movies found'));
          }
          return ListView.separated(
            itemCount: movies.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final m = movies[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: SizedBox(
                  width: 60,
                  child: m.posterPath == null || m.posterPath!.isEmpty
                      ? const Icon(Icons.movie, size: 48)
                      : CachedNetworkImage(
                          imageUrl: _api.imageUrl(m.posterPath),
                          placeholder: (c, s) => const SizedBox(
                              width: 40,
                              height: 60,
                              child: Center(child: CircularProgressIndicator())),
                          errorWidget: (c, s, e) => const Icon(Icons.broken_image),
                          fit: BoxFit.cover,
                        ),
                ),
                title: Text(m.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      m.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: m.voteAverage / 2.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 16.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(width: 8),
                        Text('${m.voteAverage}/10'),
                      ],
                    ),
                  ],
                ),
                isThreeLine: true,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MovieDetailScreen(movie: m, api: _api))),
              );
            },
          );
        },
      ),
    );
  }
}
