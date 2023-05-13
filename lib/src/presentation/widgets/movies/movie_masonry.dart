import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/movie.dart';
import '../widget.dart';

class MovieMasonry extends StatefulWidget {
  const MovieMasonry(
      {super.key,
      required this.movie,
      this.loadNextPage,
      this.title,
      this.subTitle});
  final List<Movie> movie;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 10)
          .copyWith(top: 50, bottom: 20),
      controller: scrollController,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: widget.movie.length,
      itemBuilder: (context, index) {
        if (index == 1) {
          return Column(
            children: [
              const SizedBox(height: 30),
              MoviePosterLink(movie: widget.movie[index]),
            ],
          );
        }
        return MoviePosterLink(movie: widget.movie[index]);
      },
    );
  }
}
