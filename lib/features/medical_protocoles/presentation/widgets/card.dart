import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/data/base_class_protocoles.dart';
import 'package:flutter_svg/svg.dart';

/// Карточка принимает StepCardData + порядковый номер
class StepCard extends StatelessWidget {
  final int number;
  final StepCardData data;
  final VoidCallback? onTap;

  const StepCard({
    Key? key,
    required this.number,
    required this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF1C2A14),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.yellow.shade700, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // выравнивание по верхнему краю для многострочного текста
            children: [
              // Иконка из assets (SVG)
              SvgPicture.asset(
                data.imagePath,
                width: 48,
                height: 48,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.white54,
                  size: 48,
                ),
              ),
              const SizedBox(width: 12),

              // Номер
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade700,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Текстовая часть (заголовок + описание)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title.toUpperCase(),
                      style: TextStyle(
                        color: Colors.yellow.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4, // межстрочный интервал для читаемости
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
