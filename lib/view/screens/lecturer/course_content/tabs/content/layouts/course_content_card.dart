import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuallearningapp/main.dart';

class CourseContentCard extends StatelessWidget {
  const CourseContentCard({
    @required this.timestamp,
    @required this.week,
    @required this.courseTitle,
    @required this.pdflinkk,
  });

  final String timestamp;
  final String week;
  final String courseTitle;
  final String pdflinkk;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          child: InkWell(
              onTap: () => _launchURL(),
              child: Card(
                margin: EdgeInsets.all(10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        week,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                height: 100,
                                child: SfPdfViewer.network(
                                  contentDownloadUrl == null
                                      ? "http://google.com"
                                      : "$pdflinkk",
                                  onDocumentLoadFailed: (details) =>
                                      print(details),
                                  initialScrollOffset: Offset(1.3, 35.0),
                                )),
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset("assets/images/pdf.png"),
                                  Flexible(
                                    child: Text(
                                      courseTitle,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
  _launchURL() async {
  print(pdflinkk);
 // var url = contentDownloadUrl;
  if (await canLaunch(pdflinkk)) {
    await launch(pdflinkk);
  } else {
    throw 'Could not launch file';
  }
}

}

