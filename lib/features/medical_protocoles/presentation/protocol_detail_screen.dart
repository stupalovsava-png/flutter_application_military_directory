import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/data/base_class_protocoles.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/presentation/widgets/card.dart';

class ProtocolScreen extends StatelessWidget {
  final MedicalProtocol protocol;

  const ProtocolScreen({Key? key, required this.protocol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A09),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2A14),
        title: Text(
          protocol.screenTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          if (protocol.screenSubtitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                protocol.screenSubtitle!,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ),

          // Карточки строятся из списка — чистый конструктор
          ...protocol.cards.asMap().entries.map(
            (entry) => StepCard(
              number: entry.key + 1,
              data: entry.value,
              onTap: () {
                // навигация на детальный экран
              },
            ),
          ),
        ],
      ),
    );
  }
}
