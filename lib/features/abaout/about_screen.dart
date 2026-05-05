import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/navigation/router/app_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'О приложении',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => appRouter.go('/main'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
              'Приложение "Войсковой врач" разработано с целью помочь всем людям, которые связали свою жизнь с этой нелегкой профессией. Мы предлагаем широкий спектр инструментов, которые охватывают различные аспекты военной медицины. Наша миссия — предоставить пользователям полезные инструменты для облегчения и улучшения качества работы.',
              style: TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // здесь может быть иконка или изображение
            const Spacer(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Автор приложения: Комаров Николай Николавич',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    'Разработчик приложения: Ступалов Савелий Алексеевич',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
