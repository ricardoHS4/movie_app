import 'dart:convert';
import 'package:http/http.dart' as http;

//Class to store the relevant info from the movie maps provided by the API
class Movie {
  String Response;
  String Title;
  String Poster;
  String Released;
  List<dynamic> Ratings;
  String Plot;
  String Error;

  Movie({
    this.Response = "",
    this.Title = "",
    this.Poster = "",
    this.Released = "",
    this.Ratings = const [],
    this.Plot = "",
    this.Error = "",
  });

  static Movie fromJson(Map<String, dynamic> json) => Movie(
        Response: json['Response'] ?? "",
        Title: json['Title'] ?? "",
        Poster: json['Poster'] ?? "",
        Released: json['Released'] ?? "",
        Ratings: json['Ratings'] ?? [],
        Plot: json['Plot'] ?? "",
        Error: json['Error'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'Response': Response,
        'Title': Title,
        'Poster': Poster,
        'Released': Released,
        'Ratings': Ratings,
        'Plot': Plot,
        'Error': Error,
      };
  //Function to look at the ratings list and return the Rotten Tomatoes Rating if it exists.
  String getRottenTomatoesRating() {
    String rating = "N/A";
    for (int x = 0; x < Ratings.length; x++) {
      if(Ratings[x]["Source"]=="Rotten Tomatoes"){
        rating = Ratings[x]["Value"];
      }
    }
    return rating;
  }
}

//Function to retreive data from API and transform it in a 'Movie object
Future<Movie> getMovieFromAPI(String APIurl) async {
  var url = Uri.parse(APIurl);
  http.Response response = await http.get(url);
  Map<String, dynamic> data = jsonDecode(response.body);
  Movie result = Movie.fromJson(data);
  return result;
}
