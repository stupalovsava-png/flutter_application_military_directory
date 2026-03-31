import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/data/chek_lists.dart/chek_list_data.dart';
import 'package:flutter_application_military_directory/presentation/widgets/check_lists_card.dart';

class CheckLists extends StatelessWidget {
  const CheckLists({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: checkLists.length,
          itemBuilder: (context, index) {
            final check = checkLists[index];
            return CheckListsCard(check: check);
          },
        ),
      ),
    );
  }
}
