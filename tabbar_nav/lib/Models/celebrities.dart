
class CelebrityModel {
  final Map popular;

  CelebrityModel({this.popular});

}

class CelebrityInfo {
  final List<Map> info;
  final Map images;
  final List casts;
  final Map similarMovies;
  final Map video;

  CelebrityInfo(
      {this.info,
      this.images,
      this.casts,
      this.similarMovies,
      this.video});
}

