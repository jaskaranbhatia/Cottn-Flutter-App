import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_ui_collections/ui/graphs.dart';

class CottonPrice extends StatefulWidget {
  String email,area;
  CottonPrice({this.email,this.area});
  @override
  _CottonPriceState createState() => _CottonPriceState(email,area);
}

class _CottonPriceState extends State<CottonPrice> {
  String email,area;
  _CottonPriceState(this.email,this.area);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Latest Trends")),
          backgroundColor: colorCurve,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Graphs()));
                  },
                  child: Icon(Icons.insert_chart)),
            ),
          ],
          elevation: 5.0,
          bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Text("Overview",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Text("Monthly",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Text("Daily",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            Overview(email,area),
            List(),
            List2(),
          ],
        ),
      ),
    );
  }
}

class Overview extends StatefulWidget {
  String email,area;
  Overview(this.email,this.area);
  @override
  _OverviewState createState() => _OverviewState(email,area);
}

class _OverviewState extends State<Overview> {
  String email,area;
  String fPrice;
  _OverviewState(this.email,this.area);
  TextEditingController _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future:
              DefaultAssetBundle.of(context).loadString('database/daily.json'),
          builder: (context, snapshot) {
            int totalPrice;
            var now = new DateTime.now();
            var nday = now.day - 10;
            var myData = jsonDecode(snapshot.data.toString());
            var tPrice = myData[nday]["modal_price"];
            var yPrice = myData[nday - 1]["modal_price"];
            var tmPrice = myData[nday + 1]["modal_price"];
            var lastWeekPrice = myData[nday - 7]["modal_price"];
            totalPrice = int.parse(area)*9*int.parse(tPrice);
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(34.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(width: 3, color: colorCurveSecondary)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                        child: Center(
                            child: Text(
                          "Today's Price : " + tPrice,
                          style: TextStyle(
                              color: colorCurve,
                              fontSize: 21,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                      child: Text(
                        "Sell in CottN-Market",
                        style: TextStyle(
                            color: colorCurve,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Divider(
                      thickness: 3,
                      color: colorCurve,
                    ),
                    BoxField(
                        controller: _priceController,
                        hintText: "Enter Selling Price",
                        lableText: "SPrice",
                        obscureText: false,
                        icon: Icons.attach_money,
                        iconColor: colorCurve),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Container(
                          child: RaisedButton(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                            child: Text(
                              "Post Ad",
                              style: TextStyle(
                                  fontFamily: 'Exo2',
                                  color: Colors.white,
                                  fontSize: 20.0),
                            ),
                            color: colorCurve,
                            onPressed: () {
                              Firestore.instance
                                  .collection('market')
                                  .document(email)
                                  .updateData({
                                'Price': _priceController.text,
                              });
                              Fluttertoast.showToast(
                                  msg: 'Ad Published Successfully');
                              _priceController.text = "";
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                      child: Text(
                        "Detailed Information",
                        style: TextStyle(
                            color: colorCurve,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Divider(
                      thickness: 3,
                      color: colorCurve,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text("District : Patiala"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text("Today's Price : " + tPrice),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text("Yesterday's Price : " + yPrice),
                              ),
                              Text("Tommorow's Price : " + tmPrice.substring(0,4))
                            ],
                          ),
                        ),
                        VerticalDivider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text("52wk Low : 3890"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text("52wk High : 6640"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text("Percentage Change : +4"),
                              ),
                              Text("Last Week Price  : " + lastWeekPrice)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 3,
                      color: colorCurve,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Center(
                        child: Card(
                        elevation: 11,
                        color: colorCurveSecondary,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            child: Text("Total Estimated Price For Your Produce is : "+totalPrice.toString()+"/-\nby cultivating on $area Acre of Land",style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 110,
      width: 3.0,
      color: colorCurve,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}

class List extends StatefulWidget {
  List data;
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future:
              DefaultAssetBundle.of(context).loadString('assets/monthly.json'),
          builder: (context, snapshot) {
            var myData = jsonDecode(snapshot.data.toString());
            var months = [
              "January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December"
            ];
            return ListView.builder(
                itemCount: 12,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(months[index]),
                    subtitle: Text("Avg Price : " +
                        myData[index]["avg_modal_price"].substring(0, 7)),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                });
          }),
    );
  }
}

class List2 extends StatefulWidget {
  List data;
  @override
  _List2State createState() => _List2State();
}

class _List2State extends State<List2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future:
              DefaultAssetBundle.of(context).loadString('database/daily.json'),
          builder: (context, snapshot) {
            var myData = jsonDecode(snapshot.data.toString());
            return ListView.builder(
                itemCount: 31,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(myData[index]["arrival_date"]),
                    subtitle: Text(
                        "Predicted Price : " + myData[index]["modal_price"]),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                });
          }),
    );
  }
}
