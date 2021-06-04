import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

var responsemap;

class _NewsScreenState extends State<NewsScreen> {
  final List<NewsDetail> items = [];
  void getNews() async {
    var apiKey =
        "https://newsapi.org/v2/top-headlines?country=ng&apiKey=bc9f48ec79d5429fbb1c9e1fcf7ff7a1";
    http.Response response = await http.get(Uri.parse(apiKey));
    //response = responsebody;
    Map<String, dynamic> responseData = json.decode(response.body);
    responseData['articles'].forEach((newsDetail) {
      final NewsDetail news = NewsDetail(
          description: newsDetail['description'],
          title: newsDetail['title'],
          url: newsDetail['urlToImage']);
      setState(() {
        items.add(news);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
    print(responsemap.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "NEWS",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: this.items.length,
            itemBuilder: (context, index) {
              var newsDetail = this.items[index];
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _renderBody(context, newsDetail),
                            ),
                          ));
                    },
                  );
                },
                title: _itemTitle(newsDetail),
              );
            },
          ),
        ),
      ],
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

class NewsDetail {
  final String title;
  final String description;
  final String url;
  NewsDetail({this.title, this.url, this.description});
}
