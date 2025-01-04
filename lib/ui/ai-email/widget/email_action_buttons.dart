import 'package:bond/global.dart';
import 'package:flutter/material.dart';

class EmailActionsButtons extends StatelessWidget {
  final List<String> actions;
  final void Function(String) onPressed;

  const EmailActionsButtons({
    super.key,
    required this.actions,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          ...actions.map((action) {
            return SizedBox(
              height: 28.0,
              child: TextButton(
                style: outlined,
                onPressed: () => onPressed(action),
                child: Text(
                  action,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
