import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  /// Удобный цвет для обычных карточек (Card)
  Color get cardColor {
    final scheme = Theme.of(this).colorScheme;
    final isDark = Theme.of(this).brightness == Brightness.dark;

    if (isDark) {
      return scheme.surfaceContainerHigh; // в тёмной — чуть подсвеченный
    } else {
      return scheme
          .surfaceContainerLowest; // в светлой — чуть темнее белого, выглядит чисто
    }
  }

  /// Для более "важных" или приподнятых карточек (например, диалоги, выделенные элементы)
  Color get elevatedCardColor {
    final scheme = Theme.of(this).colorScheme;
    final isDark = Theme.of(this).brightness == Brightness.dark;

    return isDark ? scheme.surfaceContainerHighest : scheme.surfaceContainer;
  }

  /// Цвет текста внутри карточки (автоматически контрастный)
  Color get cardTextColor => Theme.of(this).colorScheme.onSurface;
}
