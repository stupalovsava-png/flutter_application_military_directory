import "dart:math";

//Файл для шкал

abstract class MedicalScale {
  //Абстрактный класс мед шкал
  String get name;
  String get description;
  Map<String, List<ScaleItem>> get components;
  String interpretationResult(num totalScore);
}

class ScaleItem {
  //Подкласс Шкальных значений
  final String description;
  final num score;
  const ScaleItem({required this.description, required this.score});
  //Перегрузка оператора для сравнений
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScaleItem &&
        other.description == description &&
        other.score == score;
  }

  // Переопределяем hashCode
  @override
  int get hashCode => description.hashCode ^ score.hashCode;

  // Для удобства отладки
  @override
  String toString() {
    return 'ScaleItem(description: $description, score: $score)';
  }
}

//ШКАЛА КОМЫ ГЛАЗГО
class GlasgowComaScale implements MedicalScale {
  @override
  String get name => 'Шкала комы Глазго';
  @override
  String get description => "(Glazgow coma scale) Оценка уровня сознания";

  @override
  Map<String, List<ScaleItem>> get components => {
    'Открывание глаз': [
      ScaleItem(description: 'Спонтанное', score: 4),
      ScaleItem(description: 'На обращенную речь', score: 3),
      ScaleItem(description: 'На болевое раздражение', score: 2),
      ScaleItem(description: 'Отсутствует', score: 1),
    ],
    'Речевая реакция': [
      ScaleItem(description: 'Ориентированная', score: 5),
      ScaleItem(description: 'Спутанная речь', score: 4),
      ScaleItem(description: 'Непонятные слова', score: 3),
      ScaleItem(description: 'Нечленораздельные звуки', score: 2),
      ScaleItem(description: 'Отсутствует', score: 1),
    ],
    'Двигательная реакция': [
      ScaleItem(description: 'Выполняет команды', score: 6),
      ScaleItem(description: 'Локализует боль', score: 5),
      ScaleItem(description: 'Отдергивание конечности', score: 4),
      ScaleItem(description: 'Патологическое сгибание', score: 3),
      ScaleItem(description: 'Патологическое разгибание', score: 2),
      ScaleItem(description: 'Отсутствует', score: 1),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    switch (totalScore) {
      case 15:
        return '$totalScore баллов - Ясное сознание';
      case 14:
        return '$totalScore баллов - Незначительное нарушение сознания';
      case 13:
      case 12:
        return '$totalScore баллов - Умеренное нарушение сознания';
      case 11:
      case 10:
      case 9:
        return '$totalScore баллов - Сопор';
      case 8:
      case 7:
        return '$totalScore баллов - Кома I-II степени';
      case 6:
      case 5:
        return '$totalScore баллов - Кома III-IV степени';
      case 4:
      case 3:
        return '$totalScore балла - Кома III-IV степени';
      default:
        return '$totalScore баллов - Критическое состояние';
    }
  }
}

//Шкала Quick SOFA
class QSofaScale extends MedicalScale {
  @override
  String get name => "Шкала qSofa";

  @override
  String get description => "(кСОФА) Быстрая шкала оценки сепсиса";

  @override
  Map<String, List<ScaleItem>> get components => {
    'Частота дыхания': [
      ScaleItem(description: 'ЧД < 22/мин', score: 0),
      ScaleItem(description: 'ЧД ≥ 22/мин', score: 1),
    ],
    'Систолическое АД': [
      ScaleItem(description: 'САД > 100 мм рт.ст.', score: 0),
      ScaleItem(description: 'САД ≤ 100 мм рт.ст.', score: 1),
    ],
    'Психический статус': [
      ScaleItem(description: 'Нормальный', score: 0),
      ScaleItem(description: 'Изменён (дезориентация, сонливость)', score: 1),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      0 =>
        """Низкий риск сепсиса \n•маловероятно наличие органной дисфункции 
      \n•(0 баллов)""",
      1 =>
        "Умеренный риск сепсиса: \n•Рекомендуется наблюдение и повторная оценка",
      2 =>
        "Высокий риск сепсиса: \n•Высокая вероятность сепсиса. \n•Требуется срочное обследование",
      3 =>
        "Очень высокий риск сепсиса: \n•Критическое состояние. \n•Необходима немедленная госпитализация",
      _ => """Неопределённый риск ($totalScore баллов)""",
    };
  }
}

//Шкала Софа
class SofaScale implements MedicalScale {
  @override
  String get name => "Шкала СОФА";
  @override
  String get description =>
      "(SOFA scale)Оценка органной дисфункции при сепсисе";
  @override
  Map<String, List<ScaleItem>> get components => {
    'Дыхательная система (PaO2/FiO2)': [
      ScaleItem(description: '≥400 мм рт.ст.', score: 0),
      ScaleItem(description: '<400 мм рт.ст.', score: 1),
      ScaleItem(description: '<300 мм рт.ст.', score: 2),
      ScaleItem(description: '<200 мм рт.ст. с ИВЛ', score: 3),
      ScaleItem(description: '<100 мм рт.ст. с ИВЛ', score: 4),
    ],
    'Нервная система (Шкала Глазго)': [
      ScaleItem(description: '15', score: 0),
      ScaleItem(description: '13-14', score: 1),
      ScaleItem(description: '10-12', score: 2),
      ScaleItem(description: '6-9', score: 3),
      ScaleItem(description: '<6', score: 4),
    ],

    'Сердечно-сосудистая система': [
      ScaleItem(description: 'АД в норме', score: 0),
      ScaleItem(description: 'Среднее АД <70 мм рт.ст.', score: 1),
      ScaleItem(
        description: 'Дофамин ≤5 мкг/кг/мин или добутамин (любая доза)',
        score: 2,
      ),
      ScaleItem(
        description: 'Дофамин >5 мкг/кг/мин или адреналин ≤0.1 мкг/кг/мин',
        score: 3,
      ),
      ScaleItem(
        description: 'Дофамин >15 мкг/кг/мин или адреналин >0.1 мкг/кг/мин',
        score: 4,
      ),
    ],

    'Печень (Билирубин, мг/дл)': [
      ScaleItem(description: '<1.2 мг/дл (20 мкмоль/л)', score: 0),
      ScaleItem(description: '1.2-1.9 мг/дл (20-32 мкмоль/л)', score: 1),
      ScaleItem(description: '2.0-5.9 мг/дл (33-101 мкмоль/л)', score: 2),
      ScaleItem(description: '6.0-11.9 мг/дл (102-204 мкмоль/л)', score: 3),
      ScaleItem(description: '>12.0 мг/дл (204 мкмоль/л)', score: 4),
    ],

    'Коагуляция (Тромбоциты, ×10³/мм³)': [
      ScaleItem(description: '≥150', score: 0),
      ScaleItem(description: '<150', score: 1),
      ScaleItem(description: '<100', score: 2),
      ScaleItem(description: '<50', score: 3),
      ScaleItem(description: '<20', score: 4),
    ],

    'Почки (Креатинин, мг/дл)': [
      ScaleItem(description: '<1.2 мг/дл (110 мкмоль/л)', score: 0),
      ScaleItem(description: '1.2-1.9 мг/дл (110-170 мкмоль/л)', score: 1),
      ScaleItem(description: '2.0-3.4 мг/дл (171-299 мкмоль/л)', score: 2),
      ScaleItem(description: '3.5-4.9 мг/дл (300-440 мкмоль/л)', score: 3),
      ScaleItem(description: '>5.0 мг/дл (440 мкмоль/л)', score: 4),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    switch (totalScore) {
      case 0:
        return '•Норма. \n•Органная дисфункция отсутствует';

      case 1:
      case 2:
        return '•Легкая органная дисфункция. '
            '\n•Риск развития сепсиса. \n•Требуется наблюдение';

      case 3:
      case 4:
        return '•Умеренная органная дисфункция. '
            '\n•Высокий риск сепсиса. \n•Необходимо интенсивное наблюдение';

      case 5:
      case 6:
        return '•Тяжелая органная дисфункция. '
            '\n•Вероятен сепсис. \n•Требуется лечение в условиях ОРИТ';

      case 7:
      case 8:
        return '•Выраженная полиорганная недостаточность. '
            '\n•Септический шок. \n•Срочная госпитализация в ОРИТ';

      case 9:
      case 10:
        return '•Критическая полиорганная недостаточность. '
            '\n•Высокий риск летального исхода. \n•Реанимационные мероприятия';

      default:
        if (totalScore > 10) {
          return '•Крайне критическое состояние. '
              '\n•Прогноз неблагоприятный. \n•Максимальная интенсивная терапия';
        }
        return 'Недостаточно данных для оценки';
    }
  }
}

//Шкала Pews
class PewsScale implements MedicalScale {
  @override
  String get name => 'Шкала PEWS';

  @override
  String get description => 'Педиатрическая шкала раннего предупреждения';

  @override
  Map<String, List<ScaleItem>> get components => {
    'Сознание': [
      ScaleItem(description: 'В норме', score: 0),
      ScaleItem(description: 'Раздражительность', score: 1),
      ScaleItem(description: 'Вялость', score: 2),
      ScaleItem(description: 'Кома', score: 3),
    ],
    'Частота сердечных сокращений': [
      ScaleItem(description: 'В норме для возраста', score: 0),
      ScaleItem(description: 'Тахикардия +10-20%', score: 1),
      ScaleItem(description: 'Тахикардия +20-30%', score: 2),
      ScaleItem(description: 'Тахикардия >30% или брадикардия', score: 3),
    ],
    'Артериальное давление': [
      ScaleItem(description: 'В норме', score: 0),
      ScaleItem(description: '±10-20% от нормы', score: 1),
      ScaleItem(description: '±20-30% от нормы', score: 2),
      ScaleItem(description: '>±30% от нормы', score: 3),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    switch (totalScore) {
      case 0:
        return '•Стабильное состояние';
      case 1:
        return '•Наблюдение каждые 4 часа';
      case 2:
        return '•Наблюдение каждые 2 часа';
      case 3:
      case 4:
        return '•Наблюдение каждый час';
      case 5:
      case 6:
        return '•Срочный вызов врача';
      case 7:
      case 8:
        return '•Перевод в ОИТР';
      default:
        return '•Критическое состояние, реанимационные мероприятия';
    }
  }
}

// Шкала Child-Pugh
class ChildPughScale implements MedicalScale {
  @override
  String get name => 'Шкала Чайлд-Пью';

  @override
  String get description =>
      '(Child-Pugh scale) Оценка тяжести цирроза печени и прогноза выживаемости. ';

  @override
  Map<String, List<ScaleItem>> get components => {
    'Асцит': [
      ScaleItem(description: 'Отсутствует', score: 1),
      ScaleItem(
        description: 'Незначительный или легко поддается лечению',
        score: 2,
      ),
      ScaleItem(description: 'Умеренный или резистентный к лечению', score: 3),
    ],

    'Энцефалопатия': [
      ScaleItem(description: 'Отсутствует', score: 1),
      ScaleItem(description: 'Степень I-II (легкая)', score: 2),
      ScaleItem(description: 'Степень III-IV (тяжелая)', score: 3),
    ],

    'Билирубин, мг/дл': [
      ScaleItem(description: '<2.0 (34 мкмоль/л)', score: 1),
      ScaleItem(description: '2.0-3.0 (34-51 мкмоль/л)', score: 2),
      ScaleItem(description: '>3.0 (>51 мкмоль/л)', score: 3),
    ],

    'Альбумин, г/л': [
      ScaleItem(description: '>3.5', score: 1),
      ScaleItem(description: '2.8-3.5', score: 2),
      ScaleItem(description: '<2.8', score: 3),
    ],

    'МНО (протромбиновое время)': [
      ScaleItem(description: '<1.7', score: 1),
      ScaleItem(description: '1.7-2.3', score: 2),
      ScaleItem(description: '>2.3', score: 3),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    switch (totalScore) {
      case 5 || 6:
        return '•Класс A (Компенсированный цирроз). \n•1-летняя выживаемость: 100%, \n•2-летняя: 85%';
      case 7 || 8 || 9:
        return '•Класс B (Субкомпенсированный цирроз) \n•1-летняя выживаемость: 80%, \n•2-летняя: 60%';
      case > 10:
        return '•Класс C (Декомпенсированный цирроз) \n•1-летняя выживаемость: 45%, \n•2-летняя: 35%';
      default:
        if (totalScore < 5) {
          return '$totalScore баллов - Недостаточно данных для оценки';
        }
        return '$totalScore баллов - Некорректное значение шкалы';
    }
  }
}

//Формула CKD-EPI
class CkdEpiScale extends MedicalScale {
  @override
  String get name => "CKD-EPI";

  @override
  String get description =>
      "Расчет скорости клубочковой фильтрации по формуле CKD-EPI";

  final bool isMale;
  final bool isBlackRace;
  final int creatinine; // в ммоль/л
  final int age;

  CkdEpiScale._({
    required this.isMale,
    required this.isBlackRace,
    required this.creatinine,
    required this.age,
  });
  factory CkdEpiScale.createTemplate() {
    return CkdEpiScale._(
      isMale: true, // значения по умолчанию
      isBlackRace: false,
      creatinine: 80, // нейтральное значение
      age: 30, // нейтральное значение
    );
  }
  factory CkdEpiScale.withParameters({
    required bool isMale,
    required bool isBlackRace,
    required int creatinine,
    required int age,
  }) {
    return CkdEpiScale._(
      isMale: isMale,
      isBlackRace: isBlackRace,
      creatinine: creatinine,
      age: age,
    );
  }

  CkdEpiScale copyWIth({
    bool? isMale,
    bool? isBlackRace,
    int? creatinine,
    int? age,
  }) {
    return CkdEpiScale._(
      isMale: isMale ?? this.isMale,
      isBlackRace: isBlackRace ?? this.isBlackRace,
      creatinine: creatinine ?? this.creatinine,
      age: age ?? this.age,
    );
  }

  @override
  Map<String, List<ScaleItem>> get components => {
    'Пол': [
      ScaleItem(
        description: isMale ? 'Мужской' : 'Женский',
        score: isMale ? 1 : 0,
      ),
    ],
    'Раса': [
      ScaleItem(
        description: isBlackRace ? 'Афроамериканец' : 'Другая',
        score: isBlackRace ? 1 : 0,
      ),
    ],
    'Креатинин': [
      ScaleItem(description: '$creatinine ммоль/л', score: creatinine),
    ],
    'Возраст': [ScaleItem(description: '$age лет', score: age)],
  };

  double calculateGfr() {
    final isCreatinineAboveThreshold = _determineCreatinineThreshold();

    // Конвертируем ммоль/л в мг/дл для расчета (1 ммоль/л = 0.0113 мг/дл)
    final creatinineMgDl = creatinine * 0.0113;

    double k;
    double a;

    if (isMale) {
      k = isCreatinineAboveThreshold ? 0.9 : 0.7;
      a = isCreatinineAboveThreshold ? -0.302 : -0.241;
    } else {
      k = 0.7;
      a = isCreatinineAboveThreshold ? -0.241 : -0.241;
    }

    // Явно преобразуем результат pow() в double
    double gfr =
        141 *
        (pow(min(creatinineMgDl / k, 1), a) as double) *
        (pow(max(creatinineMgDl / k, 1), -1.209) as double) *
        (pow(0.993, age) as double);

    if (!isMale) {
      gfr *= 1.018;
    }

    if (isBlackRace) {
      gfr *= 1.159;
    }

    return gfr;
  }

  @override
  String interpretationResult(num totalScore) {
    final gfr = calculateGfr();
    return _interpretGfr(gfr);
  }

  // Определяем порог креатинина в ммоль/л
  bool _determineCreatinineThreshold() {
    return isMale ? creatinine > 80 : creatinine > 62;
  }

  String _interpretGfr(double gfr) {
    return switch (gfr) {
      >= 90 =>
        'СКФ: ${gfr.toStringAsFixed(1)} мл/мин/1.73м² - Стадия 1: Нормальная функция почек',
      >= 60 =>
        'СКФ: ${gfr.toStringAsFixed(1)} мл/мин/1.73м² - Стадия 2: Легкое снижение',
      >= 30 =>
        'СКФ: ${gfr.toStringAsFixed(1)} мл/мин/1.73м² - Стадия 3: Умеренное снижение',
      >= 15 =>
        'СКФ: ${gfr.toStringAsFixed(1)} мл/мин/1.73м² - Стадия 4: Выраженное снижение',
      _ =>
        'СКФ: ${gfr.toStringAsFixed(1)} мл/мин/1.73м² - Стадия 5: Терминальная недостаточность',
    };
  }

  String getCreatinineStatus() {
    final threshold = isMale ? 80 : 62;
    return creatinine > threshold
        ? 'Выше нормы (>$threshold ммоль/л)'
        : 'В норме (≤$threshold ммоль/л)';
  }

  // Получаем пороговое значение для отображения
  int get creatinineThreshold => isMale ? 80 : 62;

  Map<String, dynamic> toJson() {
    return {
      'isMale': isMale,
      'isBlackRace': isBlackRace,
      'creatinine': creatinine,
      'age': age,
      'gfr': calculateGfr(),
      'creatinineStatus': getCreatinineStatus(),
    };
  }
}

//Шкала NIHSS
class NIHSSScale extends MedicalScale {
  @override
  String get name => "Шкала NIHSS";

  @override
  String get description => "Оценка тяжести инсульта";

  @override
  Map<String, List<ScaleItem>> get components => {
    '1a. Уровень сознания': [
      ScaleItem(description: 'Ясное', score: 0),
      ScaleItem(description: 'Оглушение', score: 1),
      ScaleItem(description: 'Сопор', score: 2),
      ScaleItem(description: 'Кома', score: 3),
    ],
    '1b. Вопросы (месяц, возраст)': [
      ScaleItem(description: 'Правильно на оба', score: 0),
      ScaleItem(description: 'Правильно на один', score: 1),
      ScaleItem(description: 'Неправильно на оба', score: 2),
    ],
    '1c. Выполнение команд (открой/закрой глаза, сожми кисть)': [
      ScaleItem(description: 'Выполняет обе', score: 0),
      ScaleItem(description: 'Выполняет одну', score: 1),
      ScaleItem(description: 'Не выполняет', score: 2),
    ],
    '2. Движения глаз': [
      ScaleItem(description: 'Нормальные', score: 0),
      ScaleItem(description: 'Частичный паралич взора', score: 1),
      ScaleItem(description: 'Тоническая девиация', score: 2),
    ],
    '3. Поля зрения': [
      ScaleItem(description: 'Норма', score: 0),
      ScaleItem(description: 'Частичная гемианопсия', score: 1),
      ScaleItem(description: 'Полная гемианопсия', score: 2),
      ScaleItem(description: 'Двусторонняя гемианопсия', score: 3),
    ],
    '4. Парез лицевой мускулатуры': [
      ScaleItem(description: 'Норма', score: 0),
      ScaleItem(description: 'Легкий парез', score: 1),
      ScaleItem(description: 'Умеренный парез', score: 2),
      ScaleItem(description: 'Полный паралич', score: 3),
    ],
    '5. Движения в левой руке': [
      ScaleItem(description: 'Норма (удерживает 10 сек)', score: 0),
      ScaleItem(description: 'Дрейф (удерживает 5-9 сек)', score: 1),
      ScaleItem(description: 'Спуск (удерживает 1-4 сек)', score: 2),
      ScaleItem(description: 'Нет движений', score: 3),
      ScaleItem(description: 'Нет ответа', score: 4),
    ],
    '6. Движения в правой руке': [
      ScaleItem(description: 'Норма (удерживает 10 сек)', score: 0),
      ScaleItem(description: 'Дрейф (удерживает 5-9 сек)', score: 1),
      ScaleItem(description: 'Спуск (удерживает 1-4 сек)', score: 2),
      ScaleItem(description: 'Нет движений', score: 3),
      ScaleItem(description: 'Нет ответа', score: 4),
    ],
    '7. Движения в левой ноге': [
      ScaleItem(description: 'Норма (удерживает 5 сек)', score: 0),
      ScaleItem(description: 'Дрейф (удерживает 3-4 сек)', score: 1),
      ScaleItem(description: 'Спуск (удерживает 1-2 сек)', score: 2),
      ScaleItem(description: 'Нет движений', score: 3),
      ScaleItem(description: 'Нет ответа', score: 4),
    ],
    '8. Движения в правой ноге': [
      ScaleItem(description: 'Норма (удерживает 5 сек)', score: 0),
      ScaleItem(description: 'Дрейф (удерживает 3-4 сек)', score: 1),
      ScaleItem(description: 'Спуск (удерживает 1-2 сек)', score: 2),
      ScaleItem(description: 'Нет движений', score: 3),
      ScaleItem(description: 'Нет ответа', score: 4),
    ],
    '9. Атаксия конечностей': [
      ScaleItem(description: 'Отсутствует', score: 0),
      ScaleItem(description: 'В одной конечности', score: 1),
      ScaleItem(description: 'В двух конечностях', score: 2),
    ],
    '10. Чувствительность': [
      ScaleItem(description: 'Норма', score: 0),
      ScaleItem(description: 'Легкие нарушения', score: 1),
      ScaleItem(description: 'Выраженные нарушения', score: 2),
    ],
    '11. Речь': [
      ScaleItem(description: 'Норма', score: 0),
      ScaleItem(description: 'Легкая афазия', score: 1),
      ScaleItem(description: 'Выраженная афазия', score: 2),
      ScaleItem(description: 'Мутизм', score: 3),
    ],
    '12. Дизартрия': [
      ScaleItem(description: 'Норма', score: 0),
      ScaleItem(description: 'Легкая', score: 1),
      ScaleItem(description: 'Невнятная речь', score: 2),
      ScaleItem(description: 'Неразборчивая речь', score: 3),
    ],
    '13. Игнорирование (неглект)': [
      ScaleItem(description: 'Отсутствует', score: 0),
      ScaleItem(description: 'Легкое', score: 1),
      ScaleItem(description: 'Выраженное', score: 2),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      < 5 =>
        '•Лёгкий инсульт. \n•Прогноз благоприятный. \n•Возможно консервативное лечение. ',
      >= 5 && < 15 =>
        '•Умеренный инсульт. \n•Требуется активное лечение и реабилитация.',
      >= 15 && <= 20 =>
        '•Тяжёлый инсульт. \n•Высокий риск осложнений. \n•Требуется интенсивная терапия.',
      > 20 =>
        '•Очень тяжёлый инсульт.\n•Критическое состояние. \n•Высокая летальность ',
      _ => 'Неопределённая степень тяжести ($totalScore баллов)',
    };
  }
}

//Шкала APACHE 2
class Apache2Scale extends MedicalScale {
  @override
  String get name => "Шкала APACHE II";

  @override
  String get description => "Оценка тяжести состояния пациентов в ОРИТ";

  @override
  Map<String, List<ScaleItem>> get components => {
    'Температура (°C)': [
      ScaleItem(description: '≥ 41.0', score: 4),
      ScaleItem(description: '39.0-40.9', score: 3),
      ScaleItem(description: '38.5-38.9', score: 1),
      ScaleItem(description: '36.0-38.4', score: 0),
      ScaleItem(description: '34.0-35.9', score: 1),
      ScaleItem(description: '32.0-33.9', score: 2),
      ScaleItem(description: '30.0-31.9', score: 3),
      ScaleItem(description: '≤ 29.9', score: 4),
    ],
    'Среднее АД (мм рт.ст.)': [
      ScaleItem(description: '≥ 160', score: 4),
      ScaleItem(description: '130-159', score: 3),
      ScaleItem(description: '110-129', score: 2),
      ScaleItem(description: '70-109', score: 0),
      ScaleItem(description: '50-69', score: 2),
      ScaleItem(description: '≤ 49', score: 4),
    ],
    'ЧСС (уд/мин)': [
      ScaleItem(description: '≥ 180', score: 4),
      ScaleItem(description: '140-179', score: 3),
      ScaleItem(description: '110-139', score: 2),
      ScaleItem(description: '70-109', score: 0),
      ScaleItem(description: '55-69', score: 2),
      ScaleItem(description: '40-54', score: 3),
      ScaleItem(description: '≤ 39', score: 4),
    ],
    'ЧД (дых/мин)': [
      ScaleItem(description: '≥ 50', score: 4),
      ScaleItem(description: '35-49', score: 3),
      ScaleItem(description: '25-34', score: 1),
      ScaleItem(description: '12-24', score: 0),
      ScaleItem(description: '10-11', score: 1),
      ScaleItem(description: '6-9', score: 2),
      ScaleItem(description: '≤ 5', score: 4),
    ],
    'Кислородация (PaO2 мм рт.ст. или SpO2 %)': [
      ScaleItem(description: 'PaO2 ≥ 500 (SpO2 ≥ 96%)', score: 0),
      ScaleItem(description: 'PaO2 350-499 (SpO2 90-95%)', score: 1),
      ScaleItem(description: 'PaO2 200-349 (SpO2 85-89%)', score: 2),
      ScaleItem(description: 'PaO2 < 200 (SpO2 < 85%)', score: 4),
    ],
    'Артериальный pH': [
      ScaleItem(description: '≥ 7.7', score: 4),
      ScaleItem(description: '7.6-7.69', score: 3),
      ScaleItem(description: '7.5-7.59', score: 1),
      ScaleItem(description: '7.33-7.49', score: 0),
      ScaleItem(description: '7.25-7.32', score: 2),
      ScaleItem(description: '7.15-7.24', score: 3),
      ScaleItem(description: '< 7.15', score: 4),
    ],
    'Натрий (ммоль/л)': [
      ScaleItem(description: '≥ 180', score: 4),
      ScaleItem(description: '160-179', score: 3),
      ScaleItem(description: '155-159', score: 2),
      ScaleItem(description: '150-154', score: 1),
      ScaleItem(description: '130-149', score: 0),
      ScaleItem(description: '120-129', score: 2),
      ScaleItem(description: '111-119', score: 3),
      ScaleItem(description: '≤ 110', score: 4),
    ],
    'Калий (ммоль/л)': [
      ScaleItem(description: '≥ 7.0', score: 4),
      ScaleItem(description: '6.0-6.9', score: 3),
      ScaleItem(description: '5.5-5.9', score: 1),
      ScaleItem(description: '3.5-5.4', score: 0),
      ScaleItem(description: '3.0-3.4', score: 1),
      ScaleItem(description: '2.5-2.9', score: 2),
      ScaleItem(description: '< 2.5', score: 4),
    ],
    'Креатинин (мг/дл)': [
      ScaleItem(description: '≥ 3.5', score: 4),
      ScaleItem(description: '2.0-3.4', score: 3),
      ScaleItem(description: '1.5-1.9', score: 2),
      ScaleItem(description: '0.6-1.4', score: 0),
      ScaleItem(description: '< 0.6', score: 2),
    ],
    'Гематокрит (%)': [
      ScaleItem(description: '≥ 60', score: 4),
      ScaleItem(description: '50-59.9', score: 2),
      ScaleItem(description: '46-49.9', score: 1),
      ScaleItem(description: '30-45.9', score: 0),
      ScaleItem(description: '20-29.9', score: 2),
      ScaleItem(description: '< 20', score: 4),
    ],
    'Лейкоциты (×10⁹/л)': [
      ScaleItem(description: '≥ 40', score: 4),
      ScaleItem(description: '20-39.9', score: 2),
      ScaleItem(description: '15-19.9', score: 1),
      ScaleItem(description: '3-14.9', score: 0),
      ScaleItem(description: '1-2.9', score: 2),
      ScaleItem(description: '< 1', score: 4),
    ],
    'Шкала Глазго (GCS)': [
      ScaleItem(description: '15 (норма)', score: 0),
      ScaleItem(description: '13-14', score: 1),
      ScaleItem(description: '10-12', score: 2),
      ScaleItem(description: '7-9', score: 3),
      ScaleItem(description: '4-6', score: 4),
      ScaleItem(description: '3', score: 5),
    ],
    'Возраст (лет)': [
      ScaleItem(description: '≤ 44', score: 0),
      ScaleItem(description: '45-54', score: 2),
      ScaleItem(description: '55-64', score: 3),
      ScaleItem(description: '65-74', score: 5),
      ScaleItem(description: '≥ 75', score: 6),
    ],
    'Хронические заболевания': [
      ScaleItem(description: 'Нет', score: 0),
      ScaleItem(description: 'ХОБЛ, ХСН, цирроз, иммуносупрессия', score: 2),
      ScaleItem(description: 'Послеоперационные пациенты', score: 5),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      < 5 =>
        '''Низкий риск летальности \n•Благоприятный прогноз. \n•Прогнозируемая летальность: 4%. \n• Стандартное наблюдение в ОРИТ\n• Ежедневная переоценка состояния\n• Подготовка к переводу в обычное отделение''',
      >= 5 && < 10 =>
        '''Низкий риск летальности \n•Благоприятный прогноз.\n•Прогнозируемая летальность: 8%. \n• Стандартное наблюдение в ОРИТ\n• Ежедневная переоценка состояния\n• Подготовка к переводу в обычное отделение''',
      >= 10 && < 15 =>
        '''Умеренный риск летальности \n•Прогнозируемая летальность: 15%. \n• Интенсивное мониторирование\n• Коррекция жизненных функций\n• Профилактика осложнений.''',
      >= 15 && < 20 =>
        '''Умеренный риск летальности ($totalScore баллов) \n•Прогнозируемая летальность: 25%. \n• Интенсивное мониторирование\n• Коррекция жизненных функций\n• Профилактика осложнений.''',
      >= 20 && < 25 =>
        '''Высокий риск летальности \n•Критическое состояние\n•Прогнозируемая летальность: 40%. \n• Максимальная респираторная поддержка\n• Гемодинамический мониторинг\n• Коррекция метаболических нарушений''',
      >= 25 && < 30 =>
        '''Высокий риск летальности \n•Критическое состояние\n•Прогнозируемая летальность: 55%. \n• Максимальная респираторная поддержка\n• Гемодинамический мониторинг\n• Коррекция метаболических нарушений''',
      >= 30 && < 35 =>
        '''Высокий риск летальности \n•Критическое состояние\n•Прогнозируемая летальность: 75%. \n• Максимальная респираторная поддержка\n• Гемодинамический мониторинг\n• Коррекция метаболических нарушений''',
      >= 35 && < 40 =>
        '''Очень высокий риск летальности\n•Крайне тяжелое состояние.\n•Прогнозируемая летальность: 85%. \n• Паллиативная поддержка\n• Обсуждение с родственниками\n• Поддержание витальных функций''',
      >= 40 =>
        '''Очень высокий риск летальности \n•Крайне тяжелое состояние.\n•Прогнозируемая летальность: 95%. \n• Паллиативная поддержка\n• Обсуждение с родственниками\n• Поддержание витальных функций''',
      _ => 'Неопределённый риск ($totalScore баллов)',
    };
  }
}

//Шкала AppGar
class ApgarScale extends MedicalScale {
  @override
  String get name => "Шкала Апгар";

  @override
  String get description =>
      "(AppGar scale) Оценка состояния новорожденного на 1-й и 5-й минуте жизни";

  @override
  Map<String, List<ScaleItem>> get components => {
    'Цвет кожных покровов': [
      ScaleItem(description: 'Бледный или цианотичный', score: 0),
      ScaleItem(description: 'Розовый, синюшные конечности', score: 1),
      ScaleItem(description: 'Полностью розовый', score: 2),
    ],
    'Пульс (уд/мин)': [
      ScaleItem(description: 'Отсутствует', score: 0),
      ScaleItem(description: '< 100 уд/мин', score: 1),
      ScaleItem(description: '≥ 100 уд/мин', score: 2),
    ],
    'Реакция на раздражение': [
      ScaleItem(description: 'Не реагирует', score: 0),
      ScaleItem(description: 'Гримаса, слабые движения', score: 1),
      ScaleItem(description: 'Кашель, чихание, крик', score: 2),
    ],
    'Мышечный тонус': [
      ScaleItem(description: 'Атония', score: 0),
      ScaleItem(description: 'Сгибание конечностей', score: 1),
      ScaleItem(description: 'Активные движения', score: 2),
    ],
    'Дыхание': [
      ScaleItem(description: 'Отсутствует', score: 0),
      ScaleItem(description: 'Нерегулярное, слабое', score: 1),
      ScaleItem(description: 'Нормальное, громкий крик', score: 2),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      0 =>
        'Критическое состояние (0 баллов) \n•Требуется немедленная реанимация\n• ИВЛ\n•Оксигенация\n•Мониторинг',
      1 || 2 =>
        'Крайне тяжелое состояние ($totalScore балла) \n•Требуется немедленная реанимация\n•ИВЛ\n• Оксигенация\n•Мониторинг',
      3 || 4 =>
        'Тяжелое состояние ($totalScore балла)\n•Требуется немедленная реанимация\n•ИВЛ\n• Оксигенация\n•Мониторинг',
      5 || 6 =>
        'Состояние средней тяжести ($totalScore баллов) \n•Требуется медицинская помощь\n•Тактильная стимуляция\n•Оксигенация\n• Повторная оценка через 1 мин',
      7 || 8 =>
        'Легкое нарушение состояния ($totalScore баллов) \n•Стандартный уход\n•Контакт кожа к коже\n• Наблюдение',
      9 || 10 =>
        'Нормальное состояние ($totalScore баллов) \n•Стандартный уход\n•Контакт кожа к коже\n• Наблюдение',
      _ => 'Неопределённое состояние ($totalScore баллов)',
    };
  }
}

//Шкала Уэллса
class WellsScale extends MedicalScale {
  @override
  String get name => "Шкала Уэллса";

  @override
  String get description =>
      "(Wells scale) Оценка клинической вероятности тромбоэмболии легочной артерии (ТЭЛА)";

  @override
  Map<String, List<ScaleItem>> get components => {
    'Клинические симптомы ТГВ': [
      ScaleItem(
        description:
            'Болезненность по ходу глубоких вен и отек одной конечности',
        score: 3,
      ),
      ScaleItem(description: "Нет", score: 0),
    ],
    'Альтернативный диагноз менее вероятен': [
      ScaleItem(description: 'Да', score: 3),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'ЧСС > 100 уд/мин': [
      ScaleItem(description: 'Да', score: 1.5),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Иммобилизация/операция последние 4 недели': [
      ScaleItem(description: 'Да', score: 1.5),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'ТГВ или ТЭЛА в анамнезе': [
      ScaleItem(description: 'Да', score: 1.5),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Кровохарканье': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Онкологическое заболевание': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    if (totalScore < 2) {
      return 'Низкая вероятность ТЭЛА ($totalScore балла)  \n•Риск ТЭЛА < 5%. \n•Дальнейшая диагностика может не требоваться при отрицательном D-димере.)';
    } else if (totalScore >= 2 && totalScore <= 6) {
      return 'Умеренная вероятность ТЭЛА ($totalScore баллов) \n•Риск ТЭЛА 20-30%. \n•Рекомендуется проведение КТ-ангиографии легких или вентиляционно-перфузионной сцинтиграфии.';
    } else {
      return 'Высокая вероятность ТЭЛА ($totalScore баллов)\n•Риск ТЭЛА > 50%. \n•Показана экстренная КТ-ангиография легких. \n•Рассмотреть начало антикоагулянтной терапии.';
    }
  }
}

//Шкала HAS-BLED
class HasBledScale extends MedicalScale {
  @override
  String get name => "Шкала HAS-BLED";

  @override
  String get description =>
      "Оценка риска больших кровотечений при антикоагулянтной терапии";

  final Map<String, bool> _scores = {
    'hypertension': false, // Артериальная гипертензия
    'renal_disease': false, // Почечная недостаточность
    'liver_disease': false, // Печеночная недостаточность
    'stroke_history': false, // Инсульт в анамнезе
    'bleeding_history': false, // Кровотечения в анамнезе
    'labile_inr': false, // Лабильное МНО
    'elderly': false, // Возраст > 65 лет
    'drugs': false, // Прием препаратов (антиагреганты, НПВП)
    'alcohol': false, // Злоупотребление алкоголем
  };

  // Установка баллов для каждого параметра
  void setScore(String parameter, bool value) {
    if (_scores.containsKey(parameter)) {
      _scores[parameter] = value;
    }
  }

  bool getScore(String parameter) {
    return _scores[parameter] ?? false;
  }

  @override
  Map<String, List<ScaleItem>> get components => {
    'Артериальная гипертензия (неконтролируемая, САД > 160 мм рт.ст.)': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Почечная недостаточность (ХБП, диализ, креатинин > 200 мкмоль/л)': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Печеночная недостаточность (цирроз, билирубин > 2×N, АСТ/АЛТ > 3×N)': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Инсульт в анамнезе': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Кровотечения в анамнезе или предрасположенность': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Лабильное МНО (время в терапевтическом диапазоне < 60%)': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Возраст > 65 лет': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Прием препаратов (антиагреганты, НПВП)': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Злоупотребление алкоголем (≥8 порций в неделю)': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
  };

  // Расчет общего балла
  int get totalScore {
    int score = 0;

    for (final value in _scores.values) {
      if (value == true) {
        score += 1;
      }
    }

    return score;
  }

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      0 =>
        '•Низкий риск кровотечения (0 баллов) \n•Годовая вероятность больших кровотечений: 1.0%.', //'• Антикоагулянтная терапия может быть назначена\n• Регулярный мониторинг (1 раз в 3-6 месяцев)'
      1 =>
        '•Низкий риск кровотечения (1 балл) \n•Годовая вероятность больших кровотечений: 1.9%', //'• Антикоагулянтная терапия может быть назначена\n• Регулярный мониторинг (1 раз в 3-6 месяцев)'
      2 =>
        '•Умеренный риск кровотечения (2 балла) \n•Годовая вероятность больших кровотечений: 3.7%.', //• Осторожное назначение антикоагулянтов\n• Более частый мониторинг МНО\n• Рассмотреть целевой диапазон МНО 2.0-2.5'
      3 =>
        '•Высокий риск кровотечения (3 балла) \n•Годовая вероятность больших кровотечений: 8.7%.', //• Тщательная оценка пользы/риска\n• Частый мониторинг (каждые 4-6 недель)\n• Коррекция модифицируемых факторов риска
      4 =>
        '•Очень высокий риск кровотечения (4 балла)\n•Годовая вероятность больших кровотечений: 12.5%.', //• Высокий риск кровотечения\n• Рассмотреть альтернативы варфарину (НОАК)\n• Обязательная коррекция факторов риска\n• Очень частый мониторинг'
      _ =>
        '•Очень высокий риск кровотечения ($totalScore баллов) \n•Годовая вероятность больших кровотечений: >15%. \n•Требуется осторожность при назначении антикоагулянтов.', //• Высокий риск кровотечения\n• Рассмотреть альтернативы варфарину (НОАК)\n• Обязательная коррекция факторов риска\n• Очень частый мониторинг'
    };
  }
}

//Женевская шкала пересмотренная
class GenevaRevisedScale extends MedicalScale {
  @override
  String get name => "Женевская шкала (пересмотренная)";

  @override
  String get description =>
      "(Geneva scale revised) Оценка клинической вероятности тромбоэмболии легочной артерии (ТЭЛА)";

  @override
  Map<String, List<ScaleItem>> get components => {
    'Возраст': [
      ScaleItem(description: 'Возраст больше 65 лет', score: 1),
      ScaleItem(description: 'Возраст меньше 65 лет', score: 0),
    ],
    'Предыдущие случаи ТГВ или ТЭЛА в анамнезе': [
      ScaleItem(description: 'Да', score: 3),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Хирургическое вмешательство или переломы течение последнего месяца': [
      ScaleItem(description: 'Да', score: 2),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Злокачественное новообразование активное или вылеченное в настоящее время <1 года):':
        [
          ScaleItem(description: 'Да', score: 2),
          ScaleItem(description: 'Нет', score: 0),
        ],
    'Боль в одной нижней конечности': [
      ScaleItem(description: 'Да', score: 3),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Кровохарканье': [
      ScaleItem(description: 'Да', score: 2),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Болезненность при пальпации глубоких вен и отек одной ноги': [
      ScaleItem(description: 'Да', score: 4),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Частота сердечных сокращений': [
      ScaleItem(description: 'Меньше 75 уд/мин', score: 0),
      ScaleItem(description: 'ЧСС 75-94 уд/мин', score: 3),
      ScaleItem(description: 'ЧСС больше 95 уд/мин', score: 5),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      0 => 'Низкая вероятность ТЭЛА ($totalScore баллов)',
      1 =>
        'Низкая вероятность ТЭЛА (1 балл) \n•Риск ТЭЛА < 10%. \n•Рекомендуется определение D-димера.',
      2 =>
        'Низкая вероятность ТЭЛА (2 балла) \n•Риск ТЭЛА < 10%. \n•Рекомендуется определение D-димера.',
      3 =>
        'Низкая вероятность ТЭЛА (3 балла) \n•Риск ТЭЛА < 10%. \n•Рекомендуется определение D-димера.',
      4 =>
        'Умеренная вероятность ТЭЛА (4 балла)  \n•Риск ТЭЛА 30-35%. \n•Показана КТ-ангиография легких.',
      5 =>
        'Умеренная вероятность ТЭЛА (5 баллов)  \n•Риск ТЭЛА 30-35%. \n•Показана КТ-ангиография легких.',
      6 =>
        'Умеренная вероятность ТЭЛА (6 баллов)  \n•Риск ТЭЛА 30-35%. \n•Показана КТ-ангиография легких.',
      7 =>
        'Умеренная вероятность ТЭЛА (7 баллов)  \n•Риск ТЭЛА 30-35%. \n•Показана КТ-ангиография легких.',
      8 =>
        'Умеренная вероятность ТЭЛА (8 баллов)  \n•Риск ТЭЛА 30-35%. \n•Показана КТ-ангиография легких.',
      9 =>
        'Высокая вероятность ТЭЛА (9 баллов)  \n•Риск ТЭЛА > 65%. \n•Необходима срочная КТ-ангиография легких.',
      10 =>
        'Высокая вероятность ТЭЛА (10 баллов)  \n•Риск ТЭЛА > 65%. \n•Необходима срочная КТ-ангиография легких.',
      11 =>
        'Высокая вероятность ТЭЛА (11 баллов)  \n•Риск ТЭЛА > 65%. \n•Необходима срочная КТ-ангиография легких.',
      _ =>
        'Очень высокая вероятность ТЭЛА ($totalScore баллов)  Риск ТЭЛА > 65%. Необходима срочная КТ-ангиография легких.',
    };
  }
}

//Шкала Каприни
class CapriniScale extends MedicalScale {
  @override
  String get name => "Шкала Каприни";

  @override
  String get description =>
      "(Caprini scale)Шкала оценки риска венозных тромбоэмболических осложнений (ВТЭО). "
      "Используется для оценки риска тромбозов у хирургических пациентов.";

  @override
  Map<String, List<ScaleItem>> get components => {
    "Возраст": [
      ScaleItem(description: "Менее 40 лет", score: 0),
      ScaleItem(description: "40-59 лет", score: 1),
      ScaleItem(description: "60-74 лет", score: 2),
      ScaleItem(description: "75 лет и более", score: 3),
    ],
    "Масса тела": [
      ScaleItem(description: "ИМТ < 25", score: 0),
      ScaleItem(description: "ИМТ 25-35", score: 1),
      ScaleItem(description: "ИМТ > 35", score: 2),
    ],
    "Двигательный режим": [
      ScaleItem(description: "Нормальная подвижность", score: 0),
      ScaleItem(description: "Постельный режим ≥72 ч", score: 1),
      ScaleItem(
        description: "Ограниченная подвижность (гипс, паралич)",
        score: 2,
      ),
    ],
    "Хирургическое вмешательство": [
      ScaleItem(description: "Малая операция (<45 мин)", score: 1),
      ScaleItem(description: "Большая операция (>45 мин)", score: 2),
      ScaleItem(description: "Артроскопия, лапароскопия (>45 мин)", score: 2),
    ],
    "Травма/ожоги": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 2),
    ],
    "Злокачественные новообразования": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 2),
    ],
    "Сердечная недостаточность": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Инфаркт миокарда": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Сепсис": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Тяжелое заболевание легких": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Варикозное расширение вен": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Тромбофилии": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 3),
    ],
    "Инсульт": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Гормональная терапия/КОК": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Беременность/послеродовый период": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 1),
    ],
    "Тромбозы в анамнезе": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 3),
    ],
    "Семейный анамнез тромбозов": [
      ScaleItem(description: "Нет", score: 0),
      ScaleItem(description: "Да", score: 3),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    if (totalScore < 1) {
      return "Очень низкий риск ВТЭО \n•Риск <0.5% \n•Ранняя активизация, эластическая компрессия";
    } else if (totalScore == 1) {
      return "Низкий риск ВТЭО \n•Риск 1.5% \n•Эластическая компрессия, ранняя активизация";
    } else if (totalScore == 2) {
      return "Умеренный риск ВТЭО \n•Риск 3.0% \n•НМГ/НФГ + эластическая компрессия";
    } else if (totalScore == 3 || totalScore == 4) {
      return "Высокий риск ВТЭО Риск 6.0%  \n•НМГ/НФГ + эластическая компрессия, \n•Рассмотреть продленную профилактику";
    } else {
      return "Очень высокий риск ВТЭО \n•Риск >6.0% \n•Интенсивная профилактика НМГ/НФГ \n•Механическая профилактика";
    }
  }
}

//Шкала Villata
class VillaltaScale extends MedicalScale {
  @override
  String get name => "Шкала Вильялты";

  @override
  String get description =>
      "(Villalta scale) Шкала для оценки тяжести и диагностики "
      "посттромботического синдрома и хронической венозной недостаточности "
      "нижних конечностей. Оценивает симптомы и объективные признаки.";

  @override
  Map<String, List<ScaleItem>> get components => {
    "Боли": [
      ScaleItem(description: "Отсутствуют", score: 0),
      ScaleItem(description: "Легкие, не требующие анальгетиков", score: 1),
      ScaleItem(description: "Умеренные, требующие анальгетиков", score: 2),
      ScaleItem(
        description: "Сильные, не купирующиеся анальгетиками",
        score: 3,
      ),
    ],
    "Чувство тяжести": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(
        description: "Легкое, только после длительной нагрузки",
        score: 1,
      ),
      ScaleItem(description: "Умеренное, после обычной нагрузки", score: 2),
      ScaleItem(description: "Сильное, в покое", score: 3),
    ],
    "Парестезии (покалывание, онемение)": [
      ScaleItem(description: "Отсутствуют", score: 0),
      ScaleItem(description: "Редкие, преходящие", score: 1),
      ScaleItem(description: "Частые", score: 2),
      ScaleItem(description: "Постоянные", score: 3),
    ],
    "Зуд": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(description: "Редкий, не беспокоящий", score: 1),
      ScaleItem(description: "Частый, умеренно беспокоящий", score: 2),
      ScaleItem(description: "Постоянный, сильно беспокоящий", score: 3),
    ],
    "Судороги": [
      ScaleItem(description: "Отсутствуют", score: 0),
      ScaleItem(description: "Редкие (1-2 раза в месяц)", score: 1),
      ScaleItem(description: "Частые (1-2 раза в неделю)", score: 2),
      ScaleItem(description: "Ежедневные", score: 3),
    ],
    "Отек": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(
        description: "Только к вечеру, исчезает после отдыха",
        score: 1,
      ),
      ScaleItem(description: "Стойкий, уменьшается после отдыха", score: 2),
      ScaleItem(description: "Стойкий, не уменьшается после отдыха", score: 3),
    ],
    "Индурация (уплотнение кожи)": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(description: "Ограниченная (<5 см диаметром)", score: 1),
      ScaleItem(description: "Распространенная (5-10 см)", score: 2),
      ScaleItem(description: "Обширная (>10 см)", score: 3),
    ],
    "Гиперпигментация": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(description: "Ограниченная (<5 см диаметром)", score: 1),
      ScaleItem(description: "Распространенная (5-10 см)", score: 2),
      ScaleItem(description: "Обширная (>10 см)", score: 3),
    ],
    "Красный дерматит": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(description: "Ограниченный (<5 см диаметром)", score: 1),
      ScaleItem(description: "Распространенный (5-10 см)", score: 2),
      ScaleItem(description: "Обширный (>10 см)", score: 3),
    ],
    "Экзема": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(description: "Ограниченная (<5 см диаметром)", score: 1),
      ScaleItem(description: "Распространенная (5-10 см)", score: 2),
      ScaleItem(description: "Обширная (>10 см)", score: 3),
    ],
    "Венозная эктазия": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(description: "Единичные (<5 шт)", score: 1),
      ScaleItem(description: "Множественные (5-10 шт)", score: 2),
      ScaleItem(description: "Множественные (>10 шт)", score: 3),
    ],
    "Болезненность при пальпации": [
      ScaleItem(description: "Отсутствует", score: 0),
      ScaleItem(description: "Локальная, только по ходу вен", score: 1),
      ScaleItem(description: "Распространенная по ходу вен", score: 2),
      ScaleItem(description: "Диффузная", score: 3),
    ],
  };

  @override
  String interpretationResult(num totalScore) {
    if (totalScore < 5) {
      return "Отсутствие посттромботического синдрома. \n•Компрессионная профилактика \n•Модификация образа жизни";
    } else if (totalScore >= 5 && totalScore <= 9) {
      return "Легкий посттромботический синдром. \n•Компрессионный трикотаж 1-2 класса, \n•Флеботоники, ЛФК";
    } else if (totalScore >= 10 && totalScore <= 14) {
      return "Умеренный посттромботический синдром.\n•Компрессионный трикотаж 2 класса, \n•Фрмакотерапия, физиотерапия";
    } else {
      return "Тяжелый посттромботический синдром. \n•Компрессионный трикотаж 3 класса, \n•Интенсивная фармакотерапия, \n•Возможность хирургического лечения";
    }
  }
}

class AkvoradoScale extends MedicalScale {
  @override
  Map<String, List<ScaleItem>> get components => {
    'Болезненность в правой подвздошной области': [
      ScaleItem(description: 'Да', score: 2),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Повышение температуры тела >37,3': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Положительный симптом Щеткина-Блюмберга ': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Положительный симптом Кохера': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Потеря аппетита': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Тошнота/рвота': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Лейкоцитоз>10x10^9/л2': [
      ScaleItem(description: 'Да', score: 2),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Сдвиг лейкоцитарной формулы влево(Нейтрофилез>75%)': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
  };

  @override
  String get description => '(Akvorado scale)Диагностика острого аппендицита';

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      < 5 => 'Остырй аппендицит маловероятен',
      < 7 => 'Острый аппендицит возможен',
      < 9 => 'Острый аппендицит вероятен',
      _ => 'Острый аппендицит имеется',
    };
  }

  @override
  String get name => 'Шкала Альворадо';
}

class SmartCoP extends MedicalScale {
  @override
  Map<String, List<ScaleItem>> get components => {
    'Систолическое артериальное давление меньше 90 мм.рт.ст': [
      ScaleItem(description: 'Да', score: 2),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Мультилобарная инфильтрация, выявленная на рентгене': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Содержание альбумина в плазме крови менее 3,5 г/дл': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'ЧДД>25 в минуту в возрасте <50 лет  ЧДД >30 в минуту в возрасте>50 лет': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'ЧСС больше 125 в мин': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Нарушение сознания': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],

    '''<50 лет PaO2 < 70 мм рт.ст. или O2 ≤ 93% или PaO2/FiO2 < 333 при получении O2
>50 лет: PaO2 < 60 мм рт.ст. или насыщение O2 ≤ 90 % или PaO2/FiO2 < 250 при получении O2 +2''':
        [
          ScaleItem(description: 'Да', score: 2),
          ScaleItem(description: 'Нет', score: 0),
        ],

    'pH артериальной крови менее 7.35': [
      ScaleItem(description: 'Да', score: 2),
      ScaleItem(description: 'Нет', score: 0),
    ],
  };

  @override
  String get description =>
      '(SMART-COP scale)Оценка тяжести внеболичной пневмонии';

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      < 3 =>
        'Низкий риск потребности в респираторной и \n вазопрессорной поддержке.',
      < 5 =>
        'Умеренный риск потребности в респираторной и вазопрессорной поддержке.',
      < 7 =>
        'Высокий риск потребности в респираторной и вазопрессорной поддержке.',
      _ =>
        'Очень высокий риск потребности в респираторной и вазопрессорной поддержке.',
    };
  }

  @override
  String get name => 'Шкала СМАРТ-КОП';
}

class Crb65 extends MedicalScale {
  @override
  Map<String, List<ScaleItem>> get components => {
    '(C)Нарушение сознания': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    '(U)Азот мочевины >7 ммоль/л': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    '(R)ЧДД>=30/мин': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    '(B)Систолическое АД < 90 или диастоличесоке АД<= 60 мм.рт.ст': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    '(65)Возраст>=65лет': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
  };

  @override
  String get description => 'Шкала для оценки тяжести внебольничной пневмони';

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      < 2 => 'I Группа\nАмбулаторное лечение  \n Летальность 1,5%.',
      < 3 =>
        'II Группа\nАмбулаторное лечение под наблюдением или кратковременная госпитализация  \n Летальность 9,2%.',
      _ => 'III Группа\nНеотложная госпитализация  \n Летальность 22%.',
    };
  }

  @override
  String get name => 'CRB-65';
}

class CHA2DS2 extends MedicalScale {
  @override
  Map<String, List<ScaleItem>> get components => {
    'Сердечная недостаточность': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Артериальная гипертензия': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Сахарный диабет': [
      ScaleItem(description: 'Да', score: 1),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Инсульт/ТИА/Тромбоэмболия': [
      ScaleItem(description: 'Да', score: 2),
      ScaleItem(description: 'Нет', score: 0),
    ],
    'Сосудистые заболевания(инфаркт, атересклероз переферических артерий, бляшка в анамнезе)':
        [
          ScaleItem(description: 'Да', score: 1),
          ScaleItem(description: 'Нет', score: 0),
        ],
    'Возраст': [
      ScaleItem(description: '65-74', score: 1),
      ScaleItem(description: '>=75', score: 2),
    ],
    'Пол': [
      ScaleItem(description: 'Мужской', score: 0),
      ScaleItem(description: 'Женский', score: 1),
    ],
  };

  @override
  String get description =>
      'Шкала оценки риска тромбоэмболических осложнений у пациентов с фибрилляцией/трепетанием предсердий';

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      < 1 =>
        '•Аспирин 75-325 мг в сутки или отсутствие антитромботической терапии (предпочтительно)\n•Риск развития инсульта в течение года: 0,0%%.',
      < 2 =>
        '•Пероральный антикоагулянт (предпочтительно) или аспирин 75-325 мг в сутки \n•Риск развития инсульта в течение года: 1,3%.',
      < 3 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 2,2%.',
      < 4 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 3,2%.',
      < 5 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 4%.',
      < 6 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 6,7%.',
      < 7 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 9,8%.',
      < 8 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 9,6%.',
      < 9 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 6,7%.',
      < 10 =>
        '•Антагонист витамина К (например, варфарин) с целевым МНО 2,5 (2,0-3,0)\n•Риск развития инсульта в течение года: 15,2%.',
      _ => '',
    };
  }

  @override
  String get name => 'CHA2DS2-VASc';
}

class Dehidrotation extends MedicalScale {
  @override
  Map<String, List<ScaleItem>> get components => {
    'Рвота': [
      ScaleItem(description: 'До 5 раз в сутки', score: 0),

      ScaleItem(description: '5-10 раз в сутки', score: 1),
      ScaleItem(description: 'Более 10 раз в сутки', score: 2),
    ],
    'Жидкий стул': [
      ScaleItem(description: 'Нет или до 10 раз в сутки', score: 0),

      ScaleItem(description: '10-20 раз в сутки', score: 1),
      ScaleItem(description: 'Более 20 раз в сутки', score: 2),
    ],
    'Гемодинамика(АД и ЧСС)': [
      ScaleItem(description: 'Норма', score: 0),
      ScaleItem(description: 'Верхняя граница возрастной нормы', score: 1),
      ScaleItem(description: 'Гиперергия и гипоергия', score: 2),
    ],
    'Диурез': [
      ScaleItem(description: 'Норма', score: 0),
      ScaleItem(description: 'Олигурия', score: 1),
      ScaleItem(description: 'Анурия', score: 2),
    ],
    'Мышечные судороги': [
      ScaleItem(description: 'Нет', score: 0),

      ScaleItem(description: 'Кратковременные', score: 1),
      ScaleItem(description: 'Выраженные', score: 2),
    ],
  };

  @override
  String get description => 'Оценка степени эксикоза';

  @override
  String interpretationResult(num totalScore) {
    return switch (totalScore) {
      < 5 => 'I (Легкая) степень \nПотеря жидксоти 1-3% от массы тела',
      < 9 => 'II (Средняя) степень \nПотеря жидксоти 4-6% от массы тела',

      _ => 'III (Тяжелая) степень \nПотеря жидксоти 7-10% от массы тела',
    };
  }

  @override
  String get name => 'Оценка степени эксикоза';
}
