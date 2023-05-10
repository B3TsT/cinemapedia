import '../../domain/entities/actor.dart';
import '../models/moviedb/movie/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilPath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
            : 'https://www.escapeauthority.com/wp-content/uploads/2116/11/No-image-found.jpg',
        character: cast.character,
      );
}
