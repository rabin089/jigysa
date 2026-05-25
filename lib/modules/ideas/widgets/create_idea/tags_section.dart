import 'package:flutter/material.dart';

class TagsSection extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;
  const TagsSection({super.key, required this.tags, required this.onAdd, required this.onRemove});

  @override
  State<TagsSection> createState() => _TagsSectionState();
}

class _TagsSectionState extends State<TagsSection> {
  final _tagCtrl = TextEditingController();

  @override
  void dispose() {
    _tagCtrl.dispose();
    super.dispose();
  }

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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...widget.tags.map((t) => InputChip(
                      label: Text(t),
                      onDeleted: () => widget.onRemove(t),
                    )),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Add tag'),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextField(
                            controller: _tagCtrl,
                            autofocus: true,
                            decoration: const InputDecoration(hintText: 'Enter a tag'),
                            onSubmitted: (_) => Navigator.of(context).pop(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                    final value = _tagCtrl.text.trim();
                    _tagCtrl.clear();
                    if (value.isNotEmpty) widget.onAdd(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
