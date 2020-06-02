
class Show {
  final Map nowPlaying;
  final Map popular;
  final Map topRated;

  Show({this.nowPlaying, this.popular, this.topRated});

}

class ShowInfo {
  final List<Map> info;
  final Map images;
  final List casts;
  final Map similarMovies;
  final Map video;

  ShowInfo(
      {this.info,
      this.images,
      this.casts,
      this.similarMovies,
      this.video});
}

