import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  String Response;
  String Poster;
  String Released;
  List<Map<String, dynamic>> Ratings;
  String Plot;


  Movie({
    this.Response = "",
    this.Poster = "",
    this.Released = "",
    this.Ratings = const [],
    this.Plot = "",
  });

  static Movie fromJson(Map<String, dynamic> json) => Movie(
        Response: json['Response'] ?? "",
        Poster: json['Poster'] ?? "",
        Released: json['Released'] ?? "",
        Ratings: json['Ratings'] ?? [],
        Plot: json['Plot'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'Response': Response,
        'Poster': Poster,
        'Released': Released,
        'Ratings': Ratings,
        'Plot': Plot,
      };
}

Future<Movie> getMovieFromAPI(String APIurl) async {
  var url = Uri.parse(APIurl);
  http.Response response = await http.get(url);
  Map<String, dynamic> data = jsonDecode(response.body);
  Movie result = Movie.fromJson(data);
  return result;
}
