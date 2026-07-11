import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme/theme.dart';
import 'package:flutter_application_military_directory/features/medical_help/data/medical_help_model.dart';

class StageDetailScreen extends StatelessWidget {
  final String medTitle;
  final Help stage;

  const StageDetailScreen({
    super.key,
    required this.medTitle,
    required this.stage,
  });

  String _stageFullTitle(Help help) {
    if (help is FirstDocHelpMpb) {
      return '1-й уровень — Первая врачебная помощь (МПб)';
    } else if (help is FirstDocHelpMedbrig) {
      return '2-й уровень — Первая врачебная помощь (медбр / ОМедО)';
    } else if (help is QualfDocHelp) {
      return '3-й уровень – квалифицированная врачебная помощь (ОМедБ, МедО СпН)';
    } else if (help is SpecialfDocHelp) {
      return '4-й уровень – специализированная, в том числе высокотехнологичная врачебная помощь (ОВГ)';
    }
    return help.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(medTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок уровня
            Center(
              child: Text(
                _stageFullTitle(stage),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Условия оказания помощи
            if (stage.place.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        stage.place,
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              ),

            // Медицинская сортировка
            if (stage.sort.isNotEmpty) ...[
              _sectionHeader('Медицинская сортировка'),
              const SizedBox(height: 6),
              Text(stage.sort, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 12),
            ],

            // Мероприятия: итерируем по Map<String, Activities>
            ...stage.acivities.entries.map(
              (entry) => _buildActivitiesBlock(
                groupTitle: entry.key,
                activities: entry.value,
              ),
            ),

            // Эвакуация
            if (stage.evacuation.isNotEmpty) ...[
              _buildEvacuationBlock(stage.evacuation),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesBlock({
    required String groupTitle,
    required Activities activities,
  }) {
    final title = groupTitle.isNotEmpty ? groupTitle : 'Мероприятия на этапе';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title),
        const SizedBox(height: 8),
        activities.toDoList,
        if (activities.additinal.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              border: Border.all(color: Colors.orange.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              activities.additinal,
              style: TextStyle(fontSize: 15, color: Colors.orange.shade800),
            ),
          ),
        ],
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildEvacuationBlock(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_hospital_outlined,
                color: Colors.green,
                size: 17,
              ),
              const SizedBox(width: 6),
              Text(
                'Эвакуация',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }
}
