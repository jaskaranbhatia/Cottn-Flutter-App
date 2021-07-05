import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ui_collections/ui/page_profile.dart';
import 'package:flutter_ui_collections/ui/page_login.dart';
import 'package:flutter_ui_collections/ui/news_display.dart';

class PageComingSoon extends StatelessWidget {
  String title, body;

  PageComingSoon({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          children: <Widget>[
            new SizedBox(
              height: 170.0,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: new DrawerHeader(
                    decoration: new BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[colorCurve, colorCurveSecondary]),
                        image: DecorationImage(
                          image: AssetImage("assets/icons/logo_splash.png"),
                          fit: BoxFit.scaleDown,
                        )),
                    child: new Text('', style: TextStyle(color: colorCurve)),
                    margin: EdgeInsets.fromLTRB(0.0, 30.4, 0, 20),
                    padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0)),
              ),
            ),
            CustomListTile(
                Icons.forum,
                "Forum",
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                    }),
            CustomListTile(
                Icons.dvr,
                "Cotton News",
                () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageComing())),
                    }),
            CustomListTile(
                Icons.phone,
                "Contact Us",
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                    }),
            CustomListTile(
                Icons.event_note,
                "Privacy Policy",
                () => {
                      /*
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          email: email,
                                        ))),
                          }*/
                    }),
            CustomListTile(
                Icons.exit_to_app,
                "Log Out",
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                    }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(child: Text("CottN Market")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.share),
          ),
        ],
        backgroundColor: colorCurve,
        elevation: 50.0,
      ),
      body: Listview(),
    );
  }
}

//
//GradientText latestText(String text) {
//  return GradientText(text,
//      gradient: LinearGradient(colors: [
//        Color.fromRGBO(97, 6, 165, 1.0),
//        Color.fromRGBO(45, 160, 240, 1.0)
//      ]),
//      style: TextStyle(
//          fontFamily: 'Exo2', fontSize: 20, fontWeight: FontWeight.bold));
//}
class Listview extends StatefulWidget {
  @override
  _ListviewState createState() => _ListviewState();
}

class _ListviewState extends State<Listview> {
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("market").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getPosts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorCurveSecondary,
                            ),
                            child: ExpansionTile(
                                /*contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),*/
                                leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child: Icon(
                                      (Icons.person),
                                      color: Colors.white,
                                      size: 35,
                                    )),
                                title: Text(
                                  "Seller : " +
                                      snapshot.data[index].data["Username"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(
                                    "Price : ₹" +
                                        snapshot.data[index].data["Price"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        (Icons.call),
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Contact :  " +
                                            snapshot.data[index].data["Phone"],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.content_copy),
                                        color: Colors.white,
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: snapshot
                                                  .data[index].data["Phone"]));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                /*subtitle: Row(
                                  children: <Widget>[
                                    Icon(Icons.call, color: Colors.yellowAccent),
                                    Text(
                                      "Contact: " +
                                          snapshot.data[index].data["Phone"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),*/
                                trailing: Icon(
                                  (Icons.keyboard_arrow_down),
                                  color: Colors.white,
                                )),
                          ));
                    }),
              );
            }
          }),
    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: InkWell(
          splashColor: colorCurveSecondary,
          onTap: onTap,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                if (icon != null) Icon(Icons.arrow_forward_ios)
              ],
            ),
          )),
    );
  }
}
