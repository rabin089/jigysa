import 'package:flutter/material.dart';

class CollaboratorsSection extends StatelessWidget {
  const CollaboratorsSection({super.key});

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
            const Text('Collaborators', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(4, (i) => i).map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(radius: 16, child: Text(String.fromCharCode(65 + i))),
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_alt_1, size: 18),
                  label: const Text('Invite'),
                  style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
