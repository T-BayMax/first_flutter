import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  var title;

  UserInfoPage({this.title});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var userAvatar;
  var userName;
  var titles = ["我的待读", "我的收藏", "我的推刊", "消息通知", "阅读历史",'END_LINE_TAG'];
  var settingTitles = ["夜间模式", "离线阅读", "检查更新", "意见反馈", "关于我们"];

  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        backgroundColor: Colors.green,
        iconTheme: new IconThemeData(color: Colors.transparent),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.settings),
              color: Colors.white,
              tooltip: 'search',
              onPressed: () {
                // do nothing
              })
        ],
      ),
      body: new Container(
        color: Colors.black12,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 86.0,
              flexibleSpace: new InkWell(
                child: new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      userAvatar == null
                          ? new Image.asset(
                              "images/menu_user.png",
                              width: 56.0,
                              height: 56.0,
                            )
                          : new Container(
                              width: 56.0,
                              height: 56.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  image: new DecorationImage(
                                      image: new NetworkImage(userAvatar),
                                      fit: BoxFit.cover),
                                  border: new Border.all(
                                      color: Colors.black12, width: 2.0)),
                            ),
                      new Container(
                        margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: new Text(
                          userName == null ? '点击头像登录' : userName,
                          style: new TextStyle(
                              color: Colors.black, fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 4.0),
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black12,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  index -= 1;
                  if (index.isOdd) {
                    return new Divider(height: 1.0,color: Colors.black12,);
                  }
                  index = index ~/ 2;
                  if (titles[index] is String && titles[index] == 'END_LINE_TAG') {
                    return new Divider(height: 12.0,color: Colors.black12,);
                  }
                  return new Container(
                        padding:EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Text(titles[index]),

                  );
                },
                childCount: titles.length*2,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  index -= 1;
                  if (index.isOdd) {
                    return new Divider(height: 1.0,color: Colors.black12,);
                  }
                  index = index ~/ 2;
                  return new Container(
                    padding:EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Text(settingTitles[index]),

                  );
                },
                childCount: settingTitles.length*2,
              ),
            ),
          ],
        ),
      ),
    );
  }

//  构建布局
  Widget initView() {
    return new Container(
      child: new Column(children: <Widget>[
        new Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              userAvatar == null
                  ? new Image.asset(
                      "images/menu_user.png",
                      width: 48.0,
                      height: 48.0,
                    )
                  : new Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: new DecorationImage(
                              image: new NetworkImage(userAvatar),
                              fit: BoxFit.cover),
                          border: new Border.all(
                              color: Colors.black12, width: 2.0)),
                    ),
              new Container(
                margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: new Text(
                  userName == null ? '点击头像登录' : userName,
                  style: new TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              )
            ],
          ),
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
          margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 4.0),
          color: Colors.white,
        ),

        /* new ListView.builder(
        itemBuilder: (context, i) => new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(
                        titles[i],
                        style: titleTextStyle,
                      )),
                      rightArrowIcon
                    ],
                  ),
                ),
                new Divider(
                  height: 1.0,
                )
              ],
            ),
      ),*/
      ]),
      color: Colors.black12,
    );
  }
}
