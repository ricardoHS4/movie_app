import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/pages/movie_details.dart';

class SearchHistory extends StatelessWidget {
  Localstore db;
  Function setStateFunction;
  SearchHistory({Key? key, required this.db, required this.setStateFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Button to clear the history saved locally
    final clearHistoryButton = ElevatedButton(
      onPressed: () async {
        await db.collection("search_history").delete();
        setStateFunction();
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 192, 13, 0))),
      child: const Text("Clear history"),
    );

    //Single tile that shows title and image from ta movie object
    Widget movieHistoryTile(Movie movie) {
      return ListTile(
        title: Text(movie.Title),
        leading: CircleAvatar(backgroundImage: NetworkImage(movie.Poster)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieDetails(movie: movie)),
          );
        },
      );
    }

    //Future function that returns an scrollable Column that contains all the search hitory cards and a button to clear the history
    Future<Widget> searchHistoryFuture() async {
      final items = await db.collection('search_history').get();
      List<Movie> movieHistory = [];
      if (items != null) {
        items.forEach((key, value) {
          movieHistory.add(Movie.fromJson(value));
        });
      }
      //List is reversed to show the most recent searches first
      movieHistory = movieHistory.reversed.toList();

      //Duplicates are not shown, so we only consider unique movies
      var seen = Set<String>();
      List<Movie> uniquelist =
          movieHistory.where((movie) => seen.add(movie.Title)).toList();

      List<Widget> historyMovieTiles = [];
      for (int x = 0; x < uniquelist.length; x++) {
        Movie movie = uniquelist[x];
        historyMovieTiles.add(movieHistoryTile(movie));
      }

      historyMovieTiles =
          ListTile.divideTiles(context: context, tiles: historyMovieTiles)
              .toList();

      historyMovieTiles.add(clearHistoryButton);

      return SingleChildScrollView(child: Column(children: historyMovieTiles));
    }

    //Widget that shows a circular progress indicator until the history content is loaded
    Widget searchHistoryContent() {
      return FutureBuilder(
        future: searchHistoryFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return snapshot.data!;
          }
        },
      );
    }

    return Expanded(
      child: Column(
        children: [
          const Text("Search history",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 8),
          Expanded(child: searchHistoryContent()),
        ],
      ),
    );
  }
}
