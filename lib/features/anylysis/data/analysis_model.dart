class UnitModel {
  final String name;
  final double min;
  final double max;

  UnitModel({required this.name, required this.min, required this.max});
}

enum AnalysisCategory {
  urine,
  biochemicalBlood,
  bloodGas,
  hormones,
  immunology,
  clinicalBlood,
  coagulogram,
  coprogram,
}

class AnalysisModel {
  final int id;
  final String title;
  final List<UnitModel> units;
  final UnitModel standartUnit;
  final AnalysisCategory category;

  AnalysisModel({
    required this.id,
    required this.title,
    required this.units,
    required this.standartUnit,
    required this.category,
  });
}
