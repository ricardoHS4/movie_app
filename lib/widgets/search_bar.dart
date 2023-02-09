import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  TextEditingController serachBarController;
  String errorText;
  SearchBar({Key? key, required this.serachBarController, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Place the name of the movie you want to know its details here",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: serachBarController,
          autofocus: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.search),
            errorText: errorText == "" ? null : errorText,
          ),
        ),
      ],
    );
  }
}
