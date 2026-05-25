import 'package:flutter/material.dart';
import 'common.dart';

class BasicInfoCard extends StatelessWidget {
  final TextEditingController fullName;
  final TextEditingController username;
  final TextEditingController bio;
  final TextEditingController role;
  final TextEditingController location;
  const BasicInfoCard({
    super.key,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.role,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Basic Info',
      child: Column(
        children: [
          LabeledField(
            label: 'Full name',
            controller: fullName,
            hint: 'Your name',
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: 'Username',
            controller: username,
            hint: '@username',
            prefix: const Icon(Icons.alternate_email, size: 18),
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
              ),
              child: Text('Public', style: Theme.of(context).textTheme.labelSmall),
            ),
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: 'Bio',
            controller: bio,
            hint: 'A short description about you',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Role', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    PillInput(icon: Icons.work_outline, placeholder: 'Your role', controller: role),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    PillInput(icon: Icons.location_on_outlined, placeholder: 'City, Country', controller: location),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
