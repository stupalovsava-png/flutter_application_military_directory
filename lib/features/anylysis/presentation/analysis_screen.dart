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

  @override
  void initState() {
    super.initState();
    _analysis = List.from(analysisList);
    controller.addListener(_filterAnalysis);
  }

  void _filterAnalysis() {
    final query = controller.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _analysis = List.from(analysisList);
      } else {
        _analysis = analysisList.where((analysis) {
          return analysis.title.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Референсные значения анализов'),
          Padding(
            padding: EdgeInsetsGeometry.all(12),
            child: TextField(
              controller: controller,
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
                      final analysis = analysisList[index];
                      return AnalysisCard(
                        analis: analysisList[index],
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
