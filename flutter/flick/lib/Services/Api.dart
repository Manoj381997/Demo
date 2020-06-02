import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:json_annotation/json_annotation.dart';
// import '../Models/model.dart';

class ApiClient {
  static const String _API_KEY = '12a3d32040053bd41f3567e684bcd83a';
  static const String _BASE_ENDPOINT = 'api.themoviedb.org';
  static const String _OMDB_API_KEY = '8633a134';

  final JsonDecoder _decoder = const JsonDecoder();

  // Now Playing Movies
  Future<Map<String, dynamic>> getNowPlayingMovies() async {
    final nowPlayingResponse = await http.get(
        Uri.encodeFull(
            "https://$_BASE_ENDPOINT/3/movie/now_playing?api_key=$_API_KEY&language=en-US&page=1"),
        headers: {"Accept": "application/json"});

    Map<String, dynamic> nowPlayingData =
        _decoder.convert(nowPlayingResponse.body);

    return nowPlayingData;
  }

  // Popular Movies
  Future<Map<String, dynamic>> getPopularMovies() async {
      final popularResponse = await http.get(
          Uri.encodeFull(
              "https://$_BASE_ENDPOINT/3/movie/popular?api_key=$_API_KEY&language=en-US&page=2"),
          headers: {"Accept": "application/json"});

      Map<String, dynamic> popularData =
        _decoder.convert(popularResponse.body);

    return popularData;
  }

  // Upcoming Movies
  Future<Map<String, dynamic>> getUpcomingMovies() async {
      final upcomingResponse = await http.get(
          Uri.encodeFull(
              "https://$_BASE_ENDPOINT/3/movie/upcoming?api_key=$_API_KEY&language=en-US&page=1"),
          headers: {"Accept": "application/json"});

      Map<String, dynamic> upcomingData =
        _decoder.convert(upcomingResponse.body);

    return upcomingData;
  }

  // Movie details
  Future<List<Map>> getMovieDetails(id) async {
    List<Map> details = new List<Map>();
    http.Response response = await http.get(
        Uri.encodeFull("https://$_BASE_ENDPOINT/3/movie/" +
            (id).toString() +
            "?api_key=$_API_KEY&language=en-US"),
        headers: {
          "Accept": "application/json",
        });
    Map<String, dynamic> movieDetail = json.decode(response.body);
    Map<String, dynamic> omdbData = await getMovieDetailsFromOMDb(movieDetail['imdb_id']);

    details.add(movieDetail);
    details.add(omdbData);

    return details;
  }

  // Movie details from OMDB
  Future getMovieDetailsFromOMDb(imdbId) async {
    http.Response response = await http.get(
        Uri.encodeFull("https://www.omdbapi.com/?i=$imdbId&apikey=${_OMDB_API_KEY}"),
        headers: {
          "Accept": "application/json",
        });
    Map<String, dynamic> omdbMovieDetail = json.decode(response.body);

    return omdbMovieDetail;
  }

  // Get Movie Casts, Movies related to director
  Future<List> getMovieCasts(id) async {
    int directorId;
    String directorName;
    List<dynamic> castsAndDirMovies = new List<dynamic>();
    final response = await http.get(
        Uri.encodeFull(
            "https://$_BASE_ENDPOINT/3/movie/$id/credits?api_key=$_API_KEY"),
        headers: {"Accept": "application/json"});

    final Map<String, dynamic> castResults = _decoder.convert(response.body);

    for (int i = 0; i < castResults['crew'].length; i++) {
        if (castResults['crew'][i]['job'] == 'Director') {
          directorId = castResults['crew'][i]['id'];
          directorName = castResults['crew'][i]['name'];
          break;
        }
      }

    final Map<String, dynamic> dirMovies = await getMoviesFromDirector(directorId);

    castsAndDirMovies.add(castResults);
    castsAndDirMovies.add(dirMovies);
    castsAndDirMovies.add(directorName);

    return castsAndDirMovies;
  }

  // Get Movies from director
  Future<Map> getMoviesFromDirector(id) async {

    final response = await http.get(
        Uri.encodeFull(
            "https://$_BASE_ENDPOINT/3/person/${id}/movie_credits?api_key=$_API_KEY&language=en-US"),
        headers: {"Accept": "application/json"});

    final Map<String, dynamic> directorMovies = _decoder.convert(response.body);

    return directorMovies;
  }

  // Get Similar movies
  Future<Map<String, dynamic>> getSimilarMovies(id) async {
    final response = await http.get(
        Uri.encodeFull(
            "https://$_BASE_ENDPOINT/3/movie/$id/similar?api_key=$_API_KEY&language=en-US&page=1"),
        headers: {"Accept": "application/json"});

    final Map<String, dynamic> similarMovies = _decoder.convert(response.body);

    return similarMovies;
  }

  // Get Trailers for movies
  Future<Map> getMovieTrailers(id) async {
    final response = await http.get(
        Uri.encodeFull(
            "https://$_BASE_ENDPOINT/3/movie/$id/videos?api_key=$_API_KEY&language=en-US"),
        headers: {"Accept": "application/json"});

    final Map<String, dynamic> trailers = _decoder.convert(response.body);

    return trailers;
  }

  // Get Movie Images
  Future<Map> getMovieImages(id) async {

    final response = await http.get(
        Uri.encodeFull(
            "https://$_BASE_ENDPOINT/3/movie/$id/images?api_key=$_API_KEY"),
        headers: {"Accept": "application/json"});

    final Map<String, dynamic> images = _decoder.convert(response.body);

    return images;
  }

}

// Shows API
class ShowApiClient {
  static const String _API_KEY = '12a3d32040053bd41f3567e684bcd83a';
  static const String _BASE_ENDPOINT = 'api.themoviedb.org';
  static const String _OMDB_API_KEY = '8633a134';

  final JsonDecoder _decoder = const JsonDecoder();

  // Get Popular Shows
  Future<Map> getPopularShows() async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/popular?api_key=$_API_KEY&language=en-US&page=1"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> popular =
        _decoder.convert(response.body);

    return popular;
  }

  // Get Popular Shows
  Future<Map> getNowPlayingShows() async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/airing_today?api_key=$_API_KEY&language=en-US&page=1"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> nowPlaying =
        _decoder.convert(response.body);

    return nowPlaying;
  }

  // Get Popular Shows
  Future<Map> getTopRatedShows() async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/top_rated?api_key=$_API_KEY&language=en-US&page=1"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> upcoming =
        _decoder.convert(response.body);

    return upcoming;
  }
}

// Celebrities API
class CelebApiClient {
  static const String _API_KEY = '12a3d32040053bd41f3567e684bcd83a';
  static const String _BASE_ENDPOINT = 'api.themoviedb.org';
  static const String _OMDB_API_KEY = '8633a134';

  final JsonDecoder _decoder = const JsonDecoder();

  // Celebs
  Future<Map> getCelebs() async {
    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/person/popular?api_key=$_API_KEY&language=en-US&page=1"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> celeb =
        _decoder.convert(response.body);
    return celeb;
  }
}

class Genres {
  static const String _API_KEY = '12a3d32040053bd41f3567e684bcd83a';
  static const String _BASE_ENDPOINT = 'api.themoviedb.org';

  final JsonDecoder _decoder = const JsonDecoder();

  // Genres
  Future<Map> getGenres() async {
    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/genre/movie/list?api_key=$_API_KEY&language=en-US"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> genres =
        _decoder.convert(response.body);
    return genres;
  }
}