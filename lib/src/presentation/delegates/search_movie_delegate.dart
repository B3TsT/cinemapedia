// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/src/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

typedef SearchhMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  SearchMovieDelegate({
    required this.searchhMovies,
    required this.initialMovies,
  }) : super(searchFieldLabel: 'Buscar pelicula');
  final SearchhMovieCallback searchhMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingString = StreamController.broadcast();
  Timer? _debounceTimer;

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {
    isLoadingString.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if (query.isEmpty) {
      //   debouncedMovies.add([]);
      //   return;
      // }
      final movies = await searchhMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingString.add(false);
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder(
      // future: searchhMovies(query),
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (BuildContext context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) => _MovieItem(
            movie: movies[index],
            //*Otra forma de cerrar steam
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }
  // @override
  // String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingString.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem(
      {Key? key, required this.movie, required this.onMovieSelected})
      : super(key: key);
  final Function(BuildContext context, Movie movies) onMovieSelected;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    height: 130,
                    fit: BoxFit.cover,
                    image: NetworkImage(movie.posterPath),
                    placeholder:
                        const AssetImage('assets/loaders/bottle-loader.gif'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleMedium),
                    (movie.overview.length > 100)
                        ? Text('${movie.overview.substring(0, 100)}...')
                        : Text(movie.overview),
                    Row(
                      children: [
                        Icon(
                          Icons.star_half_rounded,
                          color: Colors.yellow.shade800,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          HumanFormats.number(movie.voteAverage, 1),
                          style: textStyle.bodyMedium!
                              .copyWith(color: Colors.yellow.shade900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
