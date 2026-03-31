class DrugModel {
  int id;
  String name;
  String group;
  String latinName;
  String description;
  String sideEffects;
  String form;
  String indications;
  String dosage;
  String contraindications;
  String releaseForm;

  DrugModel({
    required this.description,
    required this.group,
    required this.id,
    required this.latinName,
    required this.name,
    required this.sideEffects,
    required this.form,
    required this.indications,
    required this.contraindications,
    required this.dosage,
    required this.releaseForm,
  });
}
