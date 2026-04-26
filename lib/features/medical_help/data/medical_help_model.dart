import 'package:flutter/material.dart';

class MedicalHelpModel {
  final String title;
  final FirstDocHelp firstDocHelp;
  final QualfDocHelp qualfDocHelp;
  final SpecialfDocHelp specialDocHelp;
  MedicalHelpModel({
    required this.title,
    required this.firstDocHelp,
    required this.qualfDocHelp,
    required this.specialDocHelp,
  });
}

class FirstDocHelp {
  // static const String = 'Первая врачебная помощь';
  final String place;
  final Activities acivities;
  final String evacuation;
  final String sort;

  FirstDocHelp({
    required this.sort,
    required this.place,
    required this.acivities,
    required this.evacuation,
  });
}

class QualfDocHelp {
  final String place;
  final String sort;

  final Activities acivities;
  final String evacuation;

  QualfDocHelp({
    required this.place,
    required this.acivities,
    required this.evacuation,
    required this.sort,
  });
}

class Activities {
  final String title;
  String toDoList;
  String additinal;

  Activities({
    required this.title,
    required this.toDoList,
    required this.additinal,
  });
}

class SpecialfDocHelp {
  final String place;
  final String sort;

  final Activities acivities;
  final String evacuation;

  SpecialfDocHelp({
    required this.place,
    required this.acivities,
    required this.evacuation,
    required this.sort,
  });
}
