import 'package:flutter/material.dart';

import 'package:flutter_application_military_directory/features/medical_help/data/medical_help_model.dart';
import 'package:flutter_application_military_directory/features/medical_help/presentation/screens/medical_help_detail_screen.dart'
    hide Widget;

class MedicalHelpCard extends StatelessWidget {
  final MedicalHelpModel med;

  const MedicalHelpCard({super.key, required this.med});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalHelpDetailScreen(med: med),
          ),
        );
      },

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        child: ListTile(
          title: Text(med.title),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [const Icon(Icons.chevron_right)],
          ),
        ),
      ),
    );
  }
}
