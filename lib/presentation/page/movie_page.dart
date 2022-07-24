import 'package:flutter/material.dart';
import 'package:flutter_modularization/domain/entity/movie_entity.dart';
import 'package:flutter_modularization/presentation/provider/movie_list_notifier.dart';
import 'package:flutter_modularization/presentation/widget/movie_card.dart';
import 'package:provider/provider.dart';

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

  SizedBox movieList(List<MovieEntity> movies) => SizedBox(
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
