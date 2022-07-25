import 'package:dio/dio.dart';
import 'package:flutter_modularization/data/model/movie_model.dart';
import 'package:flutter_modularization/util/api_constants.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource({required this.dio});

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
