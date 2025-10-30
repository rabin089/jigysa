import 'package:flutter/material.dart';
import '../../ideas/models/idea.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const IdeaCard({
    super.key,
    required this.idea,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Title
            Text(
              idea.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            // Header: avatar, name, time, tag chip
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: (idea.authorAvatarUrl != null && idea.authorAvatarUrl!.isNotEmpty)
                      ? NetworkImage(idea.authorAvatarUrl!)
                      : null,
                  child: (idea.authorAvatarUrl == null || idea.authorAvatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 18)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        idea.authorName ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _friendlyTime(idea.createdAt),
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (idea.tag != null && idea.tag!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F0FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      idea.tag!,
                      style: const TextStyle(color: Color(0xFF4F8BFF), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Cover image
            if (idea.imageUrl != null && idea.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    idea.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 12),

           
            const SizedBox(height: 6),

            // Description (2 lines)
            Text(
              idea.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 10),
            // Actions row
            Row(
              children: [
                _iconStat(Icons.favorite_border, idea.likes.toString(), onLike),
                const SizedBox(width: 16),
                _iconStat(Icons.mode_comment_outlined, idea.comments.toString(), onComment),
                const SizedBox(width: 16),
                _iconStat(Icons.share_outlined, idea.shares.toString(), onShare),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onTap,
                  icon: const Icon(Icons.more_horiz),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _iconStat(IconData icon, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade800),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }

  String _friendlyTime(DateTime? time) {
    if (time == null) return 'Just now';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    return '${diff.inDays} d';
  }
}
