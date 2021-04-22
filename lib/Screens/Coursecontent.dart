import 'package:flutter/material.dart';
import 'Classroom.dart';
import 'Dashboard.dart';

class Coursecontent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Tabbar(text: "HND Computer Science",),
          ),
          bottomNavigationBar: BottomNavBAr(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Coursecontentcard(),
                Coursecontentcard(),
                Coursecontentcard(),
                Coursecontentcard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tabbar extends StatelessWidget {
 final  String text;
  const Tabbar({
    Key key, this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Saliu Johnson",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                     text,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            indicatorColor: Colors.white,
            onTap: (index) {},
            tabs: [
              Tab(
                child: Text(
                  "CONTENT",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Classroom(),
                    )),
                child: Tab(
                  child: Text(
                    "CLASSROOM",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Coursecontentcard extends StatelessWidget {
  const Coursecontentcard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
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
                "WEEK1",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text("Introduction to computing"),
              Container(
                color: Colors.grey,
                width: double.infinity,
                child: Text("PDF 1.pdf"),
              ),
              Container(
                color: Colors.grey,
                width: double.infinity,
                child: Text("PDF 2.pdf"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
