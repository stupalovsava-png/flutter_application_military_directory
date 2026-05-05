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

  int get _totalPages => widget.med.stages.length;

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

  // ── Определяем человекочитаемый заголовок по типу ─────────────────────────

  String _stageFullTitle(Help help) {
    if (help is FirstDocHelpMpb) {
      return '1-й уровень — Первая врачебная помощь (МПб)';
    } else if (help is FirstDocHelpMedbrig) {
      return '2-й уровень — Первая врачебная помощь (медр бр / ОМедО)';
    } else if (help is QualfDocHelp) {
      return '3-й уровень – квалифицированная врачебная помощь (ОМедБ, МедО СпН)';
    } else if (help is SpecialfDocHelp) {
      return '4-й уровень – специализированная, в том числе высокотехнологичная врачебная помощь (ОВГ)';
    }
    return help.title;
  }

  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 6),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _buildStagePage(widget.med.stages[i]),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ── Шапка ─────────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 16),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Colors.green, size: 22),
                  SizedBox(width: 6),
                  Text(
                    'Назад',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          widget.med.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  // ── Страница одного этапа ─────────────────────────────────────────────────

  Widget _buildStagePage(Help help) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок уровня
          Center(
            child: Text(
              _stageFullTitle(help),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          // Условия оказания помощи
          if (help.place.isNotEmpty)
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
                      help.place,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
            ),

          // Медицинская сортировка
          if (help.sort.isNotEmpty) ...[
            _sectionHeader('Медицинская сортировка'),
            const SizedBox(height: 6),
            Text(help.sort, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),
          ],

          // Мероприятия: итерируем по Map<String, Activities>
          ...help.acivities.entries.map(
            (entry) => _buildActivitiesBlock(
              groupTitle: entry.key,
              activities: entry.value,
            ),
          ),

          // Эвакуация
          if (help.evacuation.isNotEmpty) ...[
            _buildEvacuationBlock(help.evacuation),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  // ── Блок одной группы мероприятий ────────────────────────────────────────

  Widget _buildActivitiesBlock({
    required String groupTitle,
    required Activities activities,
  }) {
    // Определяем заголовок: если ключ пустой — дефолтный
    final title = groupTitle.isNotEmpty ? groupTitle : 'Мероприятия на этапе';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title),
        const SizedBox(height: 8),

        // RichText из данных — рендерим напрямую
        activities.toDoList,

        // Дополнительный текст (additinal)
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

  // ── Блок эвакуации ────────────────────────────────────────────────────────

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

  // ── Заголовок секции ──────────────────────────────────────────────────────

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

  // ── Нижняя навигация ──────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          IconButton(
            onPressed: _currentPage > 0
                ? () => _goToPage(_currentPage - 1)
                : null,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: _currentPage > 0 ? primaryColor : Colors.grey.shade300,
            ),
          ),

          // Точки
          Row(
            children: List.generate(_totalPages, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: active ? primaryColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          IconButton(
            onPressed: _currentPage < _totalPages - 1
                ? () => _goToPage(_currentPage + 1)
                : null,
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: _currentPage < _totalPages - 1
                  ? primaryColor
                  : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
