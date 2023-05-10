import 'package:cinemapedia/src/domain/entities/actor.dart';
import 'package:cinemapedia/src/domain/repositories/actors_repository.dart';

import '../../domain/datasources/actors_datasource.dart';

class ActorRespositoryImpl extends ActorsRepository {
  ActorRespositoryImpl(this.datasource);
  final ActorsDatasource datasource;

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    return datasource.getActorsByMovie(movieId);
  }
}
