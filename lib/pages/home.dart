import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/pages/movie_details.dart';
import 'package:localstore/localstore.dart';
import 'package:movie_app/widgets/search_bar.dart';
import 'package:movie_app/widgets/search_history.dart';

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
        child: Column(
          children: [
            SearchBar(
                serachBarController: serachBarController, errorText: errorText),
            const SizedBox(height: 24),
            SearchHistory(
              db: db,
              setStateFunction: () {
                setState(() {});
              },
            ),
            searchButton,
          ],
        ),
      ),
    );
  }
}
