import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabbar_nav/Models/shows.dart';
import 'popular.dart';
import 'upComing.dart';
import 'nowPlaying.dart';
import '../Services/Api.dart';
import 'package:flutter/scheduler.dart' show timeDilation;



class Shows extends StatefulWidget {
  Shows({
    Key key,
  }) : super(key: key);

  bool flag = false;
  Map nowPlaying = new Map();
  Map popular = new Map();
  Map topRated = new Map();

  @override
  ShowsState createState() => new ShowsState();
}

class ShowsState extends State<Shows> with SingleTickerProviderStateMixin {
  final Key nowPlaying = new PageStorageKey('show-first');
  final Key popular = new PageStorageKey('show-second');
  final Key toprated = new PageStorageKey('show-third');
  TabController tabController;
  ShowApiClient client = new ShowApiClient();
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
    timeDilation = 1.0;

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
                child: Tab(text: ' TOP RATED  '),
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
          NowPlaying(key: nowPlaying, data: widget.nowPlaying),
          Popular(key: popular, data: widget.popular),
          TopRated(key: toprated, data: widget.topRated),
        ],
      ),
    );
  }

  Widget showsFutureWidget(ShowApiClient client) {
    if (widget.flag == false) {
      return FutureBuilder(
        future: Future.wait([
          client.getNowPlayingShows(),
          client.getPopularShows(),
          client.getTopRatedShows()
        ]).then((List response) => Show(
            nowPlaying: response[0],
            popular: response[1],
            topRated: response[2])),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Sorry \nCheck your Internet Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),),
                );
              } else {
                widget.nowPlaying = snapshot.data.nowPlaying;
                widget.popular = snapshot.data.popular;
                widget.topRated = snapshot.data.topRated;
                widget.flag = true;
                return scrollView();
              }
          }
        },
      );
    } else {
      return scrollView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: showsFutureWidget(client),
    );
  }
}
