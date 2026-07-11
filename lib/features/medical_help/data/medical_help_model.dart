import 'package:flutter/material.dart';

// ─── Одна группа мероприятий ─────────────────────────────────────────────────
// toDoList — RichText, чтобы поддерживать ссылки и цветовые акценты
// additinal — дополнительный текст (выделяется красным / предупреждение)

class Activities {
  final Text toDoList;
  final String additinal;

  const Activities({required this.toDoList, required this.additinal});
}

// ─── Базовый класс уровня помощи ─────────────────────────────────────────────
// acivities: Map<String, Activities>
//   ключ   — название места/группы («В перевязочной», «Мероприятия», '' …)
//   значение — Activities с RichText и доп. текстом

abstract class Help {
  final String title; // заголовок подраздела (может быть '')
  final String place; // условия оказания помощи
  final String sort; // текст медицинской сортировки
  final Map<String, Activities> acivities;
  final String evacuation; // текст эвакуации

  const Help({
    required this.title,
    required this.place,
    required this.sort,
    required this.acivities,
    required this.evacuation,
  });
}

// ─── 1-й уровень: Первая врачебная в МПб ─────────────────────────────────────

class FirstDocHelpMpb extends Help {
  const FirstDocHelpMpb({
    required super.title,
    required super.place,
    required super.sort,
    required super.acivities,
    required super.evacuation,
  });
}

// ─── 2-й уровень: Первая врачебная в медр бр / ОМедО ─────────────────────────

class FirstDocHelpMedbrig extends Help {
  const FirstDocHelpMedbrig({
    required super.title,
    required super.place,
    required super.sort,
    required super.acivities,
    required super.evacuation,
  });
}

// ─── Квалифицированная помощь ────────────────────────────────────────────────

class QualfDocHelp extends Help {
  const QualfDocHelp({
    required super.title,
    required super.place,
    required super.sort,
    required super.acivities,
    required super.evacuation,
  });
}

// ─── Специализированная помощь ───────────────────────────────────────────────

class SpecialfDocHelp extends Help {
  const SpecialfDocHelp({
    required super.title,
    required super.place,
    required super.sort,
    required super.acivities,
    required super.evacuation,
  });
}

// ─── Корневая модель ─────────────────────────────────────────────────────────

class MedicalHelpModel {
  final String title;
  final FirstDocHelpMpb firstDocHelpMpb;
  final FirstDocHelpMedbrig firstDocHelpMedbrig;
  final QualfDocHelp qualfDocHelp;
  final SpecialfDocHelp specialDocHelp;
  final List<Help> extraStages;

  const MedicalHelpModel({
    required this.title,
    required this.firstDocHelpMpb,
    required this.firstDocHelpMedbrig,
    required this.qualfDocHelp,
    required this.specialDocHelp,
    required this.extraStages,
  });

  /// Все этапы в порядке отображения — удобно для PageView
  List<Help> get stages => [
    firstDocHelpMpb,
    firstDocHelpMedbrig,
    ...extraStages,
    qualfDocHelp,
    specialDocHelp,
  ];

  /// Проверка, что этап содержит полезные данные
  bool _isFilled(Help stage) {
    return stage.sort.isNotEmpty ||
        stage.place.isNotEmpty ||
        stage.acivities.isNotEmpty ||
        stage.evacuation.isNotEmpty;
  }

  /// Возвращает только те этапы, которые имеют контент
  List<Help> get filledStages => stages.where(_isFilled).toList();
}
