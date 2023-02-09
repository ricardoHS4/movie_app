import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/pages/movie_details.dart';

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
    final searchBar = Column(
      children: [
        const Text(
          "Place the name of the movie you want to know its details here",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: serachBarController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.search),
            errorText: errorText == "" ? null : errorText,
          ),
        ),
      ],
    );

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MovieDetails(movie: movie)),
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
          searchBar,
          //SearchHistory,
          searchButton,
        ]),
      ),
    );
  }
}
