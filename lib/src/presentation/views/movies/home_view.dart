import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widget.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingPoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();
    final movieSlideshow = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingPoviesProvider);
    // final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            title: CustomAppbar(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  // const CustomAppbar(),
                  MoviesSlideshow(movies: movieSlideshow),
                  MovieHorisontalListview(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    subTitle: 'Lunes 11',
                    loadNextPage: () => ref
                        .read(nowPlayingPoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MovieHorisontalListview(
                    movies: upcomingMovies,
                    title: 'Proximamente',
                    // subTitle: 'Lunes 20',
                    loadNextPage: () => ref
                        .read(nowPlayingPoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  //* Ya no estara aqui, ahora es parte del menu inferior
                  // MovieHorisontalListview(
                  //   movies: popularMovies,
                  //   title: 'Populares',
                  //   // subTitle: 'Lunes 20',
                  //   loadNextPage: () =>
                  //       ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  // ),
                  MovieHorisontalListview(
                    movies: topRatedMovies,
                    title: 'Mejor Calificadas',
                    subTitle: 'Desde siempre',
                    loadNextPage: () => ref
                        .read(nowPlayingPoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
