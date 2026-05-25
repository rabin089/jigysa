import 'package:flutter/material.dart';

class CreateIdeaActions extends StatelessWidget {
  final VoidCallback onPreview;
  final VoidCallback onCreate;
  const CreateIdeaActions({super.key, required this.onPreview, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onPreview,
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: const StadiumBorder()),
            child: const Text('Preview'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onCreate,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: const StadiumBorder()),
            child: const Text('Create Idea'),
          ),
        ),
      ],
    );
  }
}
