import 'package:dartz/dartz.dart';
import 'package:flutter_modularization/core/error/failure_response.dart';
import 'package:flutter_modularization/core/use_case/use_case.dart';
import 'package:flutter_modularization/domain/entity/movie_entity.dart';
import 'package:flutter_modularization/domain/repository/movie_repository.dart';

class GetMovieUseCase extends UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository movieRepository;

  GetMovieUseCase({
    required this.movieRepository,
  });

  @override
  Future<Either<FailureResponse, List<MovieEntity>>> call(
          NoParams params) async =>
      await movieRepository.getMovie();
}
