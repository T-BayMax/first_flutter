import 'dart:convert';

import 'package:first_flutter/Widgets/common_end_line.dart';
import 'package:first_flutter/api/api.dart';
import 'package:first_flutter/model/SitesModel.dart';
import 'package:first_flutter/page/table_home/vector_home_details_page.dart';
import 'package:first_flutter/util/net_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SitesDetailsItemPage extends StatelessWidget {
  const SitesDetailsItemPage({Key key, this.icon, this.children})
      : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: Icon(icon, color: themeData.primaryColor)),
              Expanded(
                  child: _ContactItem(
                lines: ['23131', 'fsdf', 'ffsdaf', 'fdsaf'],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({Key key, this.icon, this.lines, this.tooltip, this.onPressed})
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines
        .sublist(0, lines.length - 1)
        .map<Widget>((String line) => Text(line))
        .toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren))
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
          width: 72.0,
          child: IconButton(
              icon: Icon(icon),
              color: themeData.primaryColor,
              onPressed: onPressed)));
    }
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}

class PestoStyle extends TextStyle {
  const PestoStyle({
    double fontSize: 12.0,
    FontWeight fontWeight,
    Color color: Colors.black87,
    double letterSpacing,
    double height,
  }) : super(
          inherit: false,
          color: color,
          fontFamily: 'Raleway',
          fontSize: fontSize,
          fontWeight: fontWeight,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: letterSpacing,
          height: height,
        );
}

class SitesDetailsPage extends StatefulWidget {
  SitesDetailsPage(this.root,this.table);

  final SitesModel root;
  final String table;

  @override
  SitesDetailsState createState() => SitesDetailsState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class SitesDetailsState extends State<SitesDetailsPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _kAppBarHeight = 236.0;

  static const double _kFabHalfSize = 28.0;
  static const double _kRecipePageMaxWidth = 500.0;

  static const double kLogoHeight = 206.0;
  static const double kLogoWidth = 320.0;
  static const double kImageHeight = 18.0;
  static const double kTextHeight = 108.0;

  var listData=[];
  var curPage = 1;
  var has_next = false;
  var pn = 0;
  var last_id;
  var uts;

  static final String END_LINE_TAG = "COMPLETE";
  ScrollController _controller = new ScrollController();
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);
  TextStyle subtitleStyle =
  new TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);


  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  SitesDetailsState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && has_next) {
        pn +=1;
        // scroll to bottom, get next page data
        last_id = listData[listData.length - 1]["id"];
        uts = listData[listData.length - 1]["uts"];
        print("load more ... ");
        curPage++;
        getNewsList(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsList(false);
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    pn = 0;
    getNewsList(false);
    return null;
  }

  getNewsList(bool isLoadMore) {
    StringBuffer sb = new StringBuffer();
    sb.write(Api.HOST);
    if(widget.table=='sites'){
      sb.write('/api/sites/');
    }else {
      sb.write('/api/topics/');
    }
    if (pn == 0) {
      sb.write('${widget.root.id}.json?pn=0&size=30');
    } else {
      sb.write(
          '${widget.root.id}.json?pn=$pn&last_id=$last_id&size=30');
    }

    print("newsListUrl: ${sb.toString()}");
    NetUtils.get(sb.toString(), (data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['success']) {
          has_next = map['has_next'];
          var _listData = map['articles'];


          setState(() {
            if (!isLoadMore) {
              listData = _listData;
            } else {
              List list1 = new List();
              list1.addAll(listData);
              list1.addAll(_listData);
              if (!has_next) {
                list1.add(END_LINE_TAG);
              }
              listData = list1;
            }
          });
        }
      }
    }, errorCallback: (e) {
      print("get news list error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return  Theme(
          data: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            platform: Theme.of(context).platform,
          ),
          child: Scaffold(
            key: _scaffoldKey,
            body: new RefreshIndicator(
            child:CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: _kAppBarHeight,
                  pinned: _appBarBehavior == AppBarBehavior.pinned,
                  floating: _appBarBehavior == AppBarBehavior.floating ||
                      _appBarBehavior == AppBarBehavior.snapping,
                  snap: _appBarBehavior == AppBarBehavior.snapping,
                  flexibleSpace: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    //这是AppBar的总高度
                    double biggestHeight = constraints.biggest.height;
                    //当前的AppBar的真实高度，去掉了状态栏
                    final double appBarHeight = biggestHeight - statusBarHeight;
                    //appBarHeight - kToolbarHeight 代表的是当前的扩展量，_kAppBarHeight - kToolbarHeight表示最大的扩展量

                    //t就是，变化的Scale
                    final double t = (appBarHeight - kToolbarHeight) /
                        (_kAppBarHeight - kToolbarHeight);
                    // begin + (end - begin) * t; lerp函数可以快速取到根据当前的比例中间值
                    final double extraPadding =
                        new Tween<double>(begin: 10.0, end: 24.0).lerp(t);
                    final double logoHeight = appBarHeight - 1.5 * extraPadding;

                    //字体的样式没有发生变化。
                    final TextStyle titleStyle = const PestoStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        letterSpacing: 3.0);
                    print('constraints=' + titleStyle.fontSize.toString());
                    //字体所占用的rect空间
                    final RectTween _textRectTween = new RectTween(
                        begin:
                            Rect.fromLTWH(0.0, 10.0, kLogoWidth, kTextHeight),
                        end: Rect.fromLTWH(0.0, kImageHeight + kTextHeight,
                            kLogoWidth, kTextHeight));
                    //透明度变化的曲线。这里是easeInOut
                    final Curve _textOpacity =
                        const Interval(0.4, 1.0, curve: Curves.easeInOut);

                    //图片所占用的rect空间
                    final RectTween _imageRectTween = new RectTween(
                        begin: Rect.fromLTWH(0.0, kImageHeight - logoHeight,
                            kLogoWidth, kLogoHeight),
                        end: Rect.fromLTWH(0.0, 48.0, kLogoWidth, kLogoHeight));

                    return Padding(
                      padding: new EdgeInsets.only(
                        //这个padding就直接设置变化
                        top: statusBarHeight + 0.5 * extraPadding,
                        bottom: extraPadding,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: kLogoWidth,
                          child: Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned.fromRect(
                                //这里传递的占用位置也是不断变化的，这里说明其实我们外层其实也可以用SizedBox来实现？
                                rect: _textRectTween.lerp(t),
                                child: new Text(
                                  '${widget.root.name}',
                                  style: titleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Positioned.fromRect(
                                rect: _imageRectTween.lerp(t),
                                child: Center(
                                  //创建一个透明度来包裹
                                  child: Opacity(
                                    //找到这个曲线上t百分比占的位置
                                    opacity: _textOpacity.transform(t),
                                    child: new Column(
                                      children: <Widget>[
                                        new ClipOval(
                                          child: new FadeInImage.assetNetwork(
                                            placeholder:
                                                "./images/ic_img_default.png",
                                            //fit: BoxFit.fitWidth,
                                            image: widget.root.image,
                                            width: 68.0,
                                            height: 68.0,
                                          ),
                                        ),
                                        new Container(
                                          foregroundDecoration:
                                              new BoxDecoration(
                                            border: new Border.all(
                                                color: new Color(0xFFECECEC),
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 40.0, 0.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(
                                              16.0, 4.0, 16.0, 4.0),
                                          child: new Text('关注'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return renderRow(index);
                      },

                      childCount: listData.length,
                  ),
                ),
               // listView,
              ],
              controller: _controller,
            ),onRefresh: _pullToRefresh),
          ),
        );

  }

  Widget renderRow(i) {
    i -= 1;
    if (i.isOdd) {
      return new Divider(height: 2.0);
    }
    i = i ~/ 2;
    var itemData = listData[i];
    if (itemData is String && itemData == END_LINE_TAG) {
      return new CommonEndLine();
    }
    var titleRow = new Row(
      children: <Widget>[
        new Expanded(
          child: new Text(itemData['title'], style: titleTextStyle),
        )
      ],
    );
    var timeRow = new Row(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: new Text(
            itemData['feed_title'],
            style: subtitleStyle,
          ),
        ),
        new Expanded(
          //flex: 1,
          child: new Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text("${itemData['rectime']}", style: subtitleStyle),
            ],
          ),
        )
      ],
    );
    var thumbImgUrl = itemData['img'];
    var thumbImg = new Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFECECEC),
        image: new DecorationImage(
            image: new ExactAssetImage('./images/ic_img_default.png'),
            fit: BoxFit.cover),
        border: new Border.all(
          color: const Color(0xFFECECEC),
          width: 1.0,
        ),
      ),
    );
    if (thumbImgUrl != null && thumbImgUrl.length > 0) {
      thumbImg = new Container(
        // margin: const EdgeInsets.all(10.0),
        /*width: 60.0,
        height: 60.0,*/
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFECECEC),
          image: new DecorationImage(
              image: new NetworkImage(thumbImgUrl), fit: BoxFit.cover),
          border: new Border.all(
            color: const Color(0xFFECECEC),
            width: 1.0,
          ),
        ),
      );
    }
    var row = new Row(
      children: <Widget>[
        new Expanded(
          flex: 1,
          child: new Padding(
            padding: const EdgeInsets.all(6.0),
            child: new Column(
              children: <Widget>[
                titleRow,
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: timeRow,
                )
              ],
            ),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(6.0),
          child: new Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child: new Center(
              child: thumbImg,
            ),
          ),
        )
      ],
    );
    return new InkWell(
      child: row,
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
          return new VectorHomeDetailsPage(model: itemData);
        }));
      },
    );
  }
}
