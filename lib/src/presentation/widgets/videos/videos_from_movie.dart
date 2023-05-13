// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../domain/entities/video.dart';
import '../../providers/movies/movies_repository_provider.dart';

final FutureProviderFamily<List<Video>, int> videosFromMovieProvider =
    FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});

class VideosFromMovie extends ConsumerWidget {
  final int movieId;

  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesFromVideo = ref.watch(videosFromMovieProvider(movieId));

    return moviesFromVideo.when(
      data: (videos) => _VideosList(videos: videos),
      error: (_, __) =>
          const Center(child: Text('No se pudo cargar películas similares')),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _VideosList extends StatelessWidget {
  const _VideosList({Key? key, required this.videos}) : super(key: key);
  final List<Video> videos;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _YoutubeVideoPlayer(
            youtubeId: videos.first.youtubeKey, name: videos.first.name),
        // ...videos
        //     .map(
        //       (video) => _YoutubeVideoPlayer(
        //         youtubeId: videos.first.youtubeKey,
        //         name: video.name,
        //       ),
        //     )
        //     .toList(),
      ],
    );
  }
}

class _YoutubeVideoPlayer extends StatefulWidget {
  const _YoutubeVideoPlayer(
      {Key? key, required this.youtubeId, required this.name})
      : super(key: key);
  final String youtubeId;
  final String name;

  @override
  State<_YoutubeVideoPlayer> createState() => __YoutubeVideoPlayerState();
}

class __YoutubeVideoPlayerState extends State<_YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        mute: false,
        autoPlay: false,
        loop: false,
        disableDragSeek: true,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(controller: _controller),
        builder: (context, player) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name),
                  YoutubePlayer(controller: _controller)
                ],
              ));
          // return Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(widget.name),
          //     player,
          //     const SizedBox(height: 20),
          //   ],
          // );
        },
      ),
    );
  }
}
