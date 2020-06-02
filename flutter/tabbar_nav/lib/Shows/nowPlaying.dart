import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
// import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/scheduler.dart' show timeDilation;


class NowPlaying extends StatefulWidget {
  final Map data;
  NowPlaying({Key key, this.data}) : super(key: key);

  @override
  NowPlayingState createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlaying> {
  @override
  Widget build(BuildContext context) {
    return UpcomingShowsGridView(
      nowPlayingShows: widget.data['results'],
    );
  }
}

class UpcomingShowsGridView extends StatefulWidget {
  final List nowPlayingShows;

  UpcomingShowsGridView({
    Key key,
    @required this.nowPlayingShows,
  });
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  bool isPerformingRequest = false;

  @override
  UpcomingShowsGridViewState createState() => new UpcomingShowsGridViewState();
}

class UpcomingShowsGridViewState extends State<UpcomingShowsGridView> {
  ScrollController _scrollController = new ScrollController();
  static int page = 2;

  _getMoreData() async {
    if (!widget.isPerformingRequest) {
      setState(() => widget.isPerformingRequest = true);
      http.Response res = await http.get(
          Uri.encodeFull(
              "https://api.themoviedb.org/3/tv/airing_today?api_key=12a3d32040053bd41f3567e684bcd83a&language=en-US&page=${page}"),
          headers: {"Accept": "application/json"});

      setState(() {
        widget.nowPlayingShows.addAll(json.decode(res.body)['results']);
        widget.isPerformingRequest = false;
        page += 1;
      });
    }
  }

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
      itemCount: widget.nowPlayingShows.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.nowPlayingShows.length) {
          return _buildProgressIndicator();
        } else {
          return NowPlayingList(
            nowPlayingShow: widget.nowPlayingShows[index],
          );
        }
      },
      controller: _scrollController,
    );
  }
}

class NowPlayingList extends StatelessWidget {
  final Map<String, dynamic> nowPlayingShow;

  const NowPlayingList({
    Key key,
    @required this.nowPlayingShow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTapGridItem(
            nowPlayingShow['id'],
            nowPlayingShow['poster_path'],
            context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: 'poster ${nowPlayingShow['id']}',
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl:
                      nowPlayingShow['poster_path'] != null
                      ? "https://image.tmdb.org/t/p/w342/${nowPlayingShow['poster_path']}"
                      : "https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            Text(
              nowPlayingShow['name'],
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
    //   MaterialPageRoute(builder: (context) => Movie(id: id, poster: poster, checkFlag: 1,)),
    // );
  }
}
