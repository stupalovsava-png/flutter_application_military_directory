import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/anylysis/data/analysis_model.dart';

class AnalysisCard extends StatelessWidget {
  final AnalysisModel analis;
  const AnalysisCard({super.key, required this.analis});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      child: ExpansionTile(
        shape: Border(),
        title: Text(
          analis.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(analis.description),
                const SizedBox(height: 12),
                // Здесь можно добавить кнопки, изображения, любой контент
              ],
            ),
          ),
        ],
      ),
    );
  }
}
