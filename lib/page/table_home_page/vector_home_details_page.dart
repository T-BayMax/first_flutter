import 'dart:convert';

import 'package:first_flutter/api/api.dart';
import 'package:first_flutter/util/net_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_widget/flutter_html_widget.dart';

class VectorHomeDetailsPage extends StatefulWidget {
  var model;

  VectorHomeDetailsPage({Key key, this.model}) : super(key: key);

  @override
  State<VectorHomeDetailsPage> createState() => new VectorHomeDetailsState();
}

class VectorHomeDetailsState extends State<VectorHomeDetailsPage> {
  var content = '';
  var article;
  var loading = true; //是否正在加载

  @override
  void initState() {
    super.initState();
    getNewsDetails();
  }

  getNewsDetails() {
    var url = Api.HOST +
        '/api/articles/${widget.model['id']}.json?need_image_meta=1&type=2';
    print(url);
    NetUtils.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['success']) {
          setState(() {
            article = map['article'];
            content = article['content'];
            loading = false;
            print(content);
          });
        }
      }
    }, errorCallback: (e) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = new CupertinoActivityIndicator();
    if (loading) {
      contentWidget = new Container(
        alignment: Alignment.center,
        child: new CircularProgressIndicator(),
      );
    } else {
      if (article == null) {
        contentWidget = new Center(
          child: new Column(
            children: <Widget>[
              new Image.asset('./images/result_empty_light.png'),
              new Text('网络异常，请刷新重试')
            ],
          ),
        );
      } else {
        contentWidget = new SingleChildScrollView(
            child: new Column(
          children: <Widget>[
            new Container(
              alignment: Alignment.topLeft,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 14.0),
                    child: new Text(article['title'],
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.white)),
                  ),
                  new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
                        child: new Text(article['feed_title'],
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.white)),
                      ),
                      new Text(article['time'],
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white)),
                    ],
                  ),
                ],
              ),
              color: new Color(0xff5677fc),
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
            ),
            new HtmlWidget(
              html: '$content',
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Image.asset(''),
              ],
            ),
            new Column(
              children: <Widget>[],
            ),
          ],
        ));
      }
    }

    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: const Color(0xff5677fc),

          //  title: new IconButton(icon:new Icon(Icons.arrow_back), onPressed: () {}),
          iconTheme: new IconThemeData(color: Colors.white),
          // centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.share),
                onPressed: () {
                  // do nothing
                }),
            new IconButton(
                icon: new Icon(Icons.speaker_notes), onPressed: () {}),
            new PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                          value: "price", child: new Text('Sort by price')),
                      new PopupMenuItem<String>(
                          value: "time", child: new Text('Sort by time')),
                    ],
                onSelected: (String action) {
                  switch (action) {
                    case "price":
                      // do nothing
                      break;
                    case "time":
                      // do nothing
                      break;
                  }
                }),
          ]),
      body: contentWidget,
    );
  }
}
