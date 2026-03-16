import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:gofundme/utils/colors.dart';

class CampaignCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final Uint8List? coverImageBytes; // ✅ in-memory image bytes
  final double raisedAmount;
  final double goalAmount;
  final String categoryName;
  final String organizerName;
  final String? organizerImageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CampaignCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.coverImageBytes,
    required this.raisedAmount,
    required this.goalAmount,
    required this.categoryName,
    required this.organizerName,
    this.organizerImageUrl,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  double get _progress => (raisedAmount / goalAmount).clamp(0.0, 1.0);

  String _formatAmount(double amount) =>
      '\$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image section ──────────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                GestureDetector(onTap: onTap, child: _buildImage()),
                // Category badge
                Positioned(
                  top: 12, left: 12,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(categoryName,
                          style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                // Edit/Delete menu — receives stable parent context
                if (onEdit != null || onDelete != null)
                  Positioned(
                    top: 8, right: 8,
                    child: _ActionMenu(
                      parentContext: context,
                      onEdit: onEdit,
                      onDelete: onDelete,
                    ),
                  ),
              ],
            ),
          ),

          // ── Content section ────────────────────────────────────────────
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                          color: AppColors.ink, letterSpacing: -0.3),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(description,
                      style: const TextStyle(fontSize: 13, color: AppColors.muted, height: 1.5),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 14),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 8,
                      child: LayoutBuilder(builder: (_, constraints) => Stack(children: [
                        Container(color: const Color(0xFFEEF2F7), width: constraints.maxWidth),
                        Container(
                          color: CupertinoColors.activeBlue,
                          width: constraints.maxWidth * _progress,
                        ),
                      ])),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Raised / goal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: _formatAmount(raisedAmount),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                                  color: CupertinoColors.activeBlue)),
                          TextSpan(text: ' of ${_formatAmount(goalAmount)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w500)),
                        ],
                      )),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.lightGreen, borderRadius: BorderRadius.circular(10)),
                        child: Text('${(_progress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                                color: AppColors.darkGreen)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Organizer row
                  Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        organizerImageUrl ?? 'https://i.pravatar.cc/50?img=5',
                        width: 28, height: 28, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            width: 28, height: 28, color: AppColors.lightGreen,
                            child: const Icon(CupertinoIcons.person_fill, size: 14, color: CupertinoColors.activeBlue)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(organizerName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    const SizedBox(width: 4),
                    const Icon(CupertinoIcons.checkmark_seal_fill, color: CupertinoColors.activeBlue, size: 13),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (coverImageBytes != null) {
      return Image.memory(coverImageBytes!, height: 180, width: double.infinity, fit: BoxFit.cover);
    }
    return Image.network(
      imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(height: 180, color: AppColors.lightGreen,
              child: const Center(child: CupertinoActivityIndicator())),
      errorBuilder: (_, __, ___) => Container(
          height: 180, color: AppColors.lightGreen,
          child: const Center(child: Icon(CupertinoIcons.photo, size: 48, color: CupertinoColors.activeBlue))),
    );
  }
}

// ── Inline action menu (Edit / Delete) ────────────────────────────────────────

class _ActionMenu extends StatelessWidget {
  /// Must be the BuildContext of a stable ancestor widget (e.g. the list item),
  /// NOT the modal sheet's builder context — using the sheet context after pop() crashes.
  final BuildContext parentContext;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ActionMenu({
    required this.parentContext,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Use parentContext here so the modal is anchored to the stable widget tree
      onTap: () => _showSheet(parentContext),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: const Color(0xCC000000),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(CupertinoIcons.ellipsis, color: AppColors.white, size: 16),
      ),
    );
  }

  void _showSheet(BuildContext ctx) {
    showCupertinoModalPopup<void>(
      context: ctx,
      builder: (sheetCtx) => CupertinoActionSheet(
        actions: [
          if (onEdit != null)
            CupertinoActionSheetAction(
              onPressed: () {
                // Pop the sheet first using the sheet's own context, then
                // invoke the callback which navigates on the parent context.
                Navigator.of(sheetCtx).pop();
                onEdit!();
              },
              child: const Text('Edit Campaign',
                  style: TextStyle(color: CupertinoColors.activeBlue)),
            ),
          if (onDelete != null)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(sheetCtx).pop();
                onDelete!();
              },
              child: const Text('Delete Campaign'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(sheetCtx).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}