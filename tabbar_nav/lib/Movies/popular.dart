import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../MovieDetails/movie_details.dart';
import 'package:flutter/scheduler.dart' show timeDilation;


class Popular extends StatefulWidget {
  final Map data;
  Popular({Key key, this.data}) : super(key: key);

  @override
  PopularState createState() => PopularState();
}

class PopularState extends State<Popular> {
  @override
  Widget build(BuildContext context) {
    return PopularMovieGridView(
      popResults: widget.data['results'],
    );
  }
}

class PopularMovieGridView extends StatefulWidget {
  final List popResults;

  PopularMovieGridView({
    Key key,
    this.popResults,
  });

  bool isPerformingRequest = false;

  @override
  PopularMovieGridViewState createState() => new PopularMovieGridViewState();
}

class PopularMovieGridViewState extends State<PopularMovieGridView> {
  ScrollController _scrollController = new ScrollController();
  static int page = 3;

  _getMoreData() async {
    if (!widget.isPerformingRequest) {
      setState(() => widget.isPerformingRequest = true);
      http.Response res = await http.get(
          Uri.encodeFull(
              "https://api.themoviedb.org/3/movie/popular?api_key=12a3d32040053bd41f3567e684bcd83a&language=en-US&page=${page}"),
          headers: {"Accept": "application/json"});

      setState(() {
        widget.popResults.addAll(json.decode(res.body)['results']);
        widget.isPerformingRequest = false;
        page += 1;
      });
    }
  }

  // Future refresh() async {
  //   await new Future.delayed(new Duration(seconds: 2));
  // }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: widget.isPerformingRequest ? 1.0 : 0.0,
          child: new Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 3 : 4,
        childAspectRatio: 0.65,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 24.0,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.popResults.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.popResults.length) {
          return _buildProgressIndicator();
        } else {
          return PopularList(
            popularMovie: widget.popResults[index],
          );
        }
      },
      controller: _scrollController,
    );
  }
}

class PopularList extends StatelessWidget {
  final Map<String, dynamic> popularMovie;

  const PopularList({
    Key key,
    @required this.popularMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTapGridItem(
            popularMovie['id'], popularMovie['poster_path'], context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(
                width: 120.0,
                child: Hero(
                  tag: 'poster ${popularMovie['id']}',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: CachedNetworkImage(
                        imageUrl:popularMovie['poster_path'] != null
                            ? "https://image.tmdb.org/t/p/w342/${popularMovie['poster_path']}"
                            : "https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              popularMovie['original_title'],
              style: TextStyle(color: Colors.black87, fontSize: 9.0),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }

  void _onTapGridItem(id, poster, BuildContext context) {
    timeDilation = 3.0;
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
