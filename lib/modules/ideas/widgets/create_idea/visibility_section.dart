import 'package:flutter/material.dart';
import 'visibility_option.dart';

class VisibilitySection extends StatelessWidget {
  final VisibilityOption value;
  final ValueChanged<VisibilityOption> onChanged;
  const VisibilitySection({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visibility', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Private'),
                  selected: value == VisibilityOption.private,
                  onSelected: (_) => onChanged(VisibilityOption.private),
                ),
                ChoiceChip(
                  label: const Text('Team'),
                  selected: value == VisibilityOption.team,
                  onSelected: (_) => onChanged(VisibilityOption.team),
                ),
                ChoiceChip(
                  label: const Text('Public'),
                  selected: value == VisibilityOption.public,
                  onSelected: (_) => onChanged(VisibilityOption.public),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
