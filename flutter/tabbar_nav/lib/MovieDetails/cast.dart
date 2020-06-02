import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Casts extends StatefulWidget {
  final Map casts;

  Casts({Key key, @required this.casts}) : super(key: key);

  @override
  CastState createState() => CastState();
}

class CastState extends State<Casts> {
  @override
  Widget build(BuildContext context) {
    return CastGridView(
      casts: widget.casts['cast'],
    );
  }
}

class CastGridView extends StatelessWidget {
  final List casts;

  CastGridView({
    Key key,
    this.casts,
  });

  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    //   gridDelegate: _createSliverGridDelegate(context),
    //   itemCount: casts.length,
    //   itemBuilder: (BuildContext context, int index) => CastItemView(
    //         cast: casts[index],
    //       ),
    // );
    return ListView.builder(
      itemCount: casts.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: 10.0,
            right: 10.0,
          ),
          child: Column(
            children: <Widget>[
              CastItemView(
                cast: casts[index],
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0, right: 6.0),
                child: index != casts.length-1 ? Divider(
                  height: 10.0,
                  indent: 3.0,
                ) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  // SliverGridDelegateWithFixedCrossAxisCount _createSliverGridDelegate(
  //     BuildContext context) {
  //   return SliverGridDelegateWithFixedCrossAxisCount(
  //     crossAxisCount:
  //         MediaQuery.of(context).orientation == Orientation.portrait ? 3 : 4,
  //     childAspectRatio: 0.65,
  //     mainAxisSpacing: 8.0,
  //   );
  // }
}

class CastItemView extends StatelessWidget {
  final Map<String, dynamic> cast;

  const CastItemView({
    Key key,
    @required this.cast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapGridItem(cast['id'], context),
      // child: Card(
      //   elevation: 8.0,
      //   child: GridTile(
      //       child: cast['profile_path'] != null
      //           ? FadeInImage.memoryNetwork(
      //               placeholder: kTransparentImage,
      //               image:
      //                   "https://image.tmdb.org/t/p/w342/${cast['profile_path']}",
      //               fit: BoxFit.fitHeight,
      //             )
      //           : FadeInImage.memoryNetwork(
      //               placeholder: kTransparentImage,
      //               image:
      //                   "https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313",
      //               fit: BoxFit.fitHeight,
      //             ),
      //       footer: GridTileBar(
      //         title: Text(cast['name']),
      //         subtitle: Text(cast['character']),
      //         backgroundColor: Colors.black54,
      //       )),
      // ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 6.0),
            child: ListTile(
              leading: new CircleAvatar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey,
                backgroundImage: cast['profile_path'] != null
                    ? new NetworkImage(
                        "https://image.tmdb.org/t/p/w342/${cast['profile_path']}")
                    : new NetworkImage(
                        "https://vignette.wikia.nocookie.net/janethevirgin/images/4/42/Image-not-available_1.jpg/revision/latest?cb=20150721102313"),
                radius: 35.0,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    width: 118.0,
                    child: Text(
                      cast['name'].length > 0 ? cast['name'] : 'N/A',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                  ),
                  new Container(
                    width: 113.0,
                    child: Text(
                      cast['character'].length > 0 ? 'as ${cast['character']}' : 'as N/A',
                      style: new TextStyle(color: Colors.grey, fontSize: 10.0),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapGridItem(id, BuildContext context) {
    // Navigator.push(context, MoviePageRoute.of(context, movie));
  }
}
