import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/data/base_class_protocoles.dart';

class ProtocolListItem extends StatelessWidget {
  final MedicalProtocol protocol;
  final VoidCallback? onTap;

  const ProtocolListItem({Key? key, required this.protocol, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF1C2A14),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.yellow.shade700, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Иконка-заглушка (можно заменить на иконку протокола)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade700.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: Colors.yellow.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      protocol.screenTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (protocol.screenSubtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        protocol.screenSubtitle!,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '${protocol.cards.length} шагов',
                      style: TextStyle(
                        color: Colors.yellow.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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
