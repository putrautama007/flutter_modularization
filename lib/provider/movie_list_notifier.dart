import 'package:flutter/material.dart';
import 'package:flutter_modularization/datasource/movie_remote_data_source.dart';
import 'package:flutter_modularization/model/movie_model.dart';

enum RequestState { empty, loading, loaded, noData, error }

class MovieListNotifier extends ChangeNotifier {
  final MovieRemoteDataSource moveRemoteDataSource;
  List<Movie> nowPlayingMovieList = [];
  RequestState nowPlayingState = RequestState.empty;
  String message = '';

  MovieListNotifier({required this.moveRemoteDataSource});

  Future<void> fetchNowPlayingMovies() async {
    try {
      nowPlayingState = RequestState.loading;
      notifyListeners();

      final result = await moveRemoteDataSource.getNowPlayingMovies();
      if (result.results!.isNotEmpty) {
        nowPlayingState = RequestState.loaded;
        nowPlayingMovieList = result.results!;
        notifyListeners();
      } else {
        nowPlayingState = RequestState.noData;
        notifyListeners();
      }
    } catch (e) {
      nowPlayingState = RequestState.error;
      message = e.toString();
      notifyListeners();
    }
  }
}
