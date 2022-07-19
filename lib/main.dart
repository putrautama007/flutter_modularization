import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modularization/datasource/movie_remote_data_source.dart';
import 'package:flutter_modularization/page/movie_page.dart';
import 'package:flutter_modularization/provider/movie_list_notifier.dart';
import 'package:provider/provider.dart';

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
          moveRemoteDataSource: MovieRemoteDataSource(
            dio: Dio(),
          ),
        )..fetchNowPlayingMovies(),
        child: const MoviePage(),
      ),
    );
  }
}
