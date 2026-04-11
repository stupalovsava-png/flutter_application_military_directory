//Создание абстарктного класса с формулами

import 'dart:math';

abstract class MedicalFormules {
  //
  String
  get name; //Ч.з геттер потому что необходимо переопределять в Sub.classes
  String get description;
  List<String> get requiredParameters;
  String interpretationResult(dynamic calculate);
  dynamic calculate(Map<String, double> inputs);
  String getParameterLabel(String param);
  String getParameterUnits(String param);
}

//Индекс Альговера
class AlgoversIndex implements MedicalFormules {
  // Класс отвечающий за Индекс Альговера
  @override
  String get name => 'Индекс Альговера';
  @override
  String get description => "Шоковый индекс: Пульс/САД ";
  @override
  List<String> get requiredParameters => ["Пульс", "САД"];

  @override
  double calculate(Map<String, double> inputs) {
    final pulsus = inputs['Пульс']!;
    final systolicBloodPressure = inputs['САД']!;
    return double.parse((pulsus / systolicBloodPressure).toStringAsFixed(1));
  }

  @override
  String interpretationResult(var calculate) {
    return switch (calculate) {
      > 1 => ' $calculate Шоковый индекс повышен - требуется срочная помощь!',
      _ => ' $calculate Шоковый индекс в норме',
    };
  }

  @override
  String getParameterLabel(String param) {
    final labels = {
      'Пульс': 'Пульс (уд/мин)',
      'САД': 'Систолическое давление (мм рт.ст.)',
    };
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Пульс': 'уд/мин', 'САД': 'мм рт.ст.'};
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }
}

//ИМТ
class Bmi implements MedicalFormules {
  // Формула для имт хз зачем она в ремке но пока пусть будет
  @override
  String get description => "Вес(кг)/(Рост*Рост)";
  @override
  String get name => "Индекс массы тела";
  @override
  double calculate(Map<String, double> inputs) {
    final double weight = inputs['Вес']!;
    final double height = inputs["Рост"]!;
    return weight / (height * height);
  }

  @override
  List<String> get requiredParameters => ["Вес", "Рост"];

  @override
  String interpretationResult(var calculate) {
    return switch (calculate) {
      < 16 => '${calculate.toStringAsFixed(1)} Выраженный дефицит массы тела',
      < 18.5 => '${calculate.toStringAsFixed(1)} Недостаточная масса тела',
      < 25 => '${calculate.toStringAsFixed(1)} Нормальная масса тела',
      < 30 => '${calculate.toStringAsFixed(1)} Избыточная масса тела',
      < 35 => '${calculate.toStringAsFixed(1)} Ожирение первой степени',
      < 40 => '${calculate.toStringAsFixed(1)} Ожирение второй степени',
      _ => '${calculate.toStringAsFixed(1)} Ожирение третьей степени',
    };
  }

  @override
  String getParameterLabel(String param) {
    final labels = {'Вес': 'Вес (кг)', 'Рост': 'Рост (м)'};
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Вес': 'Вес (кг)', 'Рост': 'Рост (м)'};
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }
}

//Площадь поверхности тела Дюбуа
class BodySurfaceArea implements MedicalFormules {
  @override
  double calculate(Map<String, double> inputs) {
    final double weight = inputs['Вес']!;
    final double height = inputs['Рост']!;
    return 0.007184 * pow(height, 0.725) * pow(weight, 0.425);
  }

  @override
  String get description => "Расчет площади поверхности тела методом Дюбуа";

  @override
  String get name => 'Площадь поверхности тела';

  @override
  List<String> get requiredParameters => ['Вес', 'Рост'];

  @override
  String interpretationResult(var calculate) {
    return switch (calculate) {
      _ => 'Площадь поверхности тела - ${calculate.toStringAsFixed(2)} м2 ',
    };
  }

  @override
  String getParameterLabel(String param) {
    final labels = {'Вес': 'Вес (кг)', 'Рост': 'Рост (см)'};
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Вес': 'Вес (кг)', 'Рост': 'Рост (см)'};
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }
}

class MeanAp implements MedicalFormules {
  @override
  double calculate(Map<String, double> inputs) {
    final double sap = inputs['Систолическое артериальное давление']!;
    final double dap = inputs['Диастолическое артериальное давление']!;
    return (1 / 3 * sap + 2 / 3 * dap).roundToDouble();
  }

  @override
  String get description => 'Формула для расчета среднего давления';

  @override
  String getParameterLabel(String param) {
    final labels = {
      'Систолическое давление': 'Систолическое давление.',
      'Диастолическое давление': 'Диастолическое давление.',
    };
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {
      'Систолическое давление': 'мм.рт.ст.',
      'Диастолическое давление': 'мм.рт.ст.',
    };
    return units[param] ?? '';
  }

  @override
  String interpretationResult(var calculate) {
    return switch (calculate) {
      _ =>
        '${calculate.toStringAsFixed(0)} мм.рт.ст - среднее артериальное давление',
    };
  }

  @override
  String get name => 'Среднее артериальное давление';

  @override
  List<String> get requiredParameters => [
    'Систолическое артериальное давление',
    'Диастолическое артериальное давление',
  ];
}

class MeanHydro extends MedicalFormules {
  @override
  double calculate(Map<String, double> inputs) {
    final double weight = inputs['Вес']!;
    if (weight <= 10) {
      return weight * 4 * 24;
    } else if (weight <= 20) {
      return (10 * 4 * 24 + ((weight - 10) * 2 * 24));
    } else {
      return 10 * 4 * 24 + (10 * 2 * 24) + ((weight - 20) * 1 * 24);
    }
  }

  @override
  String get description =>
      'Расчет объема внутривенной инфузионной терапии для обеспечения физиологической потребности в жидкости по правилу 4-2-1';

  @override
  String getParameterLabel(String param) {
    final labels = {'Вес': 'Вес'};
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Вес': 'кг'};
    return units[param] ?? '';
  }

  @override
  String interpretationResult(var calculate) {
    return switch (calculate) {
      _ =>
        'Суточный объем жидкости ${calculate.toStringAsFixed(0)} мл \nОбъем поддержания ${(calculate / 24).toStringAsFixed(0)} мл в час',
    };
  }

  @override
  String get name => 'Физиологическая потребность в жидкости';

  @override
  List<String> get requiredParameters => ['Вес'];
}

class BelkiPoMochevine extends MedicalFormules {
  @override
  double calculate(Map<String, double> inputs) {
    final double mochevina = inputs['Мочевина мочи']!;
    final double diurez = inputs['Суточный диурез']!;
    return (mochevina * (diurez / 1000) * 0.033 + 7) * 6.25;
  }

  @override
  String get description =>
      'Суточная потребность в белке по уровню экскреции мочевины с мочой';

  @override
  String getParameterLabel(String param) {
    final labels = {
      'Мочевина мочи': 'Мочевина мочи',
      'Суточный диурез': 'Суточный диурез',
    };
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Мочевина мочи': 'ммоль/л)', 'Суточный диурез': 'мл'};
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }

  @override
  String interpretationResult(var calculate) {
    return switch (calculate) {
      _ => 'Суточная потребность в белке - ${calculate.toStringAsFixed(0)} г.',
    };
  }

  @override
  String get name => 'Суточная потребность в белке';

  @override
  List<String> get requiredParameters => ['Мочевина мочи', 'Суточный диурез'];
}

class Acidoz extends MedicalFormules {
  @override
  double calculate(Map<String, double> inputs) {
    final double weight = inputs['Масса тела']!;
    final double be = inputs['Дефицит оснований (BE)']!;
    return be * weight * 0.3;
  }

  @override
  String get description =>
      'Расчет необходимого количества гидрокарбоната для коррекции метаболического ацидоза по формуле Мелленгаарда-Аструпа (Mellengaard-Astrup)';

  @override
  String getParameterLabel(String param) {
    final labels = {
      'Масса тела': 'Масса тела',
      'Дефицит оснований (BE)': 'Дефицит оснований (BE)(ВВОДИТЬ БЕЗ -)',
    };
    return labels[param] ?? param;
  }

  @override
  String getParameterUnits(String param) {
    final units = {'Масса тела': 'кг', 'Дефицит оснований (BE)': 'ммоль/л'};
    return units[param] ?? ''; // Возвращаем единицы измерения или пустую строку
  }

  @override
  String interpretationResult(calculate) {
    return switch (calculate) {
      _ =>
        '$calculate ммоль NaHCO3 \n ${(calculate).toStringAsFixed(0)} мл 8.4% NaHCO3 \n ${(calculate * 2.1).toStringAsFixed(0)} мл 4% NaHCO3',
    };
  }

  @override
  String get name => 'Расчет количества гидрокарбоната ';

  @override
  List<String> get requiredParameters => [
    'Масса тела',
    'Дефицит оснований (BE)',
  ];
}
