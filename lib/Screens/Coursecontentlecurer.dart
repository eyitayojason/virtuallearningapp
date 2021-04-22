import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'Coursecontent.dart';
import 'Dashboard.dart';

class Coursecontentlecturer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Tabbar(
              text: "Department of Computer Science COM215",
            ),
          ),
          bottomNavigationBar: BottomNavBAr(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Coursecontentcard(),
                Coursecontentcard(),
                Coursecontentcard(),
                Container(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              LineIcon(Icons.upload_outlined),
                              SizedBox(width: 20,),
                              Text("Add New Content")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
