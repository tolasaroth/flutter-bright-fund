import 'package:flutter/cupertino.dart';

class CampaignCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final double raisedAmount;
  final double goalAmount;
  final String categoryName;
  final String organizerName;
  final String? organizerImageUrl;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CampaignCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.raisedAmount,
    required this.goalAmount,
    required this.categoryName,
    required this.organizerName,
    this.organizerImageUrl,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}k';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (goalAmount > 0 ? raisedAmount / goalAmount : 0.0)
        .clamp(0.0, 1.0);
    final brightness =
        CupertinoTheme.of(context).brightness ??
        MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final bool hasActions = onEdit != null || onDelete != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image with category badge overlay ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 175,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 175,
                        color: CupertinoColors.systemGrey5,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, _, __) => Container(
                      height: 175,
                      color: CupertinoColors.systemGrey5,
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.photo,
                          size: 40,
                          color: CupertinoColors.systemGrey2,
                        ),
                      ),
                    ),
                  ),
                ),
                // Category badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Card body ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle
                        .copyWith(fontSize: 17, height: 1.3),
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Progress bar ──
                  LayoutBuilder(
                    builder: (_, constraints) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 6,
                        width: constraints.maxWidth,
                        child: Stack(
                          children: [
                            Container(color: CupertinoColors.systemGrey5),
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Raised / goal row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _formatAmount(raisedAmount),
                              style: const TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const TextSpan(
                              text: ' raised',
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Goal ${_formatAmount(goalAmount)}',
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Container(height: 0.5, color: CupertinoColors.systemGrey5),
                  const SizedBox(height: 12),

                  // ── Organizer row ──
                  Row(
                    children: [
                      ClipOval(
                        child: organizerImageUrl != null
                            ? Image.network(
                                organizerImageUrl!,
                                width: 28,
                                height: 28,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _placeholderAvatar(),
                              )
                            : _placeholderAvatar(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'by $organizerName',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (!hasActions)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Donate',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // ── Edit / Delete actions (only when callbacks provided) ──
                  if (hasActions) ...[
                    const SizedBox(height: 12),
                    Container(height: 0.5, color: CupertinoColors.systemGrey5),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (onEdit != null)
                          Expanded(
                            child: GestureDetector(
                              onTap: onEdit,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF6FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.pencil,
                                      color: CupertinoColors.activeBlue,
                                      size: 14,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: CupertinoColors.activeBlue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (onEdit != null && onDelete != null)
                          const SizedBox(width: 10),
                        if (onDelete != null)
                          Expanded(
                            child: GestureDetector(
                              onTap: onDelete,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.trash,
                                      color: CupertinoColors.destructiveRed,
                                      size: 14,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: CupertinoColors.destructiveRed,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderAvatar() {
    return Container(
      width: 28,
      height: 28,
      color: CupertinoColors.systemGrey4,
      child: const Icon(
        CupertinoIcons.person_fill,
        size: 16,
        color: CupertinoColors.systemGrey,
      ),
    );
  }
}
