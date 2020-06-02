import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:async';
import 'Movies/movies.dart' as first;
import './Shows/shows.dart' as second;
import './Celebrities/Celeb.dart' as third;

void main() => runApp(new AfterSplash());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 14,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text('Welcome In SplashScreen',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
      ),
      image: new Image.network('https://flutter.io/images/catalog-widget-placeholder.png'),
      //backgroundGradient: new LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight),
      backgroundColor: Colors.black,
      // styleTextUnderTheLoader: new TextStyle(),
      // photoSize: 100.0,
      // onClick: ()=>print("Flutter Egypt"),
      // loaderColor: Colors.red,
    );
  }
}

class AfterSplash extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: new MyTabs(),
    );
  }
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> {
  final Key movies = new PageStorageKey('first');
  final Key shows = new PageStorageKey('second');
  final Key celebs = new PageStorageKey('third');

  // final PageStorageBucket bucket = new PageStorageBucket();
  int currentIndex = 0;
  first.Movies movie;
  second.Shows show;
  third.Celebrity celeb;
  List<Widget> pages;

  Future<Null> refresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    return null;
  }


  @override
  void initState() {
    movie = first.Movies(
      key: movies,
    );
    show = second.Shows(
      key: shows,
    );
    celeb = third.Celebrity(
      key: celebs,
    );
    pages = [movie, show, celeb];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flick'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: pages[currentIndex],
        // RefreshIndicator(
        //   onRefresh: refresh,
        //   child: pages[currentIndex],
        // ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.black,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption:
                      new TextStyle(color: Colors.grey))), // copyWith ends...
          // child: BottomApp.BottomNavBar(currentIndex),
          child: new BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.theaters,
                ),
                title: Text('Movies'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv),
                title: Text(
                  'TV Shows',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Celebrities'),
              )
            ],
            type: BottomNavigationBarType.fixed,
          ),
        ));
  }
}
