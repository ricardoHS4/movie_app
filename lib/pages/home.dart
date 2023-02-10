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
        //Check if search bar has text
        if (serachBarController.text == "") {
          errorText = "Please enter a name";
        } else {
          String APIurl =
              "https://www.omdbapi.com/?apikey=297bfd4b&t=${serachBarController.text}";
          Movie movie = await getMovieFromAPI(APIurl);
          //Once data is retreived from the API, we check if response was valid, otherwise, we show the error to the user
          if (movie.Response == "False") {
            errorText = movie.Error;
          } else {
            //Clear error message
            errorText = "";
            //Add valid retreived data to the local storage so we can then show it in the history
            final id = db.collection('search_history').doc().id;
            db.collection('search_history').doc(id).set(movie.toJson());

            //Open Movie Details page with our retreived object as a parameter
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
