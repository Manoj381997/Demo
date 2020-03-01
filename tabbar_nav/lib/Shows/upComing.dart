import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart' show timeDilation;


class TopRated extends StatefulWidget {
  final Map data;
  TopRated({Key key, this.data}) : super(key: key);

  @override
  TopRatedState createState() => TopRatedState();
}

class TopRatedState extends State<TopRated> {
  @override
  Widget build(BuildContext context) {
    return TopRatedShowsGridView(
      topRatedResults: widget.data['results'],
    );
  }
}

class TopRatedShowsGridView extends StatefulWidget {
  final List topRatedResults;

  TopRatedShowsGridView({
    Key key,
    @required this.topRatedResults,
  });

  bool isPerformingRequest = false;

  @override
  TopRatedShowsGridViewState createState() => new TopRatedShowsGridViewState();
}

class TopRatedShowsGridViewState extends State<TopRatedShowsGridView> {
  ScrollController _scrollController = new ScrollController();
  static int page = 2;

  _getMoreData() async {
    if (!widget.isPerformingRequest) {
      setState(() => widget.isPerformingRequest = true);
      http.Response res = await http.get(
          Uri.encodeFull(
              "https://api.themoviedb.org/3/tv/top_rated?api_key=12a3d32040053bd41f3567e684bcd83a&language=en-US&page=${page}"),
          headers: {"Accept": "application/json"});

      setState(() {
        widget.topRatedResults.addAll(json.decode(res.body)['results']);
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
      itemCount: widget.topRatedResults.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.topRatedResults.length) {
          return _buildProgressIndicator();
        } else {
          return TopRatedList(
            topRatedShow: widget.topRatedResults[index],
          );
        }
      },
      controller: _scrollController,
    );
  }
}

class TopRatedList extends StatelessWidget {
  final Map<String, dynamic> topRatedShow;

  const TopRatedList({
    Key key,
    @required this.topRatedShow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTapGridItem(
            topRatedShow['id'], topRatedShow['poster_path'], context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: 'poster ${topRatedShow['id']}',
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: topRatedShow['poster_path'] != null
                        ? "https://image.tmdb.org/t/p/w342/${topRatedShow['poster_path']}"
                        : "https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            Text(
              topRatedShow['name'],
              style: TextStyle(color: Colors.black87, fontSize: 9.0),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }

  void _onTapGridItem(id, poster, BuildContext context) {
    // timeDilation = 3.0;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => Movie(
    //             id: id,
    //             poster: poster,
    //             checkFlag: 1,
    //           )),
    // );
  }
}
