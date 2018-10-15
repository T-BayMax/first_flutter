import 'dart:async';
import 'dart:convert';

import 'package:first_flutter/Widgets/common_end_line.dart';
import 'package:first_flutter/model/articles_model.dart';
import 'package:first_flutter/page/table_home/tab_vector_home_page.dart';
import 'package:first_flutter/page/table_home/vector_home_details_page.dart';
import 'package:first_flutter/util/net_utils.dart';
import 'package:flutter/material.dart';

class HomeNewsListPage extends StatefulWidget {
  Choice NEWS_LIST;

  HomeNewsListPage({Key key, this.NEWS_LIST}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new HomeNewsListPageState();
}

class HomeNewsListPageState extends State<HomeNewsListPage> {
  var listData;
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

  HomeNewsListPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && has_next) {
        // scroll to bottom, get next page data
        last_id = listData[listData.length - 1]["id"];
        uts=listData[listData.length - 1]["uts"];
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

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget listView = new ListView.builder(
        itemCount: listData.length * 2,
        itemBuilder: (context, i) => renderRow(i),
        controller: _controller,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  getNewsList(bool isLoadMore) {
    Choice news = widget.NEWS_LIST;
    StringBuffer sb = new StringBuffer();
    switch (pn) {
      case 0:
        {
          sb.write(news.url + '?size=30&lang=-1&cid=${news.cid}&is_pad=1');
          break;
        }
      case 1:
        {
          sb.write(news.url +
              "?size=30&pn=1&last_id=$last_id&lang=1&cid=${news.cid}&is_pad=1");
          break;
        }
      default:
        {
        //  var now = new DateTime.now().millisecondsSinceEpoch;
          sb.write(news.url +
              "?size=30&pn=$pn&last_id=$last_id&last_time=$uts&lang=1&cid=${news.cid}&is_pad=1");
          break;
        }
    }
    print("newsListUrl: ${sb.toString()}");
    NetUtils.get(sb.toString(), (data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['success']) {
          has_next = map['has_next'];
          var _listData = map['articles'];
          pn = map['pn'] + 1;

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
