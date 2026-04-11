import 'dart:math';

abstract class Sacels {
  //Абстрактный класс мед шкал
  String get name;
  String get description;
  List<String>
  get requiredParameters; //  Отвечают у нас за те параметры которые нужно вводить
  Map<String, List<SacaleItem>>
  get components; //Отвечают за те параметры которые нужно выбирать
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  );
  String getParameterLabel(String param);
  String getParameterUnits(String param);
  String interpretationResult(double totalScore);
}

class SacaleItem {
  //Подкласс Шакальных значений
  final String description;
  final num score;
  const SacaleItem({required this.description, required this.score});
  //Перегрузка оператора для сравнений
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SacaleItem &&
        other.description == description &&
        other.score == score;
  }

  // Переопределяем hashCode
  @override
  int get hashCode => description.hashCode ^ score.hashCode;
}

class Pesi implements Sacels {
  @override
  String get name => 'Шкала PESI';
  @override
  String get description =>
      "Индекс тяжести тромбоэмболии легочной артерии для оценки 30-дневной смертности";

  @override
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  ) {
    double totalScore = 0;

    // Добавляем возраст (баллы = возраст в годах)
    final age = inputs['Возраст'] ?? 0;
    totalScore += age;
    // Добавляем баллы из выбранных пунктов
    for (final item in selectedItems.values) {
      totalScore += item.score;
    }

    return totalScore;
  }

  @override
  List<String> get requiredParameters => ['Возраст'];

  @override
  Map<String, List<SacaleItem>> get components => {
    'Мужской пол': [
      SacaleItem(description: 'Да', score: 10),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Онкологическое заболевание': [
      SacaleItem(description: 'Да', score: 30),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Хроническая сердечная недостаточность': [
      SacaleItem(description: 'Да', score: 10),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Хроническое заболевание легких': [
      SacaleItem(description: 'Да', score: 10),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'ЧСС ≥ 110 уд/мин': [
      SacaleItem(description: 'Да', score: 20),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Систолическое АД < 100 мм рт.ст.': [
      SacaleItem(description: 'Да', score: 30),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Частота дыхания > 30 в мин': [
      SacaleItem(description: 'Да', score: 20),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Температура < 36°C': [
      SacaleItem(description: 'Да', score: 20),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Нарушение сознания': [
      SacaleItem(description: 'Да', score: 60),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Сатурация кислорода < 90%': [
      SacaleItem(description: 'Да', score: 20),
      SacaleItem(description: 'Нет', score: 0),
    ],
  };

  @override
  String interpretationResult(double totalScore) {
    if (totalScore < 66) {
      return 'I класс: Низкий риск ($totalScore баллов) \n• 30-дневная смертность: 0-1.6%';
    } else if (totalScore >= 66 && totalScore <= 85) {
      return 'II класс: Низкий-умеренный риск ($totalScore баллов) \n• 30-дневная смертность: 1.7-3.5%';
    } else if (totalScore >= 86 && totalScore <= 105) {
      return 'III класс: Умеренный риск (${totalScore.toStringAsFixed(1)} баллов) \n• 30-дневная смертность: 3.2-7.1%';
    } else if (totalScore >= 106 && totalScore <= 125) {
      return 'IV класс: Высокий риск ($totalScore баллов) \n• 30-дневная смертность: 4.0-11.4%';
    } else {
      return 'V класс: Очень высокий риск ($totalScore баллов) \n• 30-дневная смертность: 10.0-24.5%';
    }
  }

  @override
  String getParameterLabel(String param) {
    final labels = {'Возраст': 'Возраст'};
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Возраст': 'Лет'};
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }
}

// Класс для расчета скорости клубочковой фильтрации по формуле CKD-EPI
class CKDEPIFormula extends Sacels {
  @override
  String get name => "Формула CKD-EPI";

  @override
  String get description =>
      "Расчет скорости клубочковой фильтрации (СКФ) "
      "по формуле CKD-EPI на основе уровня креатинина, возраста, пола и расы.";

  @override
  List<String> get requiredParameters => ["Креатинин", "Возраст"];

  @override
  Map<String, List<SacaleItem>> get components => {
    "Пол": [
      SacaleItem(description: "Мужской", score: 1),
      SacaleItem(description: "Женский", score: 0),
    ],
    "Раса": [
      SacaleItem(description: "Европеоидная/азиатская", score: 0),
      SacaleItem(description: "Афроамериканская", score: 1),
    ],
    "Единицы измерения креатинина": [
      SacaleItem(description: "мг/дл", score: 0),
      SacaleItem(description: "мкмоль/л", score: 1),
    ],
  };

  @override
  String getParameterLabel(String param) {
    switch (param) {
      case "Креатинин":
        return "Уровень креатинина в крови";
      case "Возраст":
        return "Возраст пациента";
      default:
        return param;
    }
  }

  @override
  String getParameterUnits(String param) {
    switch (param) {
      case "Креатинин":
        return ""; // Единицы будут отображаться в выпадающем списке
      case "Возраст":
        return "лет";
      default:
        return "";
    }
  }

  @override
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  ) {
    double creatinine = inputs["Креатинин"]!;
    final age = inputs["Возраст"]!;
    final isMale = selectedItems["Пол"]?.score == 1;
    final isBlack = selectedItems["Раса"]?.score == 1;
    final isMcmol = selectedItems["Единицы измерения креатинина"]?.score == 1;

    // Конвертируем мкмоль/л в мг/дл при необходимости
    if (isMcmol) {
      creatinine = creatinine / 88.4; // Коэффициент перевода
    }

    // Формула CKD-EPI
    double k = isMale ? 0.9 : 0.7;
    double a = isMale ? -0.302 : -0.241;
    double multiplier = isMale ? 1.0 : 1.012;

    if (isBlack) {
      multiplier *= 1.159;
    }

    double scr = creatinine / k;
    double minVal = min(scr, 1.0);
    double maxVal = max(scr, 1.0);

    return 141 *
        pow(minVal, a) *
        pow(maxVal, -1.209) *
        pow(0.993, age) *
        multiplier;
  }

  @override
  String interpretationResult(double totalScore) {
    if (totalScore >= 90) {
      return "Нормальная или высокая СКФ (1 стадия ХБП). \n•СКФ: ${totalScore.toStringAsFixed(2)} мл/мин/1.73м² \n•Контроль факторов риска, здоровый образ жизни";
    } else if (totalScore >= 60) {
      return "Незначительно сниженная СКФ (2 стадия ХБП). \n•СКФ: ${totalScore.toStringAsFixed(2)} мл/мин/1.73м² \n•Контроль АД, ограничение соли, регулярное наблюдение";
    } else if (totalScore >= 45) {
      return "Умеренно сниженная СКФ (3а стадия ХБП). \n•СКФ: ${totalScore.toStringAsFixed(2)} мл/мин/1.73м² \n•Консультация нефролога, коррекция лекарственной терапии";
    } else if (totalScore >= 30) {
      return "Умеренно-тяжелое снижение СКФ (3б стадия ХБП). \n•СКФ: ${totalScore.toStringAsFixed(2)} мл/мин/1.73м² \n•Консультация нефролога, коррекция лекарственной терапии";
    } else if (totalScore >= 15) {
      return "Значительно сниженная СКФ (4 стадия ХБП). \n•СКФ: ${totalScore.toStringAsFixed(2)} мл/мин/1.73м² \n•Подготовка к заместительной почечной терапии";
    } else {
      return "Терминальная хроническая болезнь почек (5 стадия ХБП). \n•СКФ: ${totalScore.toStringAsFixed(2)} мл/мин/1.73м² \n•Заместительная почечная терапия (диализ/трансплантация)";
    }
  }
}

//Формула Крофт Голта для клиренса креатинина
class CroftGaultFormula extends Sacels {
  @override
  String get name => "Формула Крофта-Голта";

  @override
  String get description =>
      "Расчет клиренса креатинина по формуле Крофта-Голта "
      "на основе уровня креатинина, возраста, пола и массы тела.";

  @override
  List<String> get requiredParameters => ["Креатинин", "Возраст", "Масса тела"];

  @override
  Map<String, List<SacaleItem>> get components => {
    "Пол": [
      SacaleItem(description: "Мужской", score: 1),
      SacaleItem(
        description: "Женский",
        score: 0.85,
      ), // Коэффициент 0.85 для женщин
    ],
    "Единицы измерения креатинина": [
      SacaleItem(description: "мг/дл", score: 0),
      SacaleItem(description: "мкмоль/л", score: 1),
    ],
  };

  @override
  String getParameterLabel(String param) {
    switch (param) {
      case "Креатинин":
        return "Уровень креатинина в крови";
      case "Возраст":
        return "Возраст пациента";
      case "Масса тела":
        return "Масса тела пациента";
      default:
        return param;
    }
  }

  @override
  String getParameterUnits(String param) {
    switch (param) {
      case "Креатинин":
        return ""; // Единицы будут отображаться в выпадающем списке
      case "Возраст":
        return "лет";
      case "Масса тела":
        return ""; // Единицы будут отображаться в выпадающем списке
      default:
        return "";
    }
  }

  @override
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  ) {
    double creatinine = inputs["Креатинин"]!;
    final age = inputs["Возраст"]!;
    double weight = inputs["Масса тела"]!;

    final genderCoefficient = selectedItems["Пол"]?.score ?? 1.0;
    final isMcmol = selectedItems["Единицы измерения креатинина"]?.score == 1;

    // Конвертируем мкмоль/л в мг/дл при необходимости
    if (isMcmol) {
      creatinine = creatinine / 88.4;
    }

    // Конвертируем фунты в кг при необходимости

    // Формула Крофта-Голта
    return ((140 - age) * weight * genderCoefficient) / (72 * creatinine);
  }

  @override
  String interpretationResult(double totalScore) {
    if (totalScore >= 90) {
      return "Нормальный клиренс креатинина. Значение: ${totalScore.toStringAsFixed(2)} мл/мин";
    } else if (totalScore >= 60) {
      return "Легкое снижение клиренса креатинина. Значение: ${totalScore.toStringAsFixed(2)} мл/мин";
    } else if (totalScore >= 30) {
      return "Умеренное снижение клиренса креатинина. Значение: ${totalScore.toStringAsFixed(2)} мл/мин";
    } else if (totalScore >= 15) {
      return "Выраженное снижение клиренса креатинина. Значение: ${totalScore.toStringAsFixed(2)} мл/мин";
    } else {
      return "Тяжелое снижение клиренса креатинина. Значение: ${totalScore.toStringAsFixed(2)} мл/мин";
    }
  }

  // Дополнительный метод для оценки функции почек
  String getRenalFunction(double clearance) {
    if (clearance >= 90) return "Нормальная функция почек";
    if (clearance >= 60) return "Легкое нарушение функции почек";
    if (clearance >= 30) return "Умеренное нарушение функции почек";
    if (clearance >= 15) return "Тяжелое нарушение функции почек";
    return "Терминальная почечная недостаточность";
  }

  // Дополнительный метод для коррекции дозировок лекарств
  String getDosageAdjustment(double clearance) {
    if (clearance >= 50) {
      return "Коррекция дозы не требуется";
    } else if (clearance >= 30) {
      return "Умеренная коррекция дозы (75% от обычной дозы)";
    } else if (clearance >= 10) {
      return "Значительная коррекция дозы (50% от обычной дозы)";
    } else {
      return "Максимальная коррекция дозы (25% от обычной дозы или отмена)";
    }
  }
}

class CBV extends Sacels {
  @override
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  ) {
    double totalScore = 0;
    final weight = inputs['Масса тела'] ?? 0;
    for (final item in selectedItems.values) {
      totalScore += item.score;
    }
    totalScore *= weight;
    return totalScore * 10;
  }

  @override
  Map<String, List<SacaleItem>> get components => {
    "Пол": [
      SacaleItem(description: "Мужской", score: 7),
      SacaleItem(description: "Женский", score: 6.5),
    ],
  };

  @override
  String get description => 'Формула для расчета объема циркулирующей крови';

  @override
  String getParameterLabel(String param) {
    final labels = {'Масса тела': 'Вес'};
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Масса тела': 'Кг'};
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }

  @override
  String interpretationResult(double totalScore) {
    return "Приблизительный объем ОЦК в мл";
  }

  @override
  String get name => "Формула ОЦК";

  @override
  List<String> get requiredParameters => ['Масса тела'];
}

class GraceScale extends Sacels {
  @override
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  ) {
    double totalScore = 0;
    final heartRate = inputs['ЧСС']!;
    switch (heartRate) {
      case < 50:
        totalScore += 0;
        break;
      case < 70:
        totalScore += 3;
        break;
      case < 90:
        totalScore += 9;
        break;
      case < 110:
        totalScore += 15;
        break;
      case < 150:
        totalScore += 24;
        break;
      case < 200:
        totalScore += 38;
        break;
      default:
        totalScore += 46;
    }

    final sap = inputs['САД']!;
    switch (sap) {
      case < 80:
        totalScore += 63;
        break;
      case < 100:
        totalScore += 58;
        break;
      case < 120:
        totalScore += 47;
        break;
      case < 140:
        totalScore += 37;
        break;
      case < 160:
        totalScore += 26;
        break;
      case < 180:
        totalScore += 11;
        break;
      case < 200:
        totalScore += 0;
        break;
      default:
        totalScore += 0;
    }

    final age = inputs['Возраст']!;
    switch (age) {
      case < 30:
        totalScore += 0;
        break;
      case < 40:
        totalScore += 8;
        break;
      case < 50:
        totalScore += 25;
        break;
      case < 60:
        totalScore += 41;
        break;
      case < 70:
        totalScore += 58;
        break;
      case < 80:
        totalScore += 75;
        break;
      case < 90:
        totalScore += 91;
        break;
      default:
        totalScore += 100;
    }

    final creatinine = inputs['Уровень креатинина в крови']!;
    switch (creatinine) {
      case < 0.35:
        totalScore += 1;
        break;
      case < 0.70:
        totalScore += 4;
        break;
      case < 1.05:
        totalScore += 7;
        break;
      case < 1.40:
        totalScore += 10;
        break;
      case < 1.75:
        totalScore += 13;
        break;
      case < 2.10:
        totalScore += 21;
        break;
      case < 2.45:
        totalScore += 28;
        break;
      case < 2.80:
        totalScore += 35;
        break;
      default:
        totalScore += 42;
    }

    // Добавляем баллы за выбранные компоненты
    totalScore +=
        selectedItems['Остановка сердца при поступлении']?.score.toDouble() ??
        0;
    totalScore +=
        selectedItems['Смещение сегмента ST инверсия зубца T']?.score
            .toDouble() ??
        0;
    totalScore +=
        selectedItems['Повышенный уровень маркеров некроза миокарда в крови']
            ?.score
            .toDouble() ??
        0;
    totalScore += selectedItems['Класс по Killip']?.score.toDouble() ?? 0;

    return totalScore;
  }

  @override
  Map<String, List<SacaleItem>> get components => {
    'Остановка сердца при поступлении': [
      SacaleItem(description: 'Да', score: 39),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Смещение сегмента ST инверсия зубца T': [
      SacaleItem(description: 'Да', score: 28),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Повышенный уровень маркеров некроза миокарда в крови': [
      SacaleItem(description: 'Да', score: 14),
      SacaleItem(description: 'Нет', score: 0),
    ],
    'Класс по Killip': [
      SacaleItem(
        description: 'I класс нет признаков сердечной недостаточности',
        score: 0,
      ),
      SacaleItem(
        description: 'II класс влажные хрипы в нижних отделах, III тон',
        score: 20,
      ),
      SacaleItem(
        description: 'III класс отек легких хрипы выше уровня лопаток',
        score: 39,
      ),
      SacaleItem(description: 'IV класс кардиогенный шок', score: 59),
    ],
  };

  @override
  String get description =>
      'Шкала GRACE для оценки риска летальности и развития инфаркта миокарда';

  @override
  String getParameterLabel(String param) {
    final labels = {
      'Возраст': 'Возраст',
      'ЧСС': 'ЧСС',
      'САД': 'САД',
      'Уровень креатинина в крови': "Уровень креатинина в крови",
    };
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {
      'Возраст': 'Лет',
      'ЧСС': 'уд/мин',
      'САД': 'мм.рт.ст.',
      'Уровень креатинина в крови': "мг/дл",
    };
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }

  @override
  String interpretationResult(double totalScore) {
    if (totalScore < 100) {
      return 'НИЗКИЙ РИСК\nРиск смерти в течение 6 месяцев: <3%\n'
          'Тактика: стандартное лечение, возможна ранняя выписка';
    } else if (totalScore < 125) {
      return 'СРЕДНИЙ РИСК\nРиск смерти в течение 6 месяцев: 3-8%\n'
          'Тактика: госпитализация, интенсивное медикаментозное лечение';
    } else if (totalScore < 155) {
      return 'ВЫСОКИЙ РИСК\nРиск смерти в течение 6 месяцев: 8-16%\n'
          'Тактика: срочная госпитализация в ОРИТ, рассмотреть инвазивную стратегию';
    } else {
      return 'ОЧЕНЬ ВЫСОКИЙ РИСК\nРиск смерти в течение 6 месяцев: >16%\n'
          'Тактика: экстренная госпитализация в реанимацию, немедленная инвазивная стратегия';
    }
  }

  @override
  String get name => 'Шкала Грейс';

  @override
  List<String> get requiredParameters => [
    'Возраст',
    'ЧСС',
    'САД',
    'Уровень креатинина в крови',
  ];
}

class Nutrition extends Sacels {
  @override
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  ) {
    double totalScore = 0;
    final weight = inputs['Масса тела'] ?? 0;
    for (final item in selectedItems.values) {
      totalScore += item.score;
    }
    totalScore *= weight;
    return totalScore;
  }

  @override
  Map<String, List<SacaleItem>> get components => {
    "Пол": [
      SacaleItem(description: "Плановая операция (до операции)", score: 1),
      SacaleItem(description: "После плановой операции", score: 1.2),
      SacaleItem(description: "Послеоперационные осложнения", score: 1.3),
      SacaleItem(description: "Тяжелая политравма", score: 1.8),
      SacaleItem(description: "Сепсис", score: 1.8),
      SacaleItem(description: "Септический шок", score: 2),
      SacaleItem(description: "Ожоги (>20% тела)", score: 2.3),
      SacaleItem(description: "Острая почечная недостаточность", score: 1.2),
      SacaleItem(description: "ЗПТ (гемодиализ)", score: 1.7),
      SacaleItem(description: "Печеночная недостаточность", score: 1.2),
      SacaleItem(description: "Гериатрические пациенты (>70 лет)", score: 1.2),
    ],
  };

  @override
  String get description =>
      'Формула для расчета суточной потребности пациента в белках ';

  @override
  String getParameterLabel(String param) {
    final labels = {'Масса тела': 'Вес'};
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Масса тела': 'Кг'};
    return units[param] ?? '';
  }

  @override
  String interpretationResult(double totalScore) {
    return "Приблизительный в белках г/сут";
  }

  @override
  String get name => "Потребность в белках";

  @override
  List<String> get requiredParameters => ['Масса тела'];
}

class PerspirationLosses extends Sacels {
  @override
  String get name => 'Перспирационные потери';

  @override
  String get description =>
      'Расчет суточных перспирационных потерь жидкости с учетом лихорадки, '
      'тахипноэ, ИВЛ и ожогов';

  @override
  List<String> get requiredParameters => ['Масса тела', 'Температура тела'];

  @override
  Map<String, List<SacaleItem>> get components => {
    'Тахипноэ': [
      SacaleItem(description: 'Нет (ЧДД < 20)', score: 0),
      SacaleItem(description: 'Умеренное (ЧДД 20-30)', score: 0.4),
      SacaleItem(description: 'Выраженное (ЧДД > 30)', score: 0.6),
    ],
    'Искусственная вентиляция легких': [
      SacaleItem(description: 'Нет', score: 0),
      SacaleItem(description: 'Да', score: 400),
    ],
    'Ожоги': [
      SacaleItem(description: 'Нет', score: 0),
      SacaleItem(description: 'До 10% тела', score: 2.0),
      SacaleItem(description: '10-20% тела', score: 2.5),
      SacaleItem(description: '20-30% тела', score: 3.0),
      SacaleItem(description: 'Более 30% тела', score: 3.5),
    ],
  };

  @override
  String getParameterLabel(String param) {
    switch (param) {
      case 'Масса тела':
        return 'Масса тела пациента';
      case 'Температура тела':
        return 'Температура тела';
      default:
        return param;
    }
  }

  @override
  String getParameterUnits(String param) {
    switch (param) {
      case 'Масса тела':
        return 'кг';
      case 'Температура тела':
        return '°C';
      default:
        return '';
    }
  }

  @override
  double calculate(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
  ) {
    final weight = inputs['Масса тела'] ?? 0;
    final bodyTemp = inputs['Температура тела'] ?? 37.0;

    // Базовые перспирационные потери
    double baseLosses = 15 * weight;

    // Коррекция на лихорадку
    double feverCorrection = 0;
    if (bodyTemp > 37) {
      feverCorrection = 500 * (bodyTemp - 37);
    }

    // Коррекция на тахипноэ
    double tachypneaCorrection = 0;
    final tachypneaScore = selectedItems['Тахипноэ']?.score ?? 0;
    if (tachypneaScore > 0) {
      tachypneaCorrection = baseLosses * tachypneaScore;
    }

    // Коррекция на ИВЛ
    final ivlCorrection =
        selectedItems['Искусственная вентиляция легких']?.score ?? 0;

    // Коррекция на ожоги
    double burnsCorrection = 0;
    final burnsScore = selectedItems['Ожоги']?.score ?? 0;
    if (burnsScore > 0) {
      burnsCorrection =
          burnsScore * weight * 10; // Умножаем на 10 для перевода в мл
    }

    // Общий расчет
    double totalLosses =
        baseLosses +
        feverCorrection +
        tachypneaCorrection +
        ivlCorrection +
        burnsCorrection;

    return totalLosses;
  }

  @override
  String interpretationResult(double totalScore) {
    if (totalScore < 1500) {
      return 'Нормальные перспирационные потери\n'
          '• Объем: ${totalScore.toStringAsFixed(0)} мл/сутки\n'
          '• Рекомендации: стандартный питьевой режим';
    } else if (totalScore < 2500) {
      return 'Умеренно повышенные перспирационные потери\n'
          '• Объем: ${totalScore.toStringAsFixed(0)} мл/сутки\n'
          '• Рекомендации: увеличить потребление жидкости на 500-1000 мл';
    } else if (totalScore < 4000) {
      return 'Значительно повышенные перспирационные потери\n'
          '• Объем: ${totalScore.toStringAsFixed(0)} мл/сутки\n'
          '• Рекомендации: интенсивная регидратация, контроль электролитов';
    } else {
      return 'Критически высокие перспирационные потери\n'
          '• Объем: ${totalScore.toStringAsFixed(0)} мл/сутки\n'
          '• Рекомендации: срочная медицинская помощь, парентеральная регидратация';
    }
  }

  // Дополнительный метод для получения детализированного отчета
  String getDetailedReport(
    Map<String, double> inputs,
    Map<String, SacaleItem> selectedItems,
    double totalScore,
  ) {
    final weight = inputs['Масса тела'] ?? 0;
    final bodyTemp = inputs['Температура тела'] ?? 37.0;

    String report = 'ДЕТАЛИЗИРОВАННЫЙ РАСЧЕТ ПЕРСПИРАЦИОННЫХ ПОТЕРЬ:\n\n';

    report +=
        '• Базовые потери (15 мл/кг): ${(15 * weight).toStringAsFixed(0)} мл\n';

    if (bodyTemp > 37) {
      report +=
          '• Лихорадка (${bodyTemp.toStringAsFixed(1)}°C): ${(500 * (bodyTemp - 37)).toStringAsFixed(0)} мл\n';
    }

    final tachypneaScore = selectedItems['Тахипноэ']?.score ?? 0;
    if (tachypneaScore > 0) {
      report +=
          '• Тахипноэ: ${(15 * weight * tachypneaScore).toStringAsFixed(0)} мл\n';
    }

    final ivlCorrection =
        selectedItems['Искусственная вентиляция легких']?.score ?? 0;
    if (ivlCorrection > 0) {
      report += '• ИВЛ: ${ivlCorrection.toStringAsFixed(0)} мл\n';
    }

    final burnsScore = selectedItems['Ожоги']?.score ?? 0;
    if (burnsScore > 0) {
      report +=
          '• Ожоги: ${(burnsScore * weight * 10).toStringAsFixed(0)} мл\n';
    }

    report += '\nОБЩИЙ ОБЪЕМ: ${totalScore.toStringAsFixed(0)} мл/сутки';

    return report;
  }
}
