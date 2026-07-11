class StepCardData {
  final String imagePath; // 'assets/icons/brain.png'
  final String title;
  final String description;

  const StepCardData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

/// Базовый класс протокола — экран строится из списка карточек
class MedicalProtocol {
  final String screenTitle;
  final String? screenSubtitle;
  final List<StepCardData> cards;

  const MedicalProtocol({
    required this.screenTitle,
    this.screenSubtitle,
    required this.cards,
  });
}
