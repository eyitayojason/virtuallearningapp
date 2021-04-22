import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'Coursesscreen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            color: Colors.orange,
            child: Padding(
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
                        "HND Computer Science",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBAr(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UPDATES",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Updatecards(),
                          Updatecards(),
                          Updatecards(),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NEWS",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      child: Column(
                        children: [
                          InkWell(
                            child: Updatecards(),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Coursesscreen(),
                              ),
                            ),
                          ),
                          Updatecards(),
                          Updatecards(),
                          Updatecards(),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavBAr extends StatefulWidget {
  const BottomNavBAr({
    Key key,
  }) : super(key: key);

  @override
  _BottomNavBArState createState() => _BottomNavBArState();
}

class _BottomNavBArState extends State<BottomNavBAr> {
  int _selectedIndex = 0;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return GNav(
        backgroundColor: Colors.white,
        hoverColor: Colors.grey[700],
        haptic: true,
        tabBorderRadius: 15,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        tabs: [
          GButton(
            icon: LineIcons.dashcube,
            onPressed: (index) {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Coursesscreen(),
                    ));
              });
            },
          ),
          GButton(
            icon: LineIcons.inbox,
          ),
          GButton(
            icon: LineIcons.user,
          )
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        });
  }
}

class Updatecards extends StatelessWidget {
  const Updatecards({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "COM 215 VISUAL BASIC",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                "Adsfadfsdfvdfsgfdgsfgfssdfaf.\nsddafsdfdasfsdafaasdffasfdasfsda"),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "2mins ago",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(
                  width: 130,
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
