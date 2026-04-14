import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/drugs/data/drug_model.dart';
import 'package:flutter_application_military_directory/features/drugs/data/drugs_data.dart';
import 'package:flutter_application_military_directory/features/drugs/presentations/widgets/drug_card.dart';

class DrugScreen extends StatefulWidget {
  const DrugScreen({super.key});

  @override
  State<DrugScreen> createState() => _DrugScreenState();
}

class _DrugScreenState extends State<DrugScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DrugModel> _filteredDrugs = [];

  @override
  void initState() {
    super.initState();
    _filteredDrugs = List.from(drugList);
    _searchController.addListener(_filterDrugs);
  }

  void _filterDrugs() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDrugs = List.from(drugList);
      } else {
        _filteredDrugs = drugList.where((drug) {
          return drug.name.toLowerCase().contains(query) ||
              drug.latinName.toLowerCase().contains(query);
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
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                cursorColor: Colors.grey,

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
                    'Найдено препаратов : ${_filteredDrugs.length}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filteredDrugs.isEmpty
                  ? const Center(
                      child: Text(
                        'Ничего не найдено',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredDrugs.length,
                      itemBuilder: (context, index) {
                        final drug = drugList[index];
                        return DrugCard(drug: drug);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
