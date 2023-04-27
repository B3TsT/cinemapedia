import 'package:cinemapedia/src/domain/entities/movie.dart';

abstract class MovieRepositories {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
