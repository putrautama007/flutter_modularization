import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modularization/data/datasource/movie_remote_data_source.dart';
import 'package:flutter_modularization/data/mapper/movie_mapper.dart';
import 'package:flutter_modularization/data/repository/movie_repository_impl.dart';
import 'package:flutter_modularization/domain/usecase/get_movie_usecase.dart';
import 'package:provider/provider.dart';
import 'presentation/page/movie_page.dart';
import 'presentation/provider/movie_list_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Modularization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<MovieListNotifier>(
        create: (_) => MovieListNotifier(
          getMovieUseCase: GetMovieUseCase(
              movieRepository: MovieRepositoryImpl(
            movieRemoteDataSource: MovieRemoteDataSourceImpl(dio: Dio()),
            movieMapper: MovieMapper(),
          )),
        )..fetchNowPlayingMovies(),
        child: const MoviePage(),
      ),
    );
  }
}
