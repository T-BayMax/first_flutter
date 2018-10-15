import 'package:first_flutter/page/table_home/tab_vector_home_page.dart';
import 'package:first_flutter/page/table_sites/tab_sites_page.dart';
import 'package:first_flutter/page/table_topics/tab_topics_page.dart';
import 'package:first_flutter/page/table_user_info/table_user_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => new HomeState();
}

class HomeState extends State<HomePage> {
  int _tabIndex = 0;
  final tabTextStyleNormal = new TextStyle(fontSize:14.0,color: const Color(0xff969696));
  final tabTextStyleSelected = new TextStyle(color: const Color(0xff63ca6c));

  var tabImages;
  var _body;

  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/tab_vector_home.png'),
          getTabImage('images/tab_vector_home.png')
        ],
        [
          getTabImage('images/tab_vector_site.png'),
          getTabImage('images/tab_vector_site.png')
        ],
        [
          getTabImage('images/tab_vector_topic.png'),
          getTabImage('images/tab_vector_topic.png')
        ],
        [
          getTabImage('images/tab_vector_discovery.png'),
          getTabImage('images/tab_vector_discovery.png')
        ],
        [
          getTabImage('images/tab_vector_my.png'),
          getTabImage('images/tab_vector_my.png')
        ]
      ];
    }
    _body = new IndexedStack(
      children: <Widget>[
        new TableVectorPage(title: '文章'),
        new TabSitesPage(title: '站点'),
        new TabTopicsPage(title: '主题'),
        new UserInfoPage(title: '专栏'),
        new UserInfoPage(title: '我的')
      ],
      index: _tabIndex,
    );
  }

  TextStyle getTabTextStyle(int curIndex) {
 /*   if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }*/
    return tabTextStyleNormal;
  }

  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  Text getTabTitle(int curIndex) {
    return new Text("", style: getTabTextStyle(curIndex));
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return new MaterialApp(
      theme: new ThemeData(primaryColor: const Color(0xff0aa284)),
      home: new Scaffold(
        //  appBar: new AppBar(iconTheme: new IconThemeData(color: Colors.white)),
        body: _body,
        bottomNavigationBar: new CupertinoTabBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0), title: getTabTitle(0) ),
            new BottomNavigationBarItem(
                icon: getTabIcon(1), title: getTabTitle(1)),
            new BottomNavigationBarItem(
                icon: getTabIcon(2), title: getTabTitle(2)),
            new BottomNavigationBarItem(
                icon: getTabIcon(3), title: getTabTitle(3)),
            new BottomNavigationBarItem(
                icon: getTabIcon(4), title: getTabTitle(4)),
          ],
          currentIndex: _tabIndex,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
        //drawer: new MyDrawer(),
      ),
    );
  }
}
