import 'package:data/data/datasource/movie_remote_data_source.dart';
import 'package:data/data/mapper/movie_mapper.dart';
import 'package:data/data/repository/movie_repository_impl.dart';
import 'package:dependencies/dio/dio.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:domain/domain/usecase/get_movie_usecase.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation/page/movie_page.dart';
import 'package:presentation/presentation/provider/movie_list_notifier.dart';

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
