class CheckListModel {
  final int id;
  final String title;
  final String category;
  final List<String> actions;
  CheckListModel({
    required this.id,
    required this.actions,
    required this.category,
    required this.title,
  });
}
