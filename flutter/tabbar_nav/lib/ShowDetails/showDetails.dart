import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tabbar_nav/Models/movies.dart';
import 'package:tabbar_nav/MovieDetails/similar_movies.dart';
import 'package:tabbar_nav/Movies/movies.dart';
import 'package:tabbar_nav/Services/shows_Api.dart';
import './detail.dart';
import './actors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Show extends StatefulWidget {
  final int id;
  final String poster;

  Show({
    Key key,
    @required this.id,
    @required this.poster,
  }) : super(key: key);

  AsyncSnapshot data;
  bool flag = false;

  @override
  ShowDetails createState() => new ShowDetails();
}

class ShowDetails extends State<Show> with SingleTickerProviderStateMixin {
  final Key details = new PageStorageKey('show-details');
  final Key cast = new PageStorageKey('show-cast');
  final Key reviews = new PageStorageKey('show-reviews');
  TabController tabController;
  ScrollController scrollController;
  ShowApiClient client = new ShowApiClient();
  Map<String, dynamic> omdbMovieDetail;
  // Map<String, dynamic> dirMovies;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
    scrollController = new ScrollController();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget onLoading() {
    return NestedScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: new FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                indicatorColor: Colors.black,
                isScrollable: false,
                tabs: [
                  Tab(text: "INFO"),
                  Tab(text: "CAST"),
                  Tab(text: "REVIEWS"),
                ],
                controller: tabController,
              ),
            ),
            pinned: true,
          ),
        ];
      },
      body: ListView(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 130.0,
                  child: Hero(
                    tag: 'poster ${widget.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://image.tmdb.org/t/p/w342/${widget.poster}",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(70.0),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget showDetailsFuture(ShowApiClient client) {
    if (widget.flag == false) {
      return FutureBuilder(
        future: Future.wait([
          client.getShowDetails(widget.id),
          client.getImages(widget.id),
          client.getCasts(widget.id),
          client.getSimilarShows(widget.id),
          client.getVideos(widget.id),
        ]).then((List response) => MovieInfo(
            info: response[0],
            images: response[1],
            casts: response[2],
            similarMovies: response[3],
            video: response[4])),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('None....');
            case ConnectionState.waiting:
              return onLoading();
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                widget.data = snapshot;
                widget.flag = true;
                return createListView(context, widget.data);
              }
          }
        },
      );
    } else {
      return createListView(context, widget.data);
    }
  }

  Future<bool> onBackPressed() {
    timeDilation = 5.0;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: Container(
          child: new Center(
            child: showDetailsFuture(client),
          ),
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data.info[0];
    Map<String, dynamic> omdbData = snapshot.data.info[1];
    List imgs = snapshot.data.images['backdrops'];

    return new Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              expandedHeight: 220.0,
              floating: true,
              snap: false,
              pinned: false,
              backgroundColor: Colors.black,
              flexibleSpace: new FlexibleSpaceBar(
                background: CarouselWithIndicator(imgs: imgs),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorColor: Colors.black,
                  isScrollable: false,
                  tabs: [
                    Tab(text: "INFO"),
                    Tab(text: "ACTORS"),
                    Tab(text: "REVIEWS"),
                  ],
                  controller: tabController,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: new TabBarView(
          controller: tabController,
          children: <Widget>[
            new ShowDetail(
              key: details,
              data: data,
              omdbData: omdbData,
              videos: snapshot.data.video,
              images: snapshot.data.images,
              slideInfo: snapshot.data.casts,
              similar: snapshot.data.similarMovies,
            ),
            new Casts(
              key: cast,
              casts: snapshot.data.casts[0],
            ),
            new SimilarMovies(
              key: reviews,
              similarMovies: snapshot.data.similarMovies,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class CarouselWithIndicator extends StatefulWidget {
  final List imgs;

  CarouselWithIndicator({@required this.imgs});

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        items: widget.imgs.map(
          (img) {
            return new Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: CachedNetworkImage(
                placeholder: (context, url) => new Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
                imageUrl: img["file_path"] != null
                    ? "https://image.tmdb.org/t/p/w780/" + img['file_path']
                    : 'https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313',
                fadeInDuration: new Duration(seconds: 2),
              ),
            );
          },
        ).toList(),
        autoPlay: false,
        aspectRatio: 1.5,
        viewportFraction: 2.0,
        // updateCallback: (index) {
        //   setState(() {
        //     _current = index;
        //   });
        // },
      ),
      widget.imgs.length <= 30
          ? Positioned(
              bottom: 6.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(widget.imgs, (index, url) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        color: _current == index
                            ? Colors.white
                            : Color.fromRGBO(0, 0, 0, 0.1)),
                  );
                }),
              ),)
          : Container(),
      Positioned(
        top: 30.0,
        right: 60.0,
        child: GestureDetector(
          onTap: () => Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName)),
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
      Positioned(
        top: 30.0,
        right: 15.0,
        child: Icon(
          Icons.share,
          color: Colors.white,
        ),
      ),
    ]);
  }
}
