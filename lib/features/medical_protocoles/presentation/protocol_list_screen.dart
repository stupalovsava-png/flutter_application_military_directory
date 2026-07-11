import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/data/base_class_protocoles.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/data/medical_protocoles_data.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/presentation/protocol_detail_screen.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/presentation/widgets/protocol_list_item.dart';

class ProtocolListScreen extends StatefulWidget {
  const ProtocolListScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolListScreen> createState() => _ProtocolListScreenState();
}

class _ProtocolListScreenState extends State<ProtocolListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MedicalProtocol> _filteredProtocols = [];

  @override
  void initState() {
    super.initState();
    _filteredProtocols = List.from(protocolsData);
    _searchController.addListener(_filterProtocols);
  }

  void _filterProtocols() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProtocols = List.from(protocolsData);
      } else {
        _filteredProtocols = protocolsData.where((p) {
          return p.screenTitle.toLowerCase().contains(query) ||
              (p.screenSubtitle?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A09),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск по протоколам',
                  prefixIcon: const Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: const Color(0xFF1C2A14),
                  filled: true,
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Найдено протоколов: ${_filteredProtocols.length}',
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filteredProtocols.isEmpty
                  ? const Center(
                      child: Text(
                        'Ничего не найдено',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredProtocols.length,
                      itemBuilder: (context, index) {
                        final protocol = _filteredProtocols[index];
                        return ProtocolListItem(
                          protocol: protocol,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProtocolScreen(protocol: protocol),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
