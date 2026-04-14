import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme/theme.dart';
import 'package:flutter_application_military_directory/features/calculators/data/sacales_data.dart';

// Экран для расчета медицинских шкал
class ScaleCalculatorScreen extends StatefulWidget {
  final Sacels sacale; // Шкала, которую будем рассчитывать

  const ScaleCalculatorScreen({super.key, required this.sacale});

  @override
  State<ScaleCalculatorScreen> createState() => _ScaleCalculatorScreenState();
}

class _ScaleCalculatorScreenState extends State<ScaleCalculatorScreen> {
  // Ключ для управления состоянием формы
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для полей ввода числовых параметров
  final Map<String, TextEditingController> _controllers = {};

  // Хранилище для выбранных значений из выпадающих списков
  final Map<String, SacaleItem?> _selectedItems = {};

  double? _result; // Результат расчета (может быть null пока не вычислен)
  String? _interpretation; // Интерпретация результата

  @override
  void initState() {
    super.initState();
    // Инициализация: создаем контроллеры ввода для каждого требуемого числового параметра
    for (final param in widget.sacale.requiredParameters) {
      _controllers[param] = TextEditingController();
    }
    // Инициализация: устанавливаем начальные значения null для всех компонентов выбора
    for (final component in widget.sacale.components.keys) {
      _selectedItems[component] = null;
    }
  }

  @override
  void dispose() {
    // Важно: освобождаем ресурсы контроллеров при уничтожении виджета
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Функция для парсинга числа с заменой запятой на точку
  double? _parseNumber(String value) {
    if (value.isEmpty) return null;

    // Заменяем запятую на точку и удаляем лишние пробелы
    final normalizedValue = value.replaceAll(',', '.').trim();

    // Парсим число
    return double.tryParse(normalizedValue);
  }

  // Функция для валидации ввода с поддержкой запятых
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите значение';
    }

    // Нормализуем значение (заменяем запятую на точку)
    final normalizedValue = value.replaceAll(',', '.').trim();

    // Проверяем, является ли валидным числом
    final numValue = double.tryParse(normalizedValue);
    if (numValue == null) {
      return 'Введите число';
    }

    if (numValue <= 0) {
      return 'Значение должно быть положительным';
    }

    return null; // Валидация пройдена
  }

  // Основной метод расчета шкалы
  void _calculate() {
    // Проверяем валидность всех полей формы
    if (_formKey.currentState!.validate()) {
      final inputs = <String, double>{}; // Map для числовых входных данных
      final selectedItems =
          <String, SacaleItem>{}; // Map для выбранных элементов

      // Собираем числовые значения из всех полей ввода с обработкой запятых
      for (final param in widget.sacale.requiredParameters) {
        final controller = _controllers[param];
        final text = controller?.text;

        // Проверяем, что контроллер существует и текст не пустой
        if (controller != null && text != null && text.isNotEmpty) {
          final numValue = _parseNumber(text);
          if (numValue != null && numValue > 0) {
            inputs[param] = numValue;
          } else {
            // Обработка ошибки парсинга
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ошибка в поле $param: введите корректное число'),
              ),
            );
            return; // Прерываем расчет
          }
        } else {
          // Обработка пустого поля
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Поле $param не заполнено')));
          return; // Прерываем расчет
        }
      }

      // Собираем выбранные значения из всех выпадающих списков
      for (final component in widget.sacale.components.keys) {
        if (_selectedItems[component] != null) {
          selectedItems[component] = _selectedItems[component]!;
        }
      }
      // Вычисляем результат и обновляем состояние
      setState(() {
        _result = widget.sacale.calculate(
          inputs,
          selectedItems,
        ); // Вызов метода расчета шкалы
        _interpretation = widget.sacale.interpretationResult(
          _result!,
        ); // Интерпретация результата
      });
    }
  }

  // Сброс калькулятора в начальное состояние
  void _resetCalculator() {
    _formKey.currentState?.reset(); // Сброс состояния формы
    setState(() {
      _result = null; // Очистка результата
      _interpretation = null; // Очистка интерпретации
      // Сбрасываем все выбранные значения в выпадающих списках
      for (final key in _selectedItems.keys) {
        _selectedItems[key] = null;
      }
    });
    // Очищаем все поля числового ввода
    for (final controller in _controllers.values) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.sacale.name, style: TextStyle(fontSize: 22)),

        // Название шкалы в заголовке
        actions: [
          // Кнопка сброса в appBar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
            tooltip: 'Сбросить',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Отступы вокруг всего контента
        child: Form(
          key: _formKey, // Привязываем ключ формы
          child: ListView(
            children: [
              // Описание шкалы
              Text(
                widget.sacale.description,
                style: Theme.of(context).textTheme.titleMedium, // Стиль из темы
              ),
              const SizedBox(height: 20), // Отступ
              // Динамически создаваемые числовые поля ввода
              ..._buildInputFields(),

              // Динамически создаваемые поля для выбора из SacaleItem
              ..._buildSelectionFields(),

              const SizedBox(height: 20),
              // Кнопка расчета по центру
              Center(
                child: ElevatedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(color: Colors.white, Icons.calculate),
                  label: Text(
                    'Рассчитать',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(160, 55),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Блок с результатом (показывается только когда есть результат)
              if (_result != null) _buildResultSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Метод для создания числовых полей ввода на основе requiredParameters
  List<Widget> _buildInputFields() {
    return widget.sacale.requiredParameters.map((param) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _controllers[param], // Привязываем контроллер
          decoration: InputDecoration(
            labelText: widget.sacale.getParameterLabel(
              param,
            ), // Закомментировано
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ), // Стиль границы
            suffixText: widget.sacale.getParameterUnits(
              param,
            ), // Единицы измерения/подпись
          ),
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
          ), // Цифровая клавиатура с десятичными числами
          validator:
              _validateInput, // Используем нашу функцию валидации с поддержкой запятых
        ),
      );
    }).toList();
  }

  // Метод для создания полей выбора на основе components
  List<Widget> _buildSelectionFields() {
    return widget.sacale.components.entries.map((entry) {
      final param = entry.key; // Название параметра
      final items = entry.value; // Список доступных вариантов для выбора

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 2, // Тень карточки
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  param,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8), // Отступ
                // Выпадающий список для выбора SacaleItem
                DropdownButtonFormField<SacaleItem>(
                  initialValue: _selectedItems[param],
                  isExpanded: true,
                  hint: const Text('Выберите вариант'),
                  // Создание элементов выпадающего списка
                  items: items.map((item) {
                    return DropdownMenuItem<SacaleItem>(
                      value: item,

                      // Форматирование текста элемента с правильным склонением "баллов"
                      child: Text(
                        '${item.description} - ${item.score} ${switch (item.score) {
                          0 => 'баллов',
                          1 => 'балл',
                          1.5 => 'балла',
                          2 => 'балла',
                          3 => 'балла',
                          4 => 'балла',
                          5 => 'баллов',
                          >= 6 => 'баллов',
                          6.5 => 'баллов',
                          0.85 => 'баллов',
                          _ => '',
                        }}', // Описание элемента
                      ),
                    );
                  }).toList(),
                  // Обработчик изменения выбора
                  onChanged: (value) {
                    setState(() {
                      _selectedItems[param] =
                          value; // Сохраняем выбранное значение
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // Построение секции с результатом расчета
  Widget _buildResultSection() {
    return Container(
      width: double.infinity, // На всю ширину
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(
          (255 * .1).round(),
        ), // Полупрозрачный красный фон
        borderRadius: BorderRadius.circular(12), // Закругленные углы
        border: Border.all(color: Colors.red), // Красная рамка
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Центрирование по горизонтали
        children: [
          // Отображение результата с 2 знаками после запятой
          Text(
            _result!.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          // Интерпретация результата (если есть)
          if (_interpretation != null) ...[
            const SizedBox(height: 12),
            Text(
              _interpretation!,
              textAlign: TextAlign.center, // Центрирование текста
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
