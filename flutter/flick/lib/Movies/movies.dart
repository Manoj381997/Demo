import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flick/Models/movies.dart';
// import 'popular.dart';
// import 'upComing.dart';
// import 'nowPlaying.dart';
// import 'package:flick/Services/Api.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;



class Movies extends StatefulWidget {
  Movies({
    Key key,
  }) : super(key: key);

  bool flag = false;
  Map nowPlaying = new Map();
  Map popular = new Map();
  Map upcoming = new Map();

  @override
  MovieState createState() => new MovieState();
}

class MovieState extends State<Movies> with SingleTickerProviderStateMixin {
  final Key nowPlaying = new PageStorageKey('first');
  final Key popular = new PageStorageKey('second');
  final Key upcoming = new PageStorageKey('third');
  TabController tabController;
  // ApiClient client = new ApiClient();
  // final PageStorageBucket bucket = new PageStorageBucket();

  Future<Null> refresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    return null;
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  Widget scrollView() {
    // timeDilation = 1.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: new PreferredSize(
            preferredSize: new Size(50.0, 50.0),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TabBar(
              controller: tabController,
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              isScrollable: true,
              tabs: [
                Container(
                  height: 54.0,
                  child:Tab(text: 'NOW PLAYING'),
                ),
                Container(
                  height: 54.0,
                child: Tab(text: '  POPULAR  '),
                ),
                Container(
                  height: 54.0,
                child: Tab(text: '  UPCOMING   '),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          // NowPlaying(key: nowPlaying, data: widget.nowPlaying),
          // Popular(key: popular, data: widget.popular),
          // Upcoming(key: upcoming, data: widget.upcoming),
          Text("Now"),
          Text("Popular"),
          Text("Soon"),
        ],
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.grey,
    //   body: NestedScrollView(
    //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //       return <Widget>[
    //         SliverPersistentHeader(
    //           delegate: _SliverAppBarDelegate(
    //             TabBar(
    //               labelColor: Colors.redAccent,
    //               unselectedLabelColor: Colors.grey,
    //               indicatorColor: Colors.black,
    //               isScrollable: true,
    //               tabs: [
    //                 new Tab(text: 'NOW PLAYING'),
    //                 new Tab(text: '  POPULAR  '),
    //                 new Tab(text: '  UPCOMING '),
    //               ],
    //               controller: tabController,
    //             ),
    //           ),
    //           pinned: true,
    //         ),
    //       ];
    //     },
    //     body: TabBarView(
    //       controller: tabController,
    //       children: <Widget>[
    //         NowPlaying(key: nowPlaying, data: widget.nowPlaying),
    //         Popular(key: popular, data: widget.popular),
    //         Upcoming(key: upcoming, data: widget.upcoming),
    //       ],
    //     ),
    //   ),
    // );
    // CustomScrollView(
    //   slivers: <Widget>[
    //     new SliverAppBar(
    //       // expandedHeight: 100.0,
    //       // floating: true,
    //       // pinned: true,
    //       // centerTitle: true,
    //       // backgroundColor: Colors.black,
    //       // title: new Text(
    //       //   'Movies',
    //       //   style: TextStyle(
    //       //     color: Colors.red,
    //       //     fontSize: 20.0,
    //       //   ),
    //       // ),
    //       bottom: new TabBar(
    //         labelColor: Colors.redAccent,
    //         unselectedLabelColor: Colors.grey,
    //         indicatorColor: Colors.black,
    //         isScrollable: true,
    //         tabs: [
    //           new Tab(text: 'NOW PLAYING'),
    //           new Tab(text: 'POPULAR'),
    //           new Tab(text: 'UPCOMING'),
    //         ],
    //         controller: tabController,
    //       ),
    //     ),
    //     new SliverFillRemaining(
    //       child: TabBarView(
    //         controller: tabController,
    //         children: <Widget>[
    //           NowPlaying(key: nowPlaying, data: widget.nowPlaying),
    //           Popular(key: popular, data: widget.popular),
    //           Upcoming(key: upcoming, data: widget.upcoming),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  // will be umcommented
  // Widget _movieListWidgetFuture(ApiClient client) {
  //   if (widget.flag == false) {
  //     return FutureBuilder(
  //       future: Future.wait([
  //         client.getNowPlayingMovies(),
  //         client.getPopularMovies(),
  //         client.getUpcomingMovies()
  //       ]).then((List response) => Model(
  //           nowPlaying: response[0],
  //           popular: response[1],
  //           upcoming: response[2])),
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.none:
  //           case ConnectionState.waiting:
  //             return Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           default:
  //             if (snapshot.hasError) {
  //               // return ErrorMessageWidget(error: snapshot.error);
  //             } else {
  //               widget.nowPlaying = snapshot.data.nowPlaying;
  //               widget.popular = snapshot.data.popular;
  //               widget.upcoming = snapshot.data.upcoming;
  //               widget.flag = true;
  //               return scrollView();
  //             }
  //         }
  //       },
  //     );
  //   } else {
  //     return scrollView();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: scrollView(), //_movieListWidgetFuture(client),
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
