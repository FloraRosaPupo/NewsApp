import 'package:get/get.dart';
import 'package:newa/data/model/newsModel.dart';

class Newscontrollers extends GetxController{
    var favoriteNews = <NewsModel>[].obs; //lista vazia

  void add(NewsModel item){
    favoriteNews.add(item);
  }

  void remove(NewsModel item){
    favoriteNews.remove(item);
  }
}