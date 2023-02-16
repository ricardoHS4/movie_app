import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:movie_app/model/movie.dart';

class MovieDetails extends StatelessWidget {
  Movie movie;
  Function setStateFunction;

  MovieDetails({Key? key, required this.movie, required this.setStateFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String rottenTomatoesRating = movie.getRottenTomatoesRating();

    final moviePoster = Container(
      child: Center(
          child: Image.network(
        movie.Poster,
        errorBuilder: (context, error, stackTrace) {
          return const Text("\nPoster is not available",
              style: TextStyle(fontWeight: FontWeight.bold));
        },
      )),
    );

    Widget detailTile({required String title, required String subtitle}) {
      return ListTile(title: Text(title), subtitle: Text(subtitle));
    }

    final movieDetails = Column(
      children: [
        detailTile(title: "Release Date", subtitle: movie.Released),
        detailTile(
            title: "Rotten Tomatoes Rating", subtitle: rottenTomatoesRating),
        detailTile(title: "Movie Plot", subtitle: movie.Plot),
      ],
    );


    return Scaffold(
      appBar: AppBar(title: Text(movie.Title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            moviePoster,
            movieDetails,
          ],
        ),
      ),
    );
  }
}
