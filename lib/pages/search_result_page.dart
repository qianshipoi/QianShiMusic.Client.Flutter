import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/widgets/app_bar_search.dart';

class SearchResultPage extends StatefulWidget {
  final String keyword;
  const SearchResultPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearch(
        value: widget.keyword,
        onCancel: Get.back,
        onTap: Get.back,
      ),
      body: Container(),
    );
  }
}
