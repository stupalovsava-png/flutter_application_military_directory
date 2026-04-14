import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/chek_lists/data/check_list_model.dart';
import 'package:flutter_application_military_directory/features/chek_lists/data/chek_list_data.dart';
import 'package:flutter_application_military_directory/features/chek_lists/presentation/widgets/check_lists_card.dart';

class CheckLists extends StatefulWidget {
  const CheckLists({super.key});

  @override
  State<CheckLists> createState() => _CheckListsState();
}

class _CheckListsState extends State<CheckLists> {
  final TextEditingController _searchController = TextEditingController();
  List<CheckListModel> _filteredChek = [];
  @override
  void initState() {
    super.initState();
    _filteredChek = List.from(checkLists);
    _searchController.addListener(_filterChek);
  }

  void _filterChek() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredChek = List.from(checkLists);
      } else {
        _filteredChek = checkLists.where((chek) {
          return chek.title.toLowerCase().contains(query) ||
              chek.category.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hoverColor: Colors.grey,
                  focusColor: Colors.grey,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'Поиск по названию',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Найдено чек-листов : ${_filteredChek.length}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filteredChek.isEmpty
                  ? const Center(
                      child: Text(
                        'Ничего не найдено',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredChek.length,
                      itemBuilder: (context, index) {
                        final check = checkLists[index];
                        return CheckListsCard(check: check);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
