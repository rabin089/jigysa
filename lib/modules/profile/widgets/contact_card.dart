import 'package:flutter/material.dart';
import 'common.dart';

class ContactCard extends StatelessWidget {
  final TextEditingController email;
  final TextEditingController website;
  const ContactCard({super.key, required this.email, required this.website});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Contact',
      child: Column(
        children: [
          LabeledField(
            label: 'Email',
            controller: email,
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(Icons.email_outlined, size: 18),
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
              ),
              child: Text('Private', style: Theme.of(context).textTheme.labelSmall),
            ),
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: 'Website',
            controller: website,
            hint: 'yourdomain.dev',
            keyboardType: TextInputType.url,
            prefix: const Icon(Icons.link, size: 18),
          ),
        ],
      ),
    );
  }
}
