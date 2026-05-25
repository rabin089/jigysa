import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onDiscard;
  const ActionBar({super.key, required this.onSave, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: const StadiumBorder()),
            child: const Text('Save Changes'),
          ),
        ),
        const SizedBox(height: 6),
        TextButton(onPressed: onDiscard, child: Text('Discard', style: TextStyle(color: theme.colorScheme.onSurfaceVariant))),
        const SizedBox(height: 8),
      ],
    );
  }
}
