import 'package:flutter/material.dart';

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
      onPressed: () {
        setState(() {
          if(serachBarController.text == ""){
            errorText = "Please enter a name";
          } else {
            errorText = "";
          }
        });
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
