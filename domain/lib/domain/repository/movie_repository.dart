import 'package:core/core/error/failure_response.dart';
import 'package:domain/domain/entity/movie_entity.dart';
import 'package:dependencies/dartz/dartz.dart';

abstract class MovieRepository {
  const MovieRepository();

  Future<Either<FailureResponse, List<MovieEntity>>> getMovie();
}
