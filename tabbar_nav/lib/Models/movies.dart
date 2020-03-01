
class Model {
  final Map nowPlaying;
  final Map popular;
  final Map upcoming;
  final Map shows;
  final Map celeb;
  // final List<Map> nowPlaying;

  Model({this.nowPlaying, this.popular, this.upcoming, this.shows, this.celeb});

}

class MovieInfo {
  final List<Map> info;
  final Map images;
  final List casts;
  final Map similarMovies;
  final Map video;

  MovieInfo(
      {this.info,
      this.images,
      this.casts,
      this.similarMovies,
      this.video});
}

