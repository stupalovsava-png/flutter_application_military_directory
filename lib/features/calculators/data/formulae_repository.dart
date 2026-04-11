import 'package:flutter_application_military_directory/features/calculators/data/formules_data.dart';
import 'package:flutter_application_military_directory/features/calculators/data/sacales_data.dart';
import 'package:flutter_application_military_directory/features/calculators/data/scales_data.dart';

class FormulaRepository {
  final List<MedicalFormules> _formulasList = [
    AlgoversIndex(),
    Bmi(),
    BodySurfaceArea(),
    MeanAp(),
    MeanHydro(),
    BelkiPoMochevine(),
    Acidoz(),
  ];

  // Метод хранящий в себе все шкалы
  final List<MedicalScale> _scalesList = [
    GlasgowComaScale(),
    QSofaScale(),
    SofaScale(),
    Apache2Scale(),
    ApgarScale(),
    PewsScale(),
    ChildPughScale(),
    NIHSSScale(),
    SmartCoP(),
    Crb65(),
    WellsScale(),
    HasBledScale(),
    GenevaRevisedScale(),
    CapriniScale(),
    VillaltaScale(),
    AkvoradoScale(),
    CHA2DS2(),
    Dehidrotation(),
  ];
  final List<Sacels> _saclesList = [
    Pesi(),
    CKDEPIFormula(),
    PerspirationLosses(),
    CroftGaultFormula(),
    CBV(),
    GraceScale(),
    Nutrition(),
  ];

  List<dynamic> get allCalculation => [
    ..._formulasList,
    ..._scalesList,
    ..._saclesList,
  ];
}
