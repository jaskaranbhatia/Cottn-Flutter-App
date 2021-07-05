import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_collections/utils/utils.dart';
import 'package:flutter_ui_collections/widgets/widgets.dart';
import 'package:flutter_ui_collections/ui/page_news.dart';

class PageComing extends StatefulWidget {
  @override
  _PageComingState createState() => _PageComingState();
}

class _PageComingState extends State<PageComing> {
  Screen size;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          colorCurveSecondary, //or set color with: Color(0xFF0000FF)
    ));
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Center(child: Text("News")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.share),
          ),
        ],
        backgroundColor: colorCurve,
        elevation: 50.0,
      ),
      body: StreamBuilderFireStore(),
    );
  }
}

class StreamBuilderFireStore extends StatelessWidget {
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
      child: ListTile(
        title: latestText(document['title']),
        subtitle: Text(document['body']),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsPage(
                      title: document['title'], body: document['body'])));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 18),
          child: latestText2("Latest News"),
        ),
        Expanded(
          child: Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('posts').snapshots(),
              //print an integer every 2secs, 10 times
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading..");
                }
                return ListView.builder(
                  itemExtent: 100.0,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return _buildList(context, snapshot.data.documents[index]);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

GradientText latestText(String text) {
  return GradientText(text,
      gradient: LinearGradient(colors: [
        Color.fromRGBO(97, 6, 165, 1.0),
        Color.fromRGBO(45, 160, 240, 1.0)
      ]),
      style: TextStyle(
          fontFamily: 'Exo2', fontSize: 16, fontWeight: FontWeight.bold));
}

GradientText latestText2(String text) {
  return GradientText(text,
      gradient: LinearGradient(colors: [
        Color.fromRGBO(97, 6, 165, 1.0),
        Color.fromRGBO(45, 160, 240, 1.0)
      ]),
      style: TextStyle(
          fontFamily: 'Exo2', fontSize: 24, fontWeight: FontWeight.bold));
}
