import 'package:first_flutter/model/articles_model.dart';

class ArticlesListModel {
  bool success;
  bool has_next;
  List<ArticlesModel> articles;
  var lang;
  var pn;
  Cats cats;
  var cid;
}

class Cats {
  var id;
  var desc;
  var seo;
}
