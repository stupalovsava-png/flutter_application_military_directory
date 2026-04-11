import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/calculators/data/scales_data.dart';

class MedicalScaleScreen extends StatefulWidget {
  final MedicalScale scale;

  const MedicalScaleScreen({super.key, required this.scale});

  @override
  State<MedicalScaleScreen> createState() => _MedicalScaleScreenState();
}

class _MedicalScaleScreenState extends State<MedicalScaleScreen> {
  final Map<String, ScaleItem?> _selectedItems = {};
  num _totalScore = 0;
  String _interpretation = '';

  @override
  void initState() {
    super.initState();
    // Инициализируем пустые значения для всех компонентов шкалы
    for (final component in widget.scale.components.keys) {
      _selectedItems[component] = null;
    }
  }

  void _calculateScore() {
    num total = 0;
    for (final item in _selectedItems.values) {
      if (item != null) {
        total += item.score;
      }
    }

    setState(() {
      _totalScore = total;
      _interpretation = widget.scale.interpretationResult(total);
    });
  }

  void _resetScale() {
    setState(() {
      for (final component in widget.scale.components.keys) {
        _selectedItems[component] = null;
      }
      _totalScore = 0;
      _interpretation = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 107, 189, 0.9),
        centerTitle: true,
        title: Text(
          widget.scale.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // Название шкалы в заголовке
        actions: [
          // Кнопка сброса в appBar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetScale,
            tooltip: 'Сбросить',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Описание шкалы
            Text(
              widget.scale.description,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Компоненты шкалы
            Expanded(
              child: ListView(
                children: widget.scale.components.entries.map((entry) {
                  return _buildScaleComponent(entry.key, entry.value);
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Кнопка расчета и результаты
            _buildResultSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleComponent(String componentName, List<ScaleItem> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              componentName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            DropdownButton<ScaleItem>(
              value: _selectedItems[componentName],
              isExpanded: true,
              hint: const Text('Выберите вариант'),
              items: items.map((item) {
                return DropdownMenuItem<ScaleItem>(
                  value: item,
                  child: Text(
                    '${item.description} - ${item.score} ${switch (item.score) {
                      0 => 'баллов',
                      1 => 'балл',
                      1.5 => 'балла',
                      2 => 'балла',
                      3 => 'балла',
                      4 => 'балла',
                      5 => 'баллов',
                      >= 6 => 'баллов',
                      int() => throw UnimplementedError(),
                      double() => throw UnimplementedError(),
                    }}  ',
                  ),
                );
              }).toList(),
              onChanged: (ScaleItem? value) {
                setState(() {
                  _selectedItems[componentName] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Column(
      children: [
        Center(
          child: ElevatedButton.icon(
            onPressed: _calculateScore,
            icon: const Icon(color: Colors.white, Icons.calculate),
            label: Text(
              'Рассчитать',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(42, 107, 189, 0.9),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              fixedSize: Size(160, 55),
            ),
          ),
        ),
        const SizedBox(height: 20),

        if (_totalScore > 0) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha((255 * .1).round()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
            child: Column(
              children: [
                Text(
                  'Общий балл: $_totalScore',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _interpretation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ] else if (_areAllComponentsSelected()) ...[
          const Text(
            'Все компоненты выбраны. Нажмите "Рассчитать"',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ],
    );
  }

  bool _areAllComponentsSelected() {
    return _selectedItems.values.every((item) => item != null);
  }
}
