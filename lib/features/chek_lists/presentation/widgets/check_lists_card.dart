import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/extension/theme_extension.dart';
import 'package:flutter_application_military_directory/features/chek_lists/data/check_list_model.dart';
import 'package:flutter_application_military_directory/features/chek_lists/presentation/screens/check_list_detail_screen.dart';

class CheckListsCard extends StatelessWidget {
  final CheckListModel check;

  const CheckListsCard({super.key, required this.check});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActionsProgressScreen(check: check),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 110,
          child: Card(
            color: context.cardColor,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          check.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          check.category,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        if (check.actions.length < 5)
                          Text(
                            '${check.actions.length} пункта',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 118, 14, 7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
