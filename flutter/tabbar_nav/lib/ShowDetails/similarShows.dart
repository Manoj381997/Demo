import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tabbar_nav/MovieDetails/movie_details.dart';
import 'package:transparent_image/transparent_image.dart';
// import '../Services/Api.dart';

class SimilarMovies extends StatefulWidget {
  final Map similarMovies;

  SimilarMovies({Key key, @required this.similarMovies}) : super(key: key);

  @override
  SimilarMoviesState createState() => SimilarMoviesState();
}

class SimilarMoviesState extends State<SimilarMovies> {
  @override
  Widget build(BuildContext context) {
    return SimilarMovieGridView(
      similarMovie: widget.similarMovies['crew'],
    );
  }
}

class SimilarMovieGridView extends StatelessWidget {
  final List similarMovie;

  SimilarMovieGridView({
    Key key,
    this.similarMovie,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        gridDelegate: _createSliverGridDelegate(context),
        itemCount: similarMovie.length,
        // controller: scrollController,
        itemBuilder: (BuildContext context, int index) => SimilarMovieItemView(
              similarMovie: similarMovie[index],
            ),
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _createSliverGridDelegate(
      BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
      childAspectRatio: 0.65,
      mainAxisSpacing: 8.0,
    );
  }
}

class SimilarMovieItemView extends StatelessWidget {
  final Map<String, dynamic> similarMovie;

  const SimilarMovieItemView({
    Key key,
    @required this.similarMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapGridItem(
          similarMovie['id'], similarMovie['poster_path'], context),
      child: Card(
        elevation: 8.0,
        child: GridTile(
            child: Hero(
              tag: 'poster ${similarMovie['id']}',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: similarMovie['poster_path'] != null
                      ? CachedNetworkImage(
                          imageUrl:
                              "https://image.tmdb.org/t/p/w342/${similarMovie['poster_path']}",
                          fit: BoxFit.fitHeight,
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              "https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313",
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
            ),
            footer: GridTileBar(
              title: Text(similarMovie['original_title']),
              backgroundColor: Colors.black54,
            )),
      ),
    );
  }

  void _onTapGridItem(id, poster, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Movie(
                id: id,
                poster: poster,
                checkFlag: 1,
              )),
    );
  }
}
