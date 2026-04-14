import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme/theme.dart';
import 'package:flutter_application_military_directory/features/anylysis/data/analysis_model.dart';

class AnalysisCard extends StatefulWidget {
  final AnalysisModel analis;
  final TextEditingController controller;

  const AnalysisCard({
    super.key,
    required this.analis,
    required this.controller,
  });

  @override
  State<AnalysisCard> createState() => _AnalysisCardState();
}

class _AnalysisCardState extends State<AnalysisCard> {
  String? selectedUnit;

  @override
  void initState() {
    super.initState();
    selectedUnit =
        widget.analis.standartUnit.name; // начинаем со стандартной единицы
  }

  void _calculate() {
    final String input = widget.controller.text.trim();

    if (input.isEmpty) {
      _showSnackBar('Введите значение!', Colors.red);
      return;
    }

    final double? value = double.tryParse(input);
    if (value == null) {
      _showSnackBar('Некорректное число!', Colors.red);
      return;
    }

    // Находим выбранную единицу измерения
    final currentUnit = widget.analis.units.firstWhere(
      (unit) => unit.name == selectedUnit,
      orElse: () => widget.analis.standartUnit,
    );

    String message;
    Color color;

    if (value < currentUnit.min) {
      message = 'Ниже нормы (минимум: ${currentUnit.min} ${currentUnit.name})';
      color = Colors.orange;
    } else if (value > currentUnit.max) {
      message = 'Выше нормы (максимум: ${currentUnit.max} ${currentUnit.name})';
      color = Colors.red;
    } else {
      message = 'В пределах нормы ✓';
      color = Colors.green;
    }

    _showSnackBar(message, color);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      child: ExpansionTile(
        shape: Border(),
        title: Text(
          widget.analis.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Поле для ввода значения
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: widget.controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Значение',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Выбор единицы
                    Expanded(flex: 1, child: unitSection(widget.analis)),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: InkWell(
                    onTap: _calculate,
                    child: Container(
                      width: 160,
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Посчитать',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Dropdown выбора единицы ====================
  Widget unitSection(AnalysisModel analis) {
    return DropdownButtonFormField<String>(
      value: selectedUnit,
      isExpanded: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
      items: analis.units
          .map(
            (UnitModel unit) => DropdownMenuItem<String>(
              value: unit.name,
              child: Text(unit.name),
            ),
          )
          .toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedUnit = newValue;
          });
        }
      },
    );
  }
}
