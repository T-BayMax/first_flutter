import 'dart:convert';

import 'package:first_flutter/api/api.dart';
import 'package:first_flutter/model/SitesModel.dart';
import 'package:first_flutter/page/table_sites/sites_details_page.dart';
import 'package:first_flutter/util/net_utils.dart';
import 'package:flutter/material.dart';

class TabTopicsPage extends StatefulWidget {
  String title;

  TabTopicsPage({Key key, this.title}) : super(key: key);

  @override
  State<TabTopicsPage> createState() => new TabTopicsState();
}

class TabTopicsState extends State<TabTopicsPage> {
  List<SitesModel> listData;
  var isError = false;

  @override
  void initState() {
    getSitesList();
    super.initState();
  }

  Future<Null> _pullToRefresh() async {
    getSitesList();
    return null;
  }

  getSitesList() {
    var url = Api.TOPICS_LIST;
    print(url);
    NetUtils.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['success']) {
          setState(() {
            listData = (map['items'] as List)
                ?.map((e) =>
            e == null
                ? null
                : SitesModel.fromJson(e as Map<String, dynamic>))
                ?.toList();
            isError = false;
          });
        }
      }
    }, errorCallback: (e) {
      print(e.toString());
      setState(() {
        isError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body_widget;
    if (listData == null) {
      if (isError) {
        body_widget = new InkWell(
          child: new Container(
            alignment: Alignment.center,
            child: new Column(
              children: <Widget>[
                new Image.asset('./images/result_empty_light.png',
                    width: 100.0, height: 100.0),
                new Text('网络异常，请刷新重试')
              ],
            ),
          ),
          onTap: getSitesList,
        );
      } else {
        body_widget = new Center(
          child: new CircularProgressIndicator(),
        );
      }
    } else {
      body_widget = new RefreshIndicator(
          child: new ListView.builder(
            itemBuilder: (context, i) => new TopicsItem(listData[i]),
            itemCount: listData.length,
          ),
          onRefresh: _pullToRefresh);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${widget.title}'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),

              tooltip: 'search',
              onPressed: () {
                // do nothing
              }),
          new PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                new PopupMenuItem<String>(
                    value: "订阅发现", child: new Text('订阅发现')),
                new PopupMenuItem<String>(
                    value: "新建分组", child: new Text('新建分组')),
                new PopupMenuItem<String>(
                    value: "排序分组", child: new Text('排序分组')),
                new PopupMenuItem<String>(
                    value: "使用提示", child: new Text('使用提示')),
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
      ),
      body: body_widget,
    );
  }
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class TopicsItem extends StatefulWidget {
  TopicsItem(this.entry);

  SitesModel entry;

  @override
  State<TopicsItem> createState() => TopicsItemState();
}

class TopicsItemState extends State<TopicsItem> {
  Widget _buildTiles(SitesModel root) {
    if (root.items == null)
      return new InkWell(
          child: new Padding(
            padding: EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 4.0),
            child: new Row(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: new ClipOval(
                    child: new FadeInImage.assetNetwork(
                      placeholder: "./images/ic_img_default.png",
                      fit: BoxFit.fitWidth,
                      image: root.image,
                      width: 20.0,
                      height: 20.0,
                    ),

                  ),

                ),
                new Text(
                  root.name,
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator
                .of(context)
                .push(new MaterialPageRoute(builder: (ctx) {
              return new SitesDetailsPage(root,'topics');
            }));
            });
    return new ExpansionTile(
      key: new PageStorageKey(root),
      title: new Text(root.name),
      children: root.items.map((sites) => _buildTiles(sites)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(widget.entry);
  }
}
