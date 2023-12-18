// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionTagsPage extends StatefulWidget {
  final List<String> tags;
  final List<String> selectedTags;
  const SelectionTagsPage({
    super.key,
    required this.tags,
    required this.selectedTags,
  });

  @override
  State<SelectionTagsPage> createState() => _SelectionTagsPageState();
}

class _SelectionTagsPageState extends State<SelectionTagsPage> {
  List<_SelectionItem> _items = [];
  int get _selectedCount => _items.where((e) => e.selected).length;

  @override
  void initState() {
    super.initState();
    _items = widget.tags
        .map((e) => _SelectionItem(
            e, widget.selectedTags.any((element) => e == element)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("选择歌单分类"),
        actions: [
          TextButton(
            onPressed: () async {
              final selectedTags =
                  _items.where((e) => e.selected).map((e) => e.name).toList();
              Get.back(result: selectedTags);
            },
            child: const Text('保存'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "最多选择3个标签，当前已选择$_selectedCount个",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: _items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.78,
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return GestureDetector(
                  onTap: () {
                    if (!item.selected && _selectedCount >= 3) {
                      return;
                    }
                    setState(() {
                      _items[index].selected = !_items[index].selected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: item.selected ? Colors.red : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(_items[index].name),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionItem {
  bool selected;
  String name;
  _SelectionItem(this.name, this.selected);
}
