import 'package:cinemapedia/src/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/movies/movie_masonry.dart';

class PopularView extends ConsumerWidget {
  const PopularView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMovie = ref.watch(popularMoviesProvider);
    if (popularMovie.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Scaffold(
      body: MovieMasonry(
        loadNextPage: () =>
            ref.read(popularMoviesProvider.notifier).loadNextPage(),
        movie: popularMovie,
      ),
    );
  }
}
