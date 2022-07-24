import 'package:dartz/dartz.dart';
import 'package:flutter_modularization/core/error/failure_response.dart';
import 'package:flutter_modularization/domain/entity/movie_entity.dart';

abstract class MovieRepository {
  const MovieRepository();

  Future<Either<FailureResponse, List<MovieEntity>>> getMovie();
}
