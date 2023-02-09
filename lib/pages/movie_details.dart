import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';

class MovieDetails extends StatelessWidget {
  Movie movie;
  MovieDetails({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String rottenTomatoesRating = movie.getRottenTomatoesRating();

    final moviePoster = Container(
      child: Center(child: Image.network(movie.Poster)),
    );

    Widget detailTile({required String title, required String subtitle}) {
      return ListTile(title: Text(title), subtitle: Text(subtitle));
    }

    final movieDetails = Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            detailTile(title: "Release Date", subtitle: movie.Released),
            detailTile(
                title: "Rotten Tomatoes Rating", subtitle: rottenTomatoesRating),
            detailTile(title: "Movie Plot", subtitle: movie.Plot),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(movie.Title)),
      body: Column(
        children: [
          moviePoster,
          movieDetails,
        ],
      ),
    );
  }
}
