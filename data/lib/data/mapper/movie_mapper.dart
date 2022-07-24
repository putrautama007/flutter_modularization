import 'package:data/data/model/movie_model.dart';
import 'package:domain/domain/entity/movie_entity.dart';

class MovieMapper {
  List<MovieEntity> mapMovieModelToEntity(List<Movie> data) {
    List<MovieEntity> entity = <MovieEntity>[];

    for (Movie element in data) {
      entity.add(
        mapMovieToMovieEntity(
          element,
        ),
      );
    }

    return entity;
  }

  MovieEntity mapMovieToMovieEntity(Movie? movie) => MovieEntity(
        overview: movie?.overview ?? '',
        originalTitle: movie?.originalTitle ?? '',
        id: movie?.id ?? 0,
        releaseDate: movie?.releaseDate ?? DateTime.now(),
        title: movie?.title ?? '',
        posterPath: movie?.posterPath ?? '',
        backdropPath: movie?.backdropPath ?? '',
        popularity: movie?.popularity ?? 0.0,
        originalLanguage: movie?.originalLanguage ?? '',
        adult: movie?.adult ?? false,
        voteAverage: movie?.voteAverage ?? 0.0,
        voteCount: movie?.voteCount ?? 0,
      );
}
