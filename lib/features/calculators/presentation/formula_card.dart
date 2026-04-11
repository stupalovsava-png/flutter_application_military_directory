import 'package:flutter/material.dart';

class FormulaCard extends StatefulWidget {
  final dynamic calculation;
  final VoidCallback onTap;

  const FormulaCard({
    super.key,
    required this.calculation,
    required this.onTap,
  });

  @override
  State<FormulaCard> createState() => _FormulaCardState();
}

class _FormulaCardState extends State<FormulaCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(widget.calculation.name),
        subtitle: Text(widget.calculation.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [const Icon(Icons.chevron_right)],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
