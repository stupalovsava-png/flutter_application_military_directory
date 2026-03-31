import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/data/drugs/drug_model.dart';
import 'package:flutter_application_military_directory/presentation/drugs/drugs_detail_screen.dart';

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
      child: SizedBox(
        height: 110,
        child: Card(
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        drug.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        drug.latinName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.red.shade100,
                        ),
                        child: Text(
                          drug.group,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 118, 14, 7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
