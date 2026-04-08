import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/drugs/data/drug_model.dart';

class DrugDetailScreen extends StatelessWidget {
  final DrugModel drug;

  const DrugDetailScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Кнопка "Назад к списку"
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.green, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Назад к списку',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drug.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          drug.latinName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  drug.group,
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 28),
              // Форма выпуска
              _buildSectionTitle('Способ действия'),
              Text(drug.description, style: const TextStyle(fontSize: 16)),

              // Форма выпуска
              _buildSectionTitle('Форма выпуска'),
              Text(drug.form, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 24),

              // Показания
              _buildSectionTitle('Показания'),
              Text(
                drug.indications,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),

              const SizedBox(height: 24),

              // Дозировка и применение
              // _buildSectionTitle('Дозировка и применение'),
              // Text(
              //   drug.dosage,
              //   style: const TextStyle(fontSize: 16, height: 1.5),
              // ),
              const SizedBox(height: 24),

              // Противопоказания (в жёлтой плашке, как на скриншоте)
              _buildWarningSection(
                title: 'Противопоказания',
                content: drug.contraindications,
              ),
              const SizedBox(height: 12),
              _buildSectionTitle('С осторожностью'),
              Text(
                drug.caution,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),

              const SizedBox(height: 24),

              // Побочные эффекты
              _buildSectionTitle('Побочные эффекты'),
              Text(
                drug.sideEffects,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              _buildSectionTitle('Подробности'),
              Text(
                drug.additionial,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Вспомогательный виджет для заголовков разделов
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Жёлтая плашка для противопоказаний
  Widget _buildWarningSection({
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow.shade700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 230, 81, 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 230, 81, 0),
            ),
          ),
        ],
      ),
    );
  }
}
