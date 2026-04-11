import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/calculators/data/formulae_repository.dart';
import 'package:flutter_application_military_directory/features/calculators/data/formules_data.dart';
import 'package:flutter_application_military_directory/features/calculators/data/sacales_data.dart';
import 'package:flutter_application_military_directory/features/calculators/data/scales_data.dart';
import 'package:flutter_application_military_directory/features/calculators/presentation/calculator_scales_screen.dart';
import 'package:flutter_application_military_directory/features/calculators/presentation/formula_calculator_screen.dart';
import 'package:flutter_application_military_directory/features/calculators/presentation/formula_card.dart';
import 'package:flutter_application_military_directory/features/calculators/presentation/sacles_calculator_screen.dart';

class FormulaeScreen extends StatefulWidget {
  const FormulaeScreen({super.key});

  @override
  State<FormulaeScreen> createState() => _FormulaeScreenState();
}

class _FormulaeScreenState extends State<FormulaeScreen> {
  late final FormulaRepository repository = FormulaRepository();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCalculation(BuildContext context, dynamic calculation) {
    if (calculation is MedicalFormules) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormulaCalculatorScreen(formula: calculation),
        ),
      );
    } else if (calculation is MedicalScale) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicalScaleScreen(scale: calculation),
        ),
      );
    } else if (calculation is Sacels) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScaleCalculatorScreen(sacale: calculation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCalculations = repository.allCalculation;
    var filteredCalculations = allCalculations;

    if (_searchController.text.isNotEmpty) {
      final searchText = _searchController.text.toLowerCase();
      filteredCalculations = filteredCalculations.where((calculation) {
        return calculation.name.toLowerCase().contains(searchText) ||
            calculation.description.toLowerCase().contains(searchText);
      }).toList();
    }

    return SafeArea(
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
          // ИНФОРМАЦИЯ О КОЛИЧЕСТВЕ НАЙДЕННЫХ АЛГОРИТМОВ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Найдено формул и шкал: ${filteredCalculations.length}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),
          Expanded(
            child: filteredCalculations.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredCalculations.length,
                    itemBuilder: (context, index) {
                      final calculation = filteredCalculations[index];
                      return FormulaCard(
                        key: Key(
                          'formula-${calculation.hashCode}',
                        ), // Важно добавить ключ
                        calculation: calculation,
                        onTap: () =>
                            _navigateToCalculation(context, calculation),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Ничего не найдено',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте другой поисковый запрос',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
