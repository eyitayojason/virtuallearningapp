import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virtuallearningapp/Models/NewsModel.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Authentication>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "NEWS",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: FutureBuilder(
              future: authProvider.getNews(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<NewsDetail>> snapshot) {
                if (snapshot.hasData) {
                  List<NewsDetail> items = snapshot.data;

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var newsDetail = items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        leading: _itemThumbnail(newsDetail),
                        tileColor: Colors.white,
                        dense: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return Padding(
                                  padding: const EdgeInsets.all(100.0),
                                  child: Container(
                                    color: Colors.white,
                                    child: ListView(children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children:
                                            _renderBody(context, newsDetail),
                                      )
                                    ]),
                                  ));
                            },
                          );
                        },
                        title: _itemTitle(newsDetail),
                      );
                    },
                  );
                } else if (!snapshot.hasData) {
                  return buildShimmer();
                } else
                  return SizedBox();
              }),
        ),
      ],
    );
  }

  Widget buildShimmer() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          itemCount: 12,
        ),
      ),
    );
  }
}

Widget _itemThumbnail(NewsDetail newsDetail) {
  return Container(
    constraints: BoxConstraints.tightFor(width: 100.0),
    child: newsDetail.url == null
        ? Icon(
            Icons.error,
            color: Colors.red,
          )
        : Image.network(newsDetail.url, fit: BoxFit.fitWidth),
  );
}

Widget _itemTitle(NewsDetail newsDetail) {
  return Text(
    newsDetail.title,
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      backgroundColor: Colors.white,
    ),
  );
}

List<Widget> _renderBody(BuildContext context, NewsDetail newsDetail) {
  // ignore: deprecated_member_use
  var result = List<Widget>();
  result.add(_bannerImage(newsDetail.url, 170.0));
  result.addAll(_renderInfo(context, newsDetail));
  return result;
}

List<Widget> _renderInfo(BuildContext context, NewsDetail newsDetail) {
  // ignore: deprecated_member_use
  var result = List<Widget>();
  result.add(_sectionTitle(newsDetail.title));
  result.add(_sectionText(newsDetail.description));
  return result;
}

Widget _sectionTitle(String text) {
  return Container(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
      ));
}

Widget _sectionText(String text) {
  return Container(
      padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
      child: Text(
        text,
      ));
}

Widget _bannerImage(String url, double height) {
  return Container(
      constraints: BoxConstraints.tightFor(height: height),
      child: Image.network(url, fit: BoxFit.cover));
}
