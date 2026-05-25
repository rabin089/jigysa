import 'package:flutter/material.dart';

class AttachmentsSection extends StatelessWidget {
  final VoidCallback? onPickImage;
  final VoidCallback? onPickFile;
  final VoidCallback? onAddLink;
  const AttachmentsSection({super.key, this.onPickImage, this.onPickFile, this.onAddLink});

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
            const Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Optional: add images, files, or links', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onPickImage,
                  icon: const Icon(Icons.image_outlined, size: 18),
                  label: const Text('Image'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onPickFile,
                  icon: const Icon(Icons.attach_file, size: 18),
                  label: const Text('File'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onAddLink,
                  icon: const Icon(Icons.link, size: 18),
                  label: const Text('Link'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
