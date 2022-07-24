import 'package:core/core/error/failure_response.dart';
import 'package:data/data/datasource/movie_remote_data_source.dart';
import 'package:data/data/mapper/movie_mapper.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:dependencies/dio/dio.dart';
import 'package:domain/domain/entity/movie_entity.dart';
import 'package:domain/domain/repository/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieRemoteDataSource movieRemoteDataSource;
  final MovieMapper movieMapper;

  const MovieRepositoryImpl({
    required this.movieRemoteDataSource,
    required this.movieMapper,
  });

  @override
  Future<Either<FailureResponse, List<MovieEntity>>> getMovie() async {
    try {
      final response = await movieRemoteDataSource.getNowPlayingMovies();
      return Right(
        movieMapper.mapMovieModelToEntity(
          response.results ?? [],
        ),
      );
    } on DioError catch (error) {
      return Left(
        FailureResponse(
          errorMessage: error.response.toString(),
        ),
      );
    }
  }
}
