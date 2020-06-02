import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:tabbar_nav/Models/celebrities.dart';
import 'package:tabbar_nav/Services/Api.dart';
import 'package:tabbar_nav/Celebrities/popularCeleb.dart';

class Celebrity extends StatefulWidget {
  Celebrity({Key key}) : super(key: key);

  bool flag = false;
  Map popular = new Map();

  @override
  CelebrityState createState() => CelebrityState();
}

class CelebrityState extends State<Celebrity> with SingleTickerProviderStateMixin {
  final Key popular = new PageStorageKey('celeb-first');
  TabController tabController;
  CelebApiClient client = new CelebApiClient();

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 1, vsync: this);
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
              tabs: [
                Container(
                  height: 54.0,
                child: Tab(text: '  POPULAR  '),
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
          Popular(key: popular, data: widget.popular),
        ],
      ),
    );
  }

  Widget celebsFutureWidget(CelebApiClient client) {
    if (widget.flag == false) {
      return FutureBuilder(
        future: Future.wait([
          client.getCelebs(),
        ]).then((List response) => CelebrityModel(
            popular: response[0])),
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
                widget.popular = snapshot.data.popular;
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
      body: celebsFutureWidget(client),
    );
  }
}