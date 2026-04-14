import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/drugs/data/drug_model.dart';
import 'package:flutter_application_military_directory/features/drugs/presentations/screens/drugs_detail_screen.dart';

class DrugCard extends StatelessWidget {
  final DrugModel drug;

  const DrugCard({super.key, required this.drug});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DrugDetailScreen(drug: drug)),
        );
      },

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        child: ListTile(
          title: Text(drug.name),

          subtitle: Text(drug.group),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [const Icon(Icons.chevron_right)],
          ),
        ),
      ),
    );
  }
}
