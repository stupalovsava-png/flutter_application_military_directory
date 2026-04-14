import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme/theme.dart';
import 'package:flutter_application_military_directory/features/calculators/data/formules_data.dart';

// Экран для расчета медицинских формул
class FormulaCalculatorScreen extends StatefulWidget {
  final MedicalFormules formula; // Формула, которую будем рассчитывать

  const FormulaCalculatorScreen({
    super.key, // Ключ виджета (обязательный параметр)
    required this.formula,
    // Обязательная формула для расчета
  });

  @override
  State<FormulaCalculatorScreen> createState() =>
      _FormulaCalculatorScreenState();
}

class _FormulaCalculatorScreenState extends State<FormulaCalculatorScreen> {
  // Ключ для управления состоянием формы
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для полей ввода (динамически создаются для каждого параметра формулы)
  final Map<String, TextEditingController> _controllers = {};

  double? _result;
  String? _interpretation; // Интерпретация результата

  @override
  void initState() {
    super.initState();
    // Инициализация: создаем контроллеры ввода для каждого требуемого параметра формулы
    for (final param in widget.formula.requiredParameters) {
      _controllers[param] = TextEditingController();
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

  // Функция для валидации ввода
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите значение';
    }

    // Нормализуем значение (заменяем запятую на точку)
    final normalizedValue = value.replaceAll(',', '.').trim();

    // Проверяем, является ли валидным числом
    final numValue = double.tryParse(normalizedValue);
    if (numValue == null) {
      return 'Введите корректное число';
    }

    // Проверяем на положительное значение (если требуется)
    if (numValue <= 0) {
      return 'Значение должно быть положительным';
    }

    return null; // Валидация пройдена
  }

  // Основной метод расчета
  void _calculate() {
    // Проверяем валидность всех полей формы
    if (_formKey.currentState!.validate()) {
      final inputs = <String, double>{}; // Map для входных данных

      // Собираем значения из всех полей ввода с обработкой запятых
      for (final param in widget.formula.requiredParameters) {
        final textValue = _controllers[param]!.text;
        final parsedValue = _parseNumber(textValue);

        if (parsedValue != null) {
          inputs[param] = parsedValue;
        }
      }

      // Сворачивание клавиатуры
      FocusScope.of(context).unfocus();

      // Вычисляем результат и обновляем состояние
      setState(() {
        _result = widget.formula.calculate(
          inputs,
        ); // Вызов метода расчета формулы
        _interpretation = widget.formula.interpretationResult(
          _result!,
        ); // Интерпретация
      });
    }
  }

  // Сброс калькулятора
  void _resetCalculator() {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.reset(); // Сброс состояния формы
    setState(() {
      _result = null; // Очистка результата
      _interpretation = null; // Очистка интерпретации
    });

    // Очищаем все поля ввода
    for (final controller in _controllers.values) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.formula.name, style: TextStyle(fontSize: 20)),
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
        // Отступы вокруг всего контента
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Штука чтобы кнопки корректно отображались
          child: Form(
            key: _formKey, // Привязываем ключ формы
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Выравнивание по левому краю
              children: [
                // Описание формулы
                Text(
                  widget.formula.description,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium, // Стиль из темы
                ),

                const SizedBox(height: 16),

                // Динамически создаваемые поля ввода
                ..._buildInputFields(), // Spread оператор для добавления всех полей

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
      ),
    );
  }

  // Метод для создания полей ввода на основе требуемых параметров формулы
  List<Widget> _buildInputFields() {
    return widget.formula.requiredParameters.map((param) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _controllers[param], // Привязываем контроллер
          decoration: InputDecoration(
            labelText: widget.formula.getParameterLabel(
              param,
            ), // Лейбл с понятным названием
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ), // Стиль границы
            suffixText: widget.formula.getParameterUnits(
              param,
            ), // Единицы измерения
          ),
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
          ), // Цифровая клавиатура с десятичной точкой
          // Автоматически заменяем запятую на точку при вводе
          onChanged: (value) {
            // Если пользователь ввел запятую, заменяем ее на точку
            if (value.contains(',') && !value.contains('.')) {
              final newValue = value.replaceAll(',', '.');
              _controllers[param]!.value = TextEditingValue(
                text: newValue,
                selection: TextSelection.collapsed(offset: newValue.length),
              );
            }
          },
          validator: _validateInput, // Используем нашу функцию валидации
        ),
      );
    }).toList();
  }

  // Построение секции с результатом
  Widget _buildResultSection() {
    return Container(
      width: double.infinity, // На всю ширину
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha((255 * .1).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Центрирование по горизонтали
        children: [
          // Интерпретация результата (если есть)
          if (_interpretation != null) ...[
            const SizedBox(height: 12),
            Text(
              _interpretation!,
              textAlign: TextAlign.center, // Центрирование текста
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
