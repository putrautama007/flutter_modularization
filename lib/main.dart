import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

class ApiConstants {
  const ApiConstants();

  static String get baseUrl => 'https://api.themoviedb.org/3';

  static String get apiKey => 'api_key=12ed4f73aa9ef0ae4a134d633a6c01af';

  static String get baseImageUrl => 'https://image.tmdb.org/t/p/w500';

  static String get getNowPlayingMovie => '/movie/now_playing';
}

class MovieModel {
  MovieModel({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  final int? page;
  final List<Movie>? results;
  final int? totalPages;
  final int? totalResults;

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        page: json["page"],
        results:
            List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Movie {
  Movie({
    this.adult,
    this.backdropPath,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.voteCount,
  });

  final bool? adult;
  final String? backdropPath;
  final int? id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final DateTime? releaseDate;
  final String? title;
  final double? voteAverage;
  final int? voteCount;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );
}

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

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        shadowColor: Colors.black45,
        elevation: 2.0,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConstants.baseImageUrl}${movie.posterPath}',
                  width: 80,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 ,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      movie.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class MoviePage extends StatelessWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text(
            "Now Playing Movie",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Consumer<MovieListNotifier>(builder: (context, data, child) {
            final state = data.nowPlayingState;
            if (state == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.loaded) {
              return movieList(data.nowPlayingMovieList);
            } else {
              return const Text('Failed');
            }
          }),
        ));
  }

  SizedBox movieList(List<Movie> movies) => SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(movie);
          },
          itemCount: movies.length,
        ),
      );
}
