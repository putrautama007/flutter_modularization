import 'package:flutter/material.dart';
import 'package:flutter_modularization/core/use_case/use_case.dart';
import 'package:flutter_modularization/domain/entity/movie_entity.dart';
import 'package:flutter_modularization/domain/usecase/get_movie_usecase.dart';

enum RequestState { empty, loading, loaded, noData, error }

class MovieListNotifier extends ChangeNotifier {
  final GetMovieUseCase getMovieUseCase;
  List<MovieEntity> nowPlayingMovieList = [];
  RequestState nowPlayingState = RequestState.empty;
  String message = '';

  MovieListNotifier({required this.getMovieUseCase});

  Future<void> fetchNowPlayingMovies() async {
    nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getMovieUseCase.call(const NoParams());
    result.fold((failure) {
      nowPlayingState = RequestState.error;
      message = failure.errorMessage;
      notifyListeners();
    }, (result) {
      if (result.isNotEmpty) {
        nowPlayingState = RequestState.loaded;
        nowPlayingMovieList = result;
        notifyListeners();
      } else {
        nowPlayingState = RequestState.noData;
        notifyListeners();
      }
    });
  }
}
