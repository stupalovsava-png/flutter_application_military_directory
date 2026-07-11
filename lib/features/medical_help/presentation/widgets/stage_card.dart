import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/medical_help/data/medical_help_model.dart';

class StageCard extends StatelessWidget {
  final Help stage;
  final VoidCallback onTap;

  const StageCard({super.key, required this.stage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Короткое название для карточки
    String shortTitle = '';
    if (stage is FirstDocHelpMpb) {
      shortTitle = '1-й уровень (МПб)';
    } else if (stage is FirstDocHelpMedbrig) {
      shortTitle = '2-й уровень (медбр / ОМедО)';
    } else if (stage is QualfDocHelp) {
      shortTitle = '3-й уровень (ОМедБ, МедО СпН)';
    } else if (stage is SpecialfDocHelp) {
      shortTitle = '4-й уровень (ОВГ)';
    } else {
      shortTitle = stage.title;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              shortTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              stage.place.isNotEmpty ? stage.place : 'Место не указано',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
