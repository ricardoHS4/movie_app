import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/movie.dart';

//Function to retreive data from API and transform it in a 'Movie object
Future<Movie> getMovieFromAPI(String APIurl) async {
  var url = Uri.parse(APIurl);
  http.Response response = await http.get(url);
  Map<String, dynamic> data = jsonDecode(response.body);
  Movie result = Movie.fromJson(data);
  return result;
}