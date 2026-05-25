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
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(16);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: Border.all(color: const Color(0xFFE9E9EC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image with category/tag pill
            if ((idea.imageUrl ?? '').isNotEmpty)
              _HeaderImage(
                imageUrl: idea.imageUrl!,
                category: (idea.tag ?? '').isNotEmpty ? idea.tag! : null,
              ),

            const SizedBox(height: 12),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                idea.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 6),

            // Preview/description (2 lines)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                idea.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6F6F79),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 12),

            // Author row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: (idea.authorAvatarUrl ?? '').isNotEmpty
                        ? NetworkImage(idea.authorAvatarUrl!)
                        : null,
                    backgroundColor: const Color(0xFFF3D1D1),
                    child: (idea.authorAvatarUrl ?? '').isEmpty
                        ? const Icon(Icons.person, size: 18, color: Color(0xFF8E4D4D))
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      idea.authorName?.isNotEmpty == true ? idea.authorName! : 'Author',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Date line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                _formatDate(idea.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF9A9AA2),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F4)),

            // Actions row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    _Stat(icon: Icons.favorite_border, count: idea.likes, onTap: onLike),
                    _Stat(icon: Icons.mode_comment_outlined, count: idea.comments, onTap: onComment),
                    const Spacer(),
                    IconButton(
                      onPressed: onShare,
                      icon: const Icon(Icons.ios_share_rounded),
                      tooltip: 'Share',
                    ),
                    IconButton(
                      onPressed: onTap,
                      icon: const Icon(Icons.more_horiz),
                      tooltip: 'More',
                    ),
                  ],
                ),
              ),
            ),
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

class _HeaderImage extends StatelessWidget {
  final String imageUrl;
  final String? category;

  const _HeaderImage({required this.imageUrl, this.category});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 11,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF1F2F6),
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Color(0xFFB8BCC6)),
              ),
            ),
          ),
          if ((category ?? '').isNotEmpty)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6D37A),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  category!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;

  const _Stat({required this.icon, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Colors.grey.shade800,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade800),
            const SizedBox(width: 6),
            Text('$count', style: textStyle),
          ],
        ),
      ),
    );
  }
}

// Replaces _friendlyTime
String _formatDate(DateTime? dt) {
  if (dt == null) return 'Just now';
  const months = [
    'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
  ];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}
