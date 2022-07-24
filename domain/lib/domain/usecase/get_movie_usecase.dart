import 'package:core/core/error/failure_response.dart';
import 'package:core/core/use_case/use_case.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:domain/domain/entity/movie_entity.dart';
import 'package:domain/domain/repository/movie_repository.dart';

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
