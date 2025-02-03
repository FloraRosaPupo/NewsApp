
import 'package:flutter/material.dart';
import 'package:newa/data/http/exception.dart';
import 'package:newa/data/model/newsModel.dart';
import 'package:newa/data/repositories/newsRepository.dart';

class NewsStores {
  final INewsRepository repository;

  //loading
  final ValueNotifier<bool> isLoading =
      ValueNotifier(false); //nao exibe nenhum carregamento
  //state
  final ValueNotifier<List<NewsModel>> state =
      ValueNotifier<List<NewsModel>>([]); //lista vazia
  //error
  final ValueNotifier<String> error = ValueNotifier('');

  NewsStores({required this.repository});

  Future getNews() async {
    isLoading.value = true;

    try {
      //estancia do repositorio do News
      final result = await repository.getNews(); //pega a lista de produtos
      state.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }
}
