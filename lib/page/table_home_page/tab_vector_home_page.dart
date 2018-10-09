import 'package:first_flutter/api/api.dart';
import 'package:first_flutter/page/table_home_page/home_news_list_page.dart';
import 'package:flutter/material.dart';

class TableVectorPage extends StatefulWidget {
  TableVectorPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful,
  // meaning that it has a State object (defined below) that contains
  // fields that affect how it looks.

  // This class is the configuration for the state. It holds the
  // values (in this case the title) provided by the parent (in this
  // case the App widget) and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _TableVectorPageState createState() => new _TableVectorPageState();
}

class Choice {
  Choice({this.title, this.url, this.cid});

  String title;
  String url;
  String cid;
}

List<Choice> choices = [
  new Choice(title: '推荐', url: Api.NEWS_REC_LIST),
  new Choice(title: '热门', url: Api.NEWS_HOT_LIST, cid: '0'),
  new Choice(title: '科技', url: Api.NEWS_HOT_LIST, cid: '101000000'),
  new Choice(title: '创业', url: Api.NEWS_HOT_LIST, cid: '101040000'),
  new Choice(title: '数码', url: Api.NEWS_HOT_LIST, cid: '101050000'),
  new Choice(title: '技术', url: Api.NEWS_HOT_LIST, cid: '20'),
  new Choice(title: '设计', url: Api.NEWS_HOT_LIST, cid: '108000000'),
  new Choice(title: '营销', url: Api.NEWS_HOT_LIST, cid: '114000000'),
];

class _TableVectorPageState extends State<TableVectorPage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: choices.length,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: const Color(0xff63ca6c),
          title: new Text(widget.title),
          //leading: new Icon(Icons.home), 不设置这个属性，则 Drawer 会自动显示一个图标
          // centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add_alarm),
                tooltip: 'Add Alarm',
                onPressed: () {
                  // do nothing
                }),
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
                })
          ],
          bottom: new TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: choices.map((Choice choice) {
              return new Tab(
                text: choice.title,
                // icon: new Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: new TabBarView(
          children: choices.map((Choice choice) {
            return new HomeNewsListPage(NEWS_LIST: choice);
          }).toList(),
        ),
      ),
    );
  }
}
