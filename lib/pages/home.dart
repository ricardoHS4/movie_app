import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/pages/movie_details.dart';
import 'package:localstore/localstore.dart';
import 'package:movie_app/widgets/search_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String errorText = "";
  final serachBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final db = Localstore.instance;

    Future<Widget> searchHistoryFuture() async {
      final items = await db.collection('search_history').get();
      List<Movie> movieHistory = [];
      if (items != null) {
        items.forEach((key, value) {
          movieHistory.add(Movie.fromJson(value));
        });
      }
      List<Widget> historyMovieTiles = [];
      for (int x = movieHistory.length - 1; x >= 0; x--) {
        Movie movie = movieHistory[x];
        historyMovieTiles.add(ListTile(
          title: Text(movie.Title),
          leading: CircleAvatar(backgroundImage: NetworkImage(movie.Poster)),
          trailing: const Icon(Icons.arrow_forward),
        ));
      }

      historyMovieTiles =
          ListTile.divideTiles(context: context, tiles: historyMovieTiles)
              .toList();

      return Column(children: historyMovieTiles);
    }

    Widget searchHistory() {
      return Expanded(
        child: Column(
          children: [
            const Text("Search history",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 8),
            FutureBuilder(
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
            ),
          ],
        ),
      );
    }

    final searchButton = ElevatedButton(
      onPressed: () async {
        if (serachBarController.text == "") {
          errorText = "Please enter a name";
        } else {
          String APIurl =
              "http://www.omdbapi.com/?apikey=297bfd4b&t=${serachBarController.text}";
          Movie movie = await getMovieFromAPI(APIurl);
          if (movie.Response == "False") {
            errorText = movie.Error;
          } else {
            errorText = "";
            final id = db.collection('search_history').doc().id;
            db.collection('search_history').doc(id).set(movie.toJson());

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieDetails(movie: movie)),
            );
          }
        }
        setState(() {});
      },
      child: const Text("Search movie"),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("MOVIE DETAILS APP"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SearchBar(serachBarController: serachBarController, errorText: errorText),
          SizedBox(height: 24),
          searchHistory(),
          searchButton,
        ]),
      ),
    );
  }
}
