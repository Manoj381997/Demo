import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Services/Api.dart';

class Gallery extends StatefulWidget {
  final Map<String, dynamic> data;

  Gallery({Key key, @required this.data}) : super(key: key);

  @override
  GalleryState createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  ApiClient client = new ApiClient();
  List<String> backdrops;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return new Container(
      child: ListView(
        children: <Widget>[
          Container(
            child: FutureBuilder(
              future: client.getMovieImages(widget.data['id']),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      // backdrops = client.getImages();
                      // return Trailer(
                      //   trailers: snapshot.data['results'],
                      //   // backdrop: widget.data['backdrop_path'],
                      //   backdrop: backdrops,
                      // );
                      return Text(backdrops.toString());
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Trailer extends StatelessWidget {
  final List trailers;
  final List<String> backdrop;
  // final String backdrop;

  Trailer({
    Key key,
    @required this.trailers,
    @required this.backdrop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: SizedBox(
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            FadeInImage.memoryNetwork(
                              // key: Key(backdrop),
                              placeholder: kTransparentImage,
                              image:
                                  'https://image.tmdb.org/t/p/w500' + backdrop[index],
                              height: 100.0,
                              fit: BoxFit.fitHeight,
                            ),
                            Positioned(
                              right: 76.0,
                              top: 40.0,
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 170.0,
                          child: Text(
                            trailers[index]['name'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.0),
                            textAlign: TextAlign.start,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
  void _onTap(key, BuildContext context) {
    print("ji");
  }

  }