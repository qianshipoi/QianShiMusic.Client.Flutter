import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/responses/search/search_suggest_response.dart';
import 'package:qianshi_music/pages/search_result_page.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/app_bar_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class SearchType {
  final String name;
  final int type;
  const SearchType(this.name, this.type);
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<SearchSuggestResultMatch> _results = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _suggest() async {
    logger.i('suggest');
    if (_controller.text.isEmpty) {
      _results.clear();
      return;
    }
    final response =
        await SearchProvider.suggest(_controller.text, isMobile: true);
    if (response.code != 200) {
      Get.snackbar('提示', response.msg!);
      return;
    }
    logger.i('reset');
    final result = response.result!;
    _results.clear();
    _results.addAll(result.allMatch);
    setState(() {});
  }

  _search(String keyword) {
    if (keyword.isEmpty) {
      return;
    }
    _controller.text = keyword;
    Get.to(() => SearchResultPage(keyword: keyword),
        transition: Transition.noTransition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearch(
        autoFocus: true,
        controller: _controller,
        hintText: '搜索歌曲、歌手、专辑',
        onSearch: (value) => _search(value),
        onChanged: (value) => _suggest(),
        onCancel: () => Get.back(),
      ),
      body: ListView.builder(
          itemCount: _results.length,
          itemBuilder: (context, index) {
            final result = _results[index];
            return ListTile(
              leading: const Icon(Icons.search),
              title: Text(result.keyword),
              onTap: () => _search(result.keyword),
            );
          }),
    );
  }
}
