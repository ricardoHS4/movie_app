import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/model/movie.dart';

void main() {
  group("Testing to properly get the Rotten Tomatoes Rating", () {
    test(
      'Testing getting the Rotten Tomatoes Rating when Movie has multiple rating sources',
      () {
        Movie movie = Movie(
          Ratings: [
            {
              "Source": "Internet Movie Database",
              "Value": "8.1/10",
            },
            {
              "Source": "Rotten Tomatoes",
              "Value": "96%",
            },
            {
              "Source": "Metacritic",
              "Value": "79/100",
            }
          ],
        );

        String rottenTomatoesRatin = movie.getRottenTomatoesRating();
        expect(rottenTomatoesRatin, "96%");
      },
    );

    test(
      'Testing getting the Rotten Tomatoes Rating when Movie has no Rotten Tomatoes Rating',
      () {
        Movie movie = Movie(
          Ratings: [
            {
              "Source": "Internet Movie Database",
              "Value": "8.1/10",
            },
            {
              "Source": "Lalala",
              "Value": "96%",
            },
            {
              "Source": "Metacritic",
              "Value": "79/100",
            }
          ],
        );

        String rottenTomatoesRatin = movie.getRottenTomatoesRating();
        expect(rottenTomatoesRatin, "N/A");
      },
    );
  });
}
