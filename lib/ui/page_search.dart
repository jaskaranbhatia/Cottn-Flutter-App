import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/ui/page_news.dart';
import 'package:flutter_ui_collections/ui/page_profile.dart';
import 'package:flutter_ui_collections/ui/page_profile.dart';
import 'package:flutter_ui_collections/ui/page_news.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ui_collections/ui/page_login.dart';
import 'package:flutter_ui_collections/widgets/boxfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_ui_collections/widgets/gradient_text.dart';
import 'package:flutter_ui_collections/widgets/widgets.dart';
import 'package:flutter_ui_collections/ui/cotton_price.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_ui_collections/ui/news_display.dart';

class SearchPage extends StatefulWidget {
  String email;

  SearchPage({this.email});

  @override
  _SearchPageState createState() => _SearchPageState(email);
}

class _SearchPageState extends State<SearchPage> {
  String email;
  String latitude, longitude;
  String locationString = "Location Not Detected";
  String city;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _landController = TextEditingController();

  _SearchPageState(this.email);

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var p = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = p[0];
    city = place.locality;
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      locationString = "You're in $city";
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          colorCurveSecondary, //or set color with: Color(0xFF0000FF)
    ));
    return StreamBuilder(
        stream:
            Firestore.instance.collection('users').document(email).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return new Scaffold(
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
                                  colors: <Color>[
                                    colorCurve,
                                    colorCurveSecondary
                                  ]),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/icons/logo_splash.png"),
                                fit: BoxFit.scaleDown,
                              )),
                          child:
                              new Text('', style: TextStyle(color: colorCurve)),
                          margin: EdgeInsets.fromLTRB(0.0, 30.4, 0, 20),
                          padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0)),
                    ),
                  ),
                  CustomListTile(
                      Icons.forum,
                      "Forum",
                      () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage())),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage())),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage())),
                          }),
                ],
              ),
            ),
            appBar: AppBar(
              title: Center(child: Text("Dashboard")),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.share),
                ),
              ],
              backgroundColor: colorCurve,
              elevation: 50.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child:
                        latestText("Welcome " + userDocument["Username"] + "!"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                        child: Card(
                          elevation: 20,
                          color: Color.fromRGBO(74, 162, 191, 1.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35, 20, 30, 20),
                                child: Center(
                                    child: Column(
                                  children: <Widget>[
                                    Text(
                                      "You are in ",
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(userDocument["Location"],
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white)),
                                    )
                                  ],
                                )),
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: const Text(
                                      'UPDATE LOCATION',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: getLocation,
                                  ),
                                  /*FlatButton(
                                    child: const Text('',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginPage()));
                                    },
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
                        child: Card(
                          elevation: 20,
                          color: Color.fromRGBO(239, 145, 61, 0.8),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: Center(
                                    child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Check Cotton\n News ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                    /*Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Text(userDocument["Location"],
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.white)),
                                    )*/
                                  ],
                                )),
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: const Text(
                                      'GO TO NEWS',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PageComing()));
                                    },
                                  ),
                                  /*FlatButton(
                                child: const Text('',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      elevation: 20,
                      color: Color.fromRGBO(221, 70, 132, 0.8),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Text(
                              "To Get The Best Value For Your Produce",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          BoxField(
                              hintText: "Enter Area of Land",
                              controller: _landController,
                              lableText: "Area",
                              obscureText: false,
                              //onSaved: () {},
                              //onFieldSubmitted: () {},
                              icon: Icons.landscape,
                              iconColor: colorCurve),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
                            child: RaisedButton(
                              padding:
                                  const EdgeInsets.fromLTRB(78, 14, 78, 14),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(4.0)),
                              color: colorCurveSecondary,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CottonPrice(
                                            email: email,
                                            area: _landController.text == ""
                                                ? '1'
                                                : _landController.text)));
                              },
                              child: new Text(
                                "Check Future Cotton Prices",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      elevation: 20,
                      color: colorCurveSecondary,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Text(
                              "Publish Your Ads on CottN-Market",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          BoxField(
                              controller: _priceController,
                              hintText: "Enter Selling Price",
                              lableText: "Area",
                              obscureText: false,
                              //onSaved: () {},
                              //onFieldSubmitted: () {},
                              icon: Icons.attach_money,
                              iconColor: colorCurve),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
                            child: RaisedButton(
                              padding:
                                  const EdgeInsets.fromLTRB(138, 14, 138, 14),
                              textColor: colorCurveSecondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(4.0)),
                              color: Colors.white,
                              onPressed: () {
                                Firestore.instance
                                    .collection('market')
                                    .document(email)
                                    .setData({
                                  'Username': userDocument["Username"],
                                  'Phone': userDocument["Phone"],
                                  'Price': _priceController.text,
                                });
                                Fluttertoast.showToast(
                                    msg: 'Ad Published Successfully');
                                _priceController.text = "";
                              },
                              child: new Text(
                                "Publish Ad",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

GradientText latestText(String text) {
  return GradientText(text,
      gradient:
          RadialGradient(radius: 20, colors: [colorCurveSecondary, colorCurve]),
      style: TextStyle(
          fontFamily: 'Exo2', fontSize: 24, fontWeight: FontWeight.bold));
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
