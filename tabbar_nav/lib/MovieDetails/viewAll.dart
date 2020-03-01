import 'package:flutter/material.dart';
import '../Services/Api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewAll extends StatefulWidget {
  final List movies;

  ViewAll({Key key, @required this.movies}) : super(key: key);

  @override
  ViewAllState createState() => ViewAllState();
}

class ViewAllState extends State<ViewAll> {
  ApiClient client = new ApiClient();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return new Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.movies.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
            //onTap: () => _onTap(widget.movies[index]['key'], context),
            child: Container(
              padding: const EdgeInsets.only(
                top: 10.0,
                right: 10.0,
                bottom: 10.0,
              ),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Hero(
                          tag: 'View All ${widget.movies[index]['id']}',
                          child: Container(
                            child: CachedNetworkImage(
                              imageUrl:
                                widget.movies[index]['poster_path'] != null
                                ? "https://image.tmdb.org/t/p/w342/${widget.movies[index]['poster_path']}"
                                : "https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Row(children: <Widget>[
                        Text(widget.movies[index]['original_title']),
                        Text(widget.movies[index]['release_date'])
                      ],)
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
    );
  }
}