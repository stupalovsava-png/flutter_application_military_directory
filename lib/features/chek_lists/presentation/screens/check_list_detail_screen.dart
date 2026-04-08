import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/chek_lists/data/check_list_model.dart';

class ActionsProgressScreen extends StatefulWidget {
  final CheckListModel check; // твой список действий

  const ActionsProgressScreen({super.key, required this.check});

  @override
  State<ActionsProgressScreen> createState() => _ActionsProgressScreenState();
}

class _ActionsProgressScreenState extends State<ActionsProgressScreen> {
  final Set<String> _completedActions = {};

  double get _progress {
    if (widget.check.actions.isEmpty) return 0.0;
    return _completedActions.length / widget.check.actions.length;
  }

  void _toggleAction(String action) {
    setState(() {
      if (_completedActions.contains(action)) {
        _completedActions.remove(action);
      } else {
        _completedActions.add(action);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.check.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Прогресс-бар + текст
            Text(
              'Прогресс: ${(_progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: _progress, // от 0.0 до 1.0
              backgroundColor: Colors.grey[300],
              color: Colors.green.shade700,
              minHeight: 12,
              borderRadius: BorderRadius.circular(8),
            ),

            const SizedBox(height: 32),

            const Text(
              'Список действий:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Список действий
            Expanded(
              child: ListView.builder(
                itemCount: widget.check.actions.length,
                itemBuilder: (context, index) {
                  final action = widget.check.actions[index];
                  final isCompleted = _completedActions.contains(action);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                        size: 28,
                      ),
                      title: Text(
                        action,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: isCompleted
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () => _toggleAction(action),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
