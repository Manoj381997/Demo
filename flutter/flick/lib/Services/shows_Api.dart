import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


// Shows API
class ShowApiClient {
  static const String _API_KEY = '12a3d32040053bd41f3567e684bcd83a';
  static const String _BASE_ENDPOINT = 'api.themoviedb.org';
  // static const String _OMDB_API_KEY = '8633a134';

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

  // Get Now Playing Shows
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

  // Get Top Rated Shows
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

  // Get Details
  Future<Map> getShowDetails(id) async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/$id?api_key=$_API_KEY&language=en-US"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> showDetail =
        _decoder.convert(response.body);

    return showDetail;
  }

  // Get Casts
  Future<Map> getCasts(id) async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/$id/credits?api_key=$_API_KEY&language=en-US"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> casts =
        _decoder.convert(response.body);

    return casts;
  }

  // Get Images
  Future<Map> getImages(id) async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/$id/images?api_key=$_API_KEY"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> images =
        _decoder.convert(response.body);

    return images;
  }

  // Get Similar shows
  Future<Map> getSimilarShows(id) async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/$id/similar?api_key=$_API_KEY&language=en-US&page=1"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> similarShows =
        _decoder.convert(response.body);

    return similarShows;
  }

  // Get Videos
  Future<Map> getVideos(id) async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/3/tv/$id/videos?api_key=$_API_KEY&language=en-US"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> videos =
        _decoder.convert(response.body);

    return videos;
  }

  // Get Seasons List
  Future<Map> getSeasons(id, seasonNumber) async {

    http.Response response = await http.get(
      Uri.encodeFull("https://$_BASE_ENDPOINT/$seasonNumber/tv/$id/season/5?api_key=$_API_KEY&language=en-US"),
      headers: {
        "Accept": "application/json"
      }
    );

    Map<String, dynamic> seasons =
        _decoder.convert(response.body);

    return seasons;
  }
}
