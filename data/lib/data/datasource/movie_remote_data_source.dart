import 'package:core/core/util/api_constants.dart';
import 'package:data/data/model/movie_model.dart';
import 'package:dependencies/dio/dio.dart';

abstract class MovieRemoteDataSource {
  const MovieRemoteDataSource();

  Future<MovieModel> getNowPlayingMovies();
}

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<MovieModel> getNowPlayingMovies() async {
    try {
      final response = await dio.get(
        "${ApiConstants.baseUrl}${ApiConstants.getNowPlayingMovie}?${ApiConstants.apiKey}",
      );
      return MovieModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
