import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/chek_lists/data/check_list_model.dart';
import 'package:flutter_application_military_directory/features/chek_lists/presentation/screens/check_list_detail_screen.dart';

class CheckListsCard extends StatelessWidget {
  final CheckListModel check;

  const CheckListsCard({super.key, required this.check});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(check.title),
          subtitle: Text(check.category),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [const Icon(Icons.chevron_right)],
          ),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionsProgressScreen(check: check),
              ),
            );
          },
        ),
      ),
    );
  }
}
