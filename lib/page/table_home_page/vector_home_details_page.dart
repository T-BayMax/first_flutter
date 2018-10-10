import 'dart:convert';

import 'package:first_flutter/api/api.dart';
import 'package:first_flutter/util/net_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

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
  final artickeImage = [
    './images/article_detail_like.png',
    './images/article_detail_fav_un.png',
    './images/article_detail_weibo.png',
    './images/article_detail_weixin.png'
  ];

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

  Widget getIconImage(path) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: new Image.network(path, width: 30.0, height: 30.0),
    );
  }

  topicsRow(var topics) {
    List<Widget> listWidget = [];
    //if (topics is List<Topics>) {
    for (int i = 0; i < topics.length; i++) {
      var item = topics[i];
      var listItemContent = new Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
        child: new Row(
          children: <Widget>[
            getIconImage(item['image']),
            new Expanded(
                child: new Text(
                  item['name'],
                  style: new TextStyle(fontSize: 16.0),
                )),
            new Image.asset(
              'images/ic_arrow_right.png',
              width: 16.0,
              height: 16.0,
            ),
          ],
        ),
      );
      listWidget.add(listItemContent);
      if (i != topics.length - 1)
        listWidget.add(new Divider());
    }
    // }
    return listWidget;
  }

  articleRow() {
    List<Widget> listWidget = [];
    for (int i = 0; i < artickeImage.length; i++) {
      listWidget.add( new Expanded(
        child: new CircleAvatar(
          child:
          new Image.asset(artickeImage[i]),
          backgroundColor: Colors.white,
        ),
      ));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = new CircularProgressIndicator();
    if (loading) {
      contentWidget = new Container(
        alignment: Alignment.center,
        child: new CircularProgressIndicator(),
      );
    } else {
      if (article == null) {
        contentWidget = new Container(
          alignment: Alignment.center,
          child: new Column(
            children: <Widget>[
              new Image.asset('./images/result_empty_light.png', width: 100.0,
                  height: 100.0),
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
                        padding: new EdgeInsets.fromLTRB(
                            10.0, 16.0, 10.0, 14.0),
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
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                ),
                new HtmlView(
                  data: '$content',
                ),
                new Container(
                  foregroundDecoration: new BoxDecoration(
                    border: new Border.all(
                        color: new Color(0xFFECECEC),
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                  margin: EdgeInsets.fromLTRB(28.0, 10.0, 28.0, 8.0),
                  padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 28.0),
                  child: new Row(
                    children: articleRow(),
                  ),
                ),
                new Container(
                  foregroundDecoration: new BoxDecoration(
                    border: new Border.all(
                        color: new Color(0xFFECECEC),
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                  margin: EdgeInsets.fromLTRB(28.0, 6.0, 28.0, 8.0),
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: new Column(
                    children: topicsRow(article['topics']),
                  ),
                ),
              ],
            ));
      }
    }
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: const Color(0xff5677fc),
          elevation: 0.0,
          // 下部的影子
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
                itemBuilder: (BuildContext context) =>
                <PopupMenuItem<String>>[
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
