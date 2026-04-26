import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme/theme.dart';
import 'package:flutter_application_military_directory/features/medical_help/data/medical_help_model.dart';

class MedicalHelpDetailScreen extends StatefulWidget {
  final MedicalHelpModel med;

  const MedicalHelpDetailScreen({super.key, required this.med});

  @override
  State<MedicalHelpDetailScreen> createState() =>
      _MedicalHelpDetailScreenState();
}

class _MedicalHelpDetailScreenState extends State<MedicalHelpDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _stageLabels = [
    'Первая врачебная',
    'Квалифицированная',
    'Специализированная',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Кнопка "Назад к списку"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
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
            ),

            // Заголовок
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.med.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // PageView с этапами
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildStagePage(
                    stageTitle: 'Первая врачебная помощь',
                    help: widget.med.firstDocHelp,
                  ),
                  _buildStagePage(
                    stageTitle: 'Квалифицированная медицинская помощь',
                    help: widget.med.qualfDocHelp,
                  ),
                  _buildStagePage(
                    stageTitle: 'Специализированная медицинская помощь',
                    help: widget.med.specialDocHelp,
                  ),
                ],
              ),
            ),

            // Нижняя навигация
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildStagePage({required String stageTitle, required dynamic help}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок этапа
          Center(
            child: Text(
              stageTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          // Место оказания помощи
          Text(
            help.place,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),

          const SizedBox(height: 12),
          _buildSection(title: 'Медицинская сортировка', text: help.sort),

          // Мероприятия на этапе
          _buildSection(
            title: help.acivities.title.isNotEmpty
                ? help.acivities.title
                : 'Мероприятия на этапе',
            text: help.acivities.toDoList,
            add: help.acivities.additinal.isNotEmpty
                ? help.acivities.additinal
                : null,
          ),

          if (help.evacuation.isNotEmpty)
            _buildSection(title: 'Эвакуация', text: help.evacuation),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String text,
    String? add,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            color: primaryColor,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(fontSize: 16)),
          if (add != null && add.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              add,
              style: const TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Стрелка назад
          IconButton(
            onPressed: _currentPage > 0
                ? () => _goToPage(_currentPage - 1)
                : null,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: _currentPage > 0 ? primaryColor : Colors.grey.shade300,
            ),
          ),

          // Индикаторы страниц
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? primaryColor : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                _stageLabels[_currentPage],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Стрелка вперёд
          IconButton(
            onPressed: _currentPage < 2
                ? () => _goToPage(_currentPage + 1)
                : null,
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: _currentPage < 2 ? primaryColor : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
