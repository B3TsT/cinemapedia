import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';
import '../widget.dart';

class MovieHorisontalListview extends StatefulWidget {
  const MovieHorisontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  @override
  State<MovieHorisontalListview> createState() =>
      _MovieHorisontalListviewState();
}

class _MovieHorisontalListviewState extends State<MovieHorisontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if ((scrollController.position.pixels + 200) >=
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
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              },
            ),
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () => context.push('/home/0/movie/${movie.id}'),
                child: FadeInImage(
                  height: 220,
                  placeholder:
                      const AssetImage('assets/loaders/bottle-loader.gif'),
                  image: NetworkImage(movie.posterPath),
                ),
              ),
              // child: Image.network(
              //   movie.posterPath,
              //   fit: BoxFit.cover,
              //   width: 150,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress != null) {
              //       return const Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: Center(
              //             child: CircularProgressIndicator(strokeWidth: 2)),
              //       );
              //     }
              //     return GestureDetector(
              //         onTap: () => context.push('/home/0/movie/${movie.id}'),
              //         child: FadeIn(child: child));
              //   },
              // ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyles.titleSmall,
            ),
          ),
          MovieRating(voteAverage: movie.voteAverage)
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({this.title, this.subTitle});
  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}
