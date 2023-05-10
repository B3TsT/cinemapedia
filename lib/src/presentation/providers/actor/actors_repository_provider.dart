import 'package:cinemapedia/src/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/actor_moviedb_datasource.dart';

// *Repositorio inmutable
final actorRepositoryProvider = Provider((ref) {
  return ActorRespositoryImpl(ActorMovieDBDatasource());
});
