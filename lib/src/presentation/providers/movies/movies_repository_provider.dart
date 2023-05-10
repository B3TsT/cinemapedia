import 'package:cinemapedia/src/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/src/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// *Repositorio inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});
