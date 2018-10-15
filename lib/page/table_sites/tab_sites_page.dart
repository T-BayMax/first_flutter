import 'dart:convert';

import 'package:first_flutter/api/api.dart';
import 'package:first_flutter/model/SitesModel.dart';
import 'package:first_flutter/page/table_sites/sites_details_page.dart';
import 'package:first_flutter/util/net_utils.dart';
import 'package:flutter/material.dart';

class TabSitesPage extends StatefulWidget {
  String title;

  TabSitesPage({Key key, this.title}) : super(key: key);

  @override
  State<TabSitesPage> createState() => new TabSitesState();
}

class TabSitesState extends State<TabSitesPage> {
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
    var url = Api.SITES_LIST;
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
            itemBuilder: (context, i) => new SitesItem(listData[i]),
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
                    value: "仅中文", child: new Text('仅中文')),
                new PopupMenuItem<String>(
                    value: "仅英文", child: new Text('仅英文')),
                new PopupMenuItem<String>(
                    value: "中英混合", child: new Text('中英混合')),
                new PopupMenuItem<String>(
                    value: "推荐设置", child: new Text('推荐设置')),
                new PopupMenuItem<String>(
                    value: "定制频道", child: new Text('定制频道')),
                new PopupMenuItem<String>(
                    value: "一周拾遗", child: new Text('一周拾遗')),
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
class SitesItem extends StatefulWidget {
  SitesItem(this.entry);

  SitesModel entry;

  @override
  State<SitesItem> createState() => SitesItemState();
}

class SitesItemState extends State<SitesItem> {
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
              return new SitesDetailsPage(root,'sites');
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
