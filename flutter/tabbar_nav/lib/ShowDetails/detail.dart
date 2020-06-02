import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tabbar_nav/ShowDetails/showDetails.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/Api.dart';

class ShowDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> videos;
  final Map<String, dynamic> images;
  final List slideInfo;
  final Map<String, dynamic> omdbData;
  final Map<String, dynamic> similar;

  ShowDetail({
    Key key,
    @required this.data,
    @required this.omdbData,
    @required this.videos,
    @required this.images,
    @required this.slideInfo,
    @required this.similar,
  }) : super(key: key);

  bool active = true;

  @override
  ShowDetailsState createState() => new ShowDetailsState();
}

class ShowDetailsState extends State<ShowDetail> {
  ApiClient client = new ApiClient();
  SharedPreferences prefs;
  bool isDirMovies;
  List dirMovies;
  String dirName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget synosis() {
    if (widget.data['overview'].length != 0) {
      return InkWell(
        onTap: () => setState(() {
              if (widget.active == true)
                widget.active = false;
              else
                widget.active = true;
            }),
        child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 16.0, top: 5.0, right: 16.0),
            child: Text(
              widget.data['overview'],
              style: Theme.of(context).textTheme.body1,
              overflow: TextOverflow.ellipsis,
              maxLines: widget.active ? 3 : 40,
            )),
      );
    } else {
      return null;
    }
  }

  Widget facts(omdbData) {
    // final budget = new NumberFormat("#,##0.00", "en_US");
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Facts',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 17.0,
              ),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Original Title',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                omdbData == null ? 'N/A' : '${widget.data['original_title']}',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Original Language',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                omdbData == null ? 'N/A' : '${omdbData['Language']}',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Directed By',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                omdbData == null ? 'N/A' : '${omdbData['Director']}',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Homepage',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                omdbData == null || widget.data['homepage'] == null
                    ? 'N/A'
                    : '${widget.data['homepage'] == null ? 'NA' : widget.data['homepage']}',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Budget',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                omdbData == null ? 'N/A' : '\$${widget.data['budget']}',
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget futureDirectorMovies() {
    if (isDirMovies == false || isDirMovies == null) {
      int directorId;
      List optimizedMovies;

      for (int i = 0; i < widget.slideInfo[0]['crew'].length; i++) {
        if (widget.slideInfo[0]['crew'][i]['job'] == 'Director') {
          directorId = widget.slideInfo[0]['crew'][i]['id'];
          dirName = widget.slideInfo[0]['crew'][i]['name'];
          break;
        }
      }
      return FutureBuilder(
        future: client.getMoviesFromDirector(directorId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('None....');
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                return DirectorMovies(
                  movies: dirMovies,
                  name: 'More from $dirName',
                  flag: 0,
                  id: widget.data['id'],
                );
              }
          }
        },
      );
    } else {
      return DirectorMovies(
          movies: dirMovies,
          name: 'More from $dirName',
          flag: 0,
          id: widget.data['id']);
    }
  }

  Widget crew(Map slideInfo) {
    print(widget.data['id']);
    if (slideInfo['crew'] != null || slideInfo['crew'].length != 0) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  'Crew',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
          height: 170.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: slideInfo['crew']
                    .length, //> 6 ? 6 : slideInfo['crew'].length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      right: 12.0,
                    ),
                    child: GestureDetector(
                      onTap: null,
                          // _onTapDirectorMovies(movies['id'], movies['poster_path'], context),
                          child: Column(
                            children: <Widget>[
                              // Hero(
                              //   tag: 'celeb ${slideInfo['crew'][index]['id']}',
                              //   child:
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.grey[400],
                                      backgroundImage: slideInfo['crew'][index]['profile_path'] != null ?
                                        NetworkImage(
                                          'https://image.tmdb.org/t/p/w342' +
                                                slideInfo['crew'][index]
                                                    ['profile_path']) :
                                        NetworkImage(
                                          'https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313',
                                        ),
                                    ),
                                  ),
                                ),
                              // ),
                              Container(
                                padding: EdgeInsets.only(top: 8.0, bottom: 2.0),
                                width: 100.0,
                                child: Text(
                                  '${slideInfo['crew'][index]['name']}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 8.0, bottom: 2.0),
                                width: 100.0,
                                child: Text(
                                  '${slideInfo['crew'][index]['job']}',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                    ),
                  );
                }),
          ),
        ),
          ],
      ),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Container(
      child: ListView(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Hero(
                  tag:'poster ${widget.data['id']}',
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w342/' +
                        widget.data['poster_path'],
                    key: Key(widget.data["poster_path"]),
                    width: 130.0,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              new Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 14.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      widget.data["original_title"],
                      style: textTheme.title,
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    new RatingsRow(
                      voteAverage: widget.data['vote_average'],
                      voteCount: widget.data['vote_count'],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                      child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: -12.0,
                          spacing: 4.0,
                          children: List.generate(
                              widget.data["genres"].length > 3
                                  ? 3
                                  : widget.data["genres"].length,
                              (index) => Chip(
                                    label: Text(
                                        widget.data["genres"][index]['name']),
                                  ))),
                    ),
                  ],
                ),
              )),
            ],
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Release Date",
                      style: textTheme.subhead,
                    ),
                    Text(
                      widget.data['release_date'] != null
                          ? (new DateFormat.yMMMd().format(
                              DateTime.parse(widget.data['release_date'])))
                          : 'N/A',
                      style: textTheme.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, top: 16.0, bottom: 16.0, left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.schedule,
                        size: 20.0,
                      ),
                      Text(
                        (widget.data['runtime']) != null
                            ? '${widget.data['runtime']} minutes'
                            : 'NA',
                        style: textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          synosis(),
          facts(widget.omdbData),
          Container(
            child: widget.videos['results'].length != 0
                ? Trailer(
                    trailers: widget.videos['results'],
                    backdrop: widget.data['backdrop_path'],
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Divider(
              indent: 3.0,
            ),
          ),
          DirectorMovies(
            movies: widget.slideInfo[1]['crew'],
            name: 'More from ${widget.slideInfo[2]}',
            flag: 0,
            id: widget.data['id'],
          ),
          widget.slideInfo[1]['crew'].length > 0 ?
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Divider(
                indent: 3.0,
              ),
            ): Container(),
          DirectorMovies(
              movies: widget.similar['results'],
              name: 'Similar Movies',
              flag: 1,
              id: widget.data['id']),
          widget.similar['results'].length > 0 ?
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Divider(
              indent: 3.0,
            ),
          ) : Container(),
          crew(widget.slideInfo[0]),
        ],
      ),
    );
  }
}

class Trailer extends StatelessWidget {
  final List trailers;
  final String backdrop;

  Trailer({
    Key key,
    @required this.trailers,
    @required this.backdrop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 16.0,
                ),
                child: Text(
                  'Trailers & Clips',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: trailers.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return GestureDetector(
                      onTap: () => _onTap(trailers[index]['key'], context),
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          right: 10.0,
                          bottom: 10.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                FadeInImage.memoryNetwork(
                                  key: Key(backdrop),
                                  placeholder: kTransparentImage,
                                  image: 'https://image.tmdb.org/t/p/w342' +
                                      backdrop,
                                  height: 100.0,
                                  fit: BoxFit.fitHeight,
                                ),
                                Positioned(
                                  right: 65.0,
                                  top: 32.0,
                                  child: Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 45.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              width: 170.0,
                              child: Text(
                                trailers[index]['name'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(key, BuildContext context) {
    var youtube = new FlutterYoutube();

    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyDb_-eSbAKkISL9_Hy15Vt2M8fyMr3ew1Q",
      videoUrl: "https://www.youtube.com/watch?v=$key",
    );

    youtube.onVideoEnded.listen((onData) {
      FlutterYoutube.playYoutubeVideoByUrl(
        apiKey: "AIzaSyDb_-eSbAKkISL9_Hy15Vt2M8fyMr3ew1Q",
        videoUrl: "https://www.youtube.com/watch?v=$key",
      );
    });
  }
}

class DirectorMovies extends StatelessWidget {
  List movies;
  final String name;
  final int flag;
  final int id;

  DirectorMovies({
    Key key,
    this.movies,
    @required this.name,
    @required this.flag,
    @required this.id,
  }) : super(key: key);

  List optimizeMovies(List data) {
    List<Map> opt = new List<Map>();
    int j = 0;

    for (int i = 0; i < data.length; i++) {
      for (j = 0; j < data.length; j++) {
        if (data[i]['id'] == data[j]['id']) {
          break;
        }
      }
      if (i == j && id != data[i]['id']) {
        opt.add(data[i]);
      }
    }

    return opt;
  }

  @override
  Widget build(BuildContext context) {

    if (movies.length > 0 ) {

      if (flag == 0) {
        movies = optimizeMovies(movies);
      }

      return new SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 18.0),
                  child: movies.length > 6
                      ? GestureDetector(
                          // onTap: ()  => (),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16.0,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length > 6 ? 6 : movies.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          right: 8.0,
                        ),
                        child: DirList(movies: movies[index], flag: flag),
                      );
                    }),
              ),
            ),
          ],
        ),
      );
    }
    else {
      return Container();
    }
  }
}

class DirList extends StatelessWidget {
  final Map movies;
  final int flag;

  DirList({
    @required this.movies,
    @required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          _onTapDirectorMovies(movies['id'], movies['poster_path'], context),
      child: Column(
        children: <Widget>[
          Hero(
            tag: flag == 1
                ? 'poster ${movies['id']}'
                : 'poster similar ${movies['id']}',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: CachedNetworkImage(
                  imageUrl: movies['poster_path'] != null
                      ? 'https://image.tmdb.org/t/p/w342' +
                          movies['poster_path']
                      : 'https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313',
                  height: 150.0,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8.0, bottom: 2.0),
            width: 100.0,
            child: Text(
              '${movies['original_title']}',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
            width: 100.0,
            child: Text(
              movies['release_date'] != null
                  ? movies['release_date'].split('-')[0]
                  : '',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapDirectorMovies(id, poster, BuildContext context) {
    timeDilation = 3.0;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => Movie(
    //             id: id,
    //             poster: poster,
    //             checkFlag: flag == 1 ? 1 : 0,
    //           )),
    // );
  }
}

class RatingsRow extends StatelessWidget {
  final double voteAverage;
  final int voteCount;

  const RatingsRow({
    Key key,
    @required this.voteAverage,
    @required this.voteCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RatingsColumn(
          value: '$voteAverage/10',
          // label: 'Rating',
          icon: Icon(
            Icons.star,
            size: 12.0,
          ),
        ),
        Expanded(
          child: RatingsColumn(
            value: '$voteCount',
            // label: 'Votes',
            icon: Icon(
              Icons.thumb_up,
              size: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}

class RatingsColumn extends StatelessWidget {
  final String value;
  // final String label;
  final Icon icon;

  const RatingsColumn(
      {Key key,
      @required this.value,
      // @required this.label,
      @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                icon,
                Text(
                  value,
                  style: textTheme.caption,
                ),
              ],
            ),
          ],
        ));
  }
}

class TextOverviewWidget extends StatelessWidget {
  const TextOverviewWidget({
    Key key,
    @required this.text,
    @required this.style,
  }) : super(key: key);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            left: 16.0, bottom: 16.0, top: 5.0, right: 16.0),
        child: Text(
          text,
          style: style,
        ));
  }
}
