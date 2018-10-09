class ArticlesModel {
  var id;
  var title;
  var time;
  var rectime;
  var uts;
  var feed_title;
  var img;
  var abs;
  var cmt;
  var st;
  var go;
  var url;
  var content;
  List<Images> images;
  var lang;
  List<Topics> topics;
  var like;
  Site site;
}
class Site{
  var id;
  var title;
  var image;
  var cover;
}
class Images {
  String id;
  var w;
  var h;
  String src;
}

class Topics {
  var id;
  var name;
  var image;
  var followed;
}
