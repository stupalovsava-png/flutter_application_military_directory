import 'package:flutter/material.dart';

import 'package:flutter_application_military_directory/features/medical_help/data/medical_help_data.dart';
import 'package:flutter_application_military_directory/features/medical_help/data/medical_help_model.dart';
import 'package:flutter_application_military_directory/features/medical_help/presentation/widgets/medical_help_card.dart';

class MedicalScreen extends StatefulWidget {
  const MedicalScreen({super.key});

  @override
  State<MedicalScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MedicalHelpModel> _filteredMed = [];

  @override
  void initState() {
    super.initState();
    _filteredMed = List.from(medicalHelpData);
    _searchController.addListener(_filterMed);
  }

  void _filterMed() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMed = List.from(medicalHelpData);
      } else {
        _filteredMed = medicalHelpData.where((med) {
          return med.title.toLowerCase().contains(query);
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
                    'Найдено разделов : ${_filteredMed.length}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filteredMed.isEmpty
                  ? const Center(
                      child: Text(
                        'Ничего не найдено',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredMed.length,
                      itemBuilder: (context, index) {
                        final med = medicalHelpData[index];
                        return MedicalHelpCard(med: med);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
