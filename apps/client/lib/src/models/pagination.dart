import 'package:flutter/material.dart';

class Pagination {
  int currentPage;
  int total;
  bool loadingData = false;
  final int limit = 10;

  final ScrollController scrollController = ScrollController();

  Pagination({this.currentPage = 1, this.total = 0});

  get hasMore => (currentPage * limit < total) && _isEndOfScroll() && total > 0;
  get nextPage => currentPage + 1;

  bool _isEndOfScroll() {
    return scrollController.position.pixels ==
        scrollController.position.maxScrollExtent;
  }
}
