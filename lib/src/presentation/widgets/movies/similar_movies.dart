// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cinemapedia/src/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/src/presentation/providers/movies/movies_repository_provider.dart';

import '../../../domain/entities/movie.dart';

final similarMoviesProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getSimilarMovies(movieId);
});

class SimilarMovies extends ConsumerWidget {
  const SimilarMovies({super.key, required this.movieId});
  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarMoviesFuture = ref.watch(similarMoviesProvider(movieId));
    return similarMoviesFuture.when(
        data: (movies) => _Recomendations(movies: movies),
        error: (_, __) => const Center(
              child: Text('No se pudo cargar similares'),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ));
  }
}

class _Recomendations extends StatelessWidget {
  const _Recomendations({Key? key, required this.movies}) : super(key: key);
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 50),
      child: MovieHorisontalListview(
        title: 'Recomendaciones',
        movies: movies,
      ),
    );
  }
}
