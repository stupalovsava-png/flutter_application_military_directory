import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/anylysis/data/analysis_data.dart';
import 'package:flutter_application_military_directory/features/anylysis/data/analysis_model.dart';
import 'package:flutter_application_military_directory/features/anylysis/presentation/analysis_card.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final controller = TextEditingController();
  List<AnalysisModel> _analysis = [];
  final Set<AnalysisCategory> _selectedCategories = {};

  static const Map<AnalysisCategory, String> _categoryLabels = {
    AnalysisCategory.urine: 'Моча',
    AnalysisCategory.biochemicalBlood: 'Биохимия крови',
    AnalysisCategory.bloodGas: 'Газы крови',
    AnalysisCategory.hormones: 'Гормоны',
    AnalysisCategory.immunology: 'Иммунология',
    AnalysisCategory.clinicalBlood: 'Клин. кровь',
    AnalysisCategory.coagulogram: 'Коагулограмма',
    AnalysisCategory.coprogram: 'Копрограмма',
  };

  @override
  void initState() {
    super.initState();
    _analysis = List.from(analysisList)
      ..sort((a, b) => a.title.compareTo(b.title));
    controller.addListener(_filter);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _filter() {
    final query = controller.text.trim().toLowerCase();
    setState(() {
      _analysis = analysisList.where((a) {
        final matchesQuery =
            query.isEmpty || a.title.toLowerCase().contains(query);
        final matchesCategory =
            _selectedCategories.isEmpty ||
            _selectedCategories.contains(a.category);
        return matchesQuery && matchesCategory;
      }).toList()..sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void _toggleCategory(AnalysisCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _filter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hoverColor: Colors.grey,
                focusColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintText: 'Поиск по названию',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Чекбоксы категорий
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _categoryLabels.entries.map((entry) {
                final isSelected = _selectedCategories.contains(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (_) => _toggleCategory(entry.key),
                    selectedColor: Colors.blue.withOpacity(0.2),
                    checkmarkColor: Colors.blue,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.blue : Colors.grey[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Найдено анализов: ${_analysis.length}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),

          Expanded(
            child: _analysis.isEmpty
                ? const Center(
                    child: Text(
                      'Ничего не найдено',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _analysis.length,
                    itemBuilder: (context, index) {
                      final analysis = _analysis[index]; // исправлен баг
                      return AnalysisCard(
                        analis: analysis,
                        key: ValueKey(analysis.id),
                        controller: TextEditingController(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
