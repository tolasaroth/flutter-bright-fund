import 'package:flutter/cupertino.dart';
import 'package:gofundme/state/app_state.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';
import 'package:gofundme/screens/campaigns/donation_screen.dart';

class CampaignDetailScreen extends StatefulWidget {
  final String campaignId;

  const CampaignDetailScreen({super.key, required this.campaignId});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool _isExpanded = false;
  bool _isBookmarked = false;
  final _commentController = TextEditingController();

  static const _shadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  @override
  void initState() {
    super.initState();
    AppState.instance.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_onStateChanged);
    _commentController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  Campaign? get _campaign => AppState.instance.findById(widget.campaignId);

  String _formatAmount(double amount) =>
      amount.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'\B(?=(\d{3})+(?!\d))'),
            (_) => ',',
          );

  @override
  Widget build(BuildContext context) {
    final campaign = _campaign;
    if (campaign == null) {
      return CupertinoPageScaffold(
        child: Center(child: Text('Campaign not found')),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      navigationBar: AppNavigationBar(
        title: 'Campaign Detail',
        showAddButton: false,
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue, size: 34),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isBookmarked = !_isBookmarked),
              child: Icon(
                _isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                color: CupertinoColors.activeBlue,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(campaign),
                    _buildActionButtons(campaign),
                    _buildStorySection(campaign),
                    _buildDivider(),
                    _buildUpdatesSection(campaign),
                    _buildDivider(),
                    _buildDonationsSection(campaign),
                    _buildDivider(),
                    _buildOrganiserSection(campaign),
                    _buildDivider(),
                    _buildWordsOfSupportSection(campaign),
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ],
          ),
          Positioned(left: 24, right: 24, bottom: 28, child: _buildDonateFAB(campaign)),
        ],
      ),
    );
  }

  // ── Hero Card ──────────────────────────────────────────────────────────────

  Widget _buildHeroCard(Campaign campaign) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [_shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                // Show in-memory bytes if available, else network
                _buildHeroImage(campaign),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xCC000000)],
                        stops: [0.35, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16, left: 16, right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(campaign.categoryName,
                            style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 8),
                      Text(campaign.title,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.3, letterSpacing: -0.3)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _avatar('https://i.pravatar.cc/50?img=5', size: 26, radius: 8),
                          const SizedBox(width: 6),
                          Text(campaign.organizerName,
                              style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          const Icon(CupertinoIcons.checkmark_seal_fill, color: CupertinoColors.activeBlue, size: 13),
                          const Spacer(),
                          if (campaign.endDate != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0x60000000),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(CupertinoIcons.clock, color: AppColors.white, size: 11),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${campaign.endDate!.difference(DateTime.now()).inDays.clamp(0, 9999)} days left',
                                    style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\$${_formatAmount(campaign.raisedAmount)}',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w900,
                                color: CupertinoColors.activeBlue, letterSpacing: -1)),
                        Text('raised of \$${_formatAmount(campaign.goalAmount)} goal',
                            style: const TextStyle(fontSize: 13, color: AppColors.muted, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(campaign.progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.darkGreen),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (_, constraints) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 10, width: constraints.maxWidth,
                      child: Stack(
                        children: [
                          Container(color: const Color(0xFFEEF2F7)),
                          FractionallySizedBox(
                            widthFactor: campaign.progress,
                            child: Container(color: CupertinoColors.activeBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _statChip(CupertinoIcons.person_2_fill, '${campaign.donorCount}', 'donors'),
                    const SizedBox(width: 10),
                    _statChip(CupertinoIcons.calendar,
                        campaign.endDate != null
                            ? '${campaign.endDate!.difference(DateTime.now()).inDays.clamp(0, 9999)}'
                            : '—',
                        'days left'),
                    const SizedBox(width: 10),
                    _statChip(CupertinoIcons.arrow_up_right, '${campaign.weeklyDonors}', 'this week'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Campaign campaign) {
    if (campaign.coverImageBytes != null) {
      return Image.memory(
        campaign.coverImageBytes!,
        height: 200, width: double.infinity, fit: BoxFit.cover,
      );
    }
    return Image.network(
      campaign.coverImageUrl ?? 'https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800',
      height: 200, width: double.infinity, fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(height: 200, color: AppColors.lightGreen,
              child: const Center(child: CupertinoActivityIndicator())),
      errorBuilder: (_, __, ___) => Container(
        height: 200, color: AppColors.lightGreen,
        child: const Center(child: Icon(CupertinoIcons.photo, size: 48, color: CupertinoColors.activeBlue)),
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, color: CupertinoColors.activeBlue, size: 16),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ── Action Buttons ─────────────────────────────────────────────────────────

  Widget _buildActionButtons(Campaign campaign) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDDE1E7), width: 1.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.share, size: 15, color: AppColors.ink),
                    SizedBox(width: 6),
                    Text('Share', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _openDonation(campaign),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.heart_fill, size: 15, color: AppColors.white),
                    SizedBox(width: 6),
                    Text('Donate Now', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Story Section ──────────────────────────────────────────────────────────

  Widget _buildStorySection(Campaign campaign) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [_shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Campaign Story'),
          const SizedBox(height: 14),
          Text(
            campaign.description,
            style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.75),
            maxLines: _isExpanded ? null : 5,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                Text(_isExpanded ? 'Read less' : 'Read more',
                    style: const TextStyle(fontSize: 14, color: CupertinoColors.activeBlue, fontWeight: FontWeight.w700)),
                const SizedBox(width: 4),
                Icon(_isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                    color: CupertinoColors.activeBlue, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Updates Section ────────────────────────────────────────────────────────

  Widget _buildUpdatesSection(Campaign campaign) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Updates', count: '${campaign.updates.length}'),
          const SizedBox(height: 14),
          if (campaign.updates.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No updates yet.', style: TextStyle(color: AppColors.muted, fontSize: 14)),
            ),
          ...campaign.updates.map(
            (u) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _UpdateItem(
                author: u.author, date: u.formattedDate,
                avatarUrl: u.avatarUrl, message: u.message,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Donations Section ──────────────────────────────────────────────────────

  Widget _buildDonationsSection(Campaign campaign) {
    final topDonation = campaign.donations.isNotEmpty
        ? campaign.donations.reduce((a, b) => a.amount > b.amount ? a : b)
        : null;
    final displayed = campaign.donations.take(4).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Donations', count: '${campaign.donorCount}'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF6FF), borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.chart_bar_alt_fill, color: Color(0xFF3B82F6), size: 16),
                const SizedBox(width: 8),
                Text('${campaign.weeklyDonors} people donated this week',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF3B82F6), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (campaign.donations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No donations yet. Be the first!',
                  style: TextStyle(color: AppColors.muted, fontSize: 14)),
            ),
          ...displayed.map(
            (d) => _DonationItem(
              name: d.displayName,
              amount: '\$${d.amount.toStringAsFixed(0)}',
              time: d == topDonation ? 'Top donation' : d.timeAgo,
              isTop: d == topDonation,
              avatarUrl: 'https://i.pravatar.cc/50?img=${(d.amount % 70).toInt() + 1}',
            ),
          ),
        ],
      ),
    );
  }

  // ── Organiser Section ──────────────────────────────────────────────────────

  Widget _buildOrganiserSection(Campaign campaign) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Organiser'),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [_shadow],
            ),
            child: Row(
              children: [
                _avatar('https://i.pravatar.cc/50?img=5', size: 52, radius: 14),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(campaign.organizerName,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                          const SizedBox(width: 4),
                          const Icon(CupertinoIcons.checkmark_seal_fill, color: CupertinoColors.activeBlue, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(campaign.organizerRole, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CupertinoColors.activeBlue, width: 1.5),
                    ),
                    child: const Text('Contact',
                        style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Words of Support ───────────────────────────────────────────────────────

  Widget _buildWordsOfSupportSection(Campaign campaign) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Words of Support', count: '${campaign.comments.length}'),
          const SizedBox(height: 14),

          // Add comment field
          _buildAddCommentField(campaign),
          const SizedBox(height: 14),

          if (campaign.comments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No comments yet. Leave a word of support!',
                  style: TextStyle(color: AppColors.muted, fontSize: 14)),
            ),
          ...campaign.comments.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SupportItem(
                name: c.name, amount: c.formattedAmount,
                time: c.timeAgo, message: c.message, avatarUrl: c.avatarUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentField(Campaign campaign) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE1E7), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _commentController,
              placeholder: 'Write a word of support...',
              decoration: const BoxDecoration(),
              padding: EdgeInsets.zero,
              style: const TextStyle(fontSize: 14, color: AppColors.ink),
              placeholderStyle: const TextStyle(fontSize: 14, color: AppColors.muted),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _submitComment(campaign),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Post', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment(Campaign campaign) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    AppState.instance.addComment(
      campaignId: campaign.id,
      name: 'You',
      donationAmount: 0,
      message: text,
      avatarUrl: 'https://i.pravatar.cc/50?img=3',
    );
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  // ── Donate FAB ─────────────────────────────────────────────────────────────

  Widget _buildDonateFAB(Campaign campaign) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _openDonation(campaign),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x5500C96B), blurRadius: 18, offset: Offset(0, 6))],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.heart_fill, color: AppColors.white, size: 18),
            SizedBox(width: 8),
            Text('Donate Now',
                style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
          ],
        ),
      ),
    );
  }

  void _openDonation(Campaign campaign) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => DonationScreen(campaignId: campaign.id),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, {String? count}) {
    return Row(
      children: [
        Container(
          width: 4, height: 20,
          decoration: BoxDecoration(color: CupertinoColors.activeBlue, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink, letterSpacing: -0.3)),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(20)),
            child: Text(count,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
          ),
        ],
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      height: 0.5, color: const Color(0xFFDDE1E7),
    );
  }

  Widget _avatar(String url, {required double size, double radius = 50}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url, width: size, height: size, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size, height: size, color: AppColors.lightGreen,
          child: Icon(CupertinoIcons.person_fill, size: size * 0.5, color: CupertinoColors.activeBlue),
        ),
      ),
    );
  }
}

// ── Sub-widgets (same as before) ──────────────────────────────────────────────

class _UpdateItem extends StatelessWidget {
  final String author, date, avatarUrl, message;
  const _UpdateItem({required this.author, required this.date, required this.avatarUrl, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(avatarUrl, width: 36, height: 36, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 36, height: 36, color: AppColors.lightGreen,
                        child: const Icon(CupertinoIcons.person_fill, size: 18, color: CupertinoColors.activeBlue))),
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ]),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(8)),
                child: const Text('Update', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.6), maxLines: 4, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _DonationItem extends StatelessWidget {
  final String name, amount, time, avatarUrl;
  final bool isTop;
  const _DonationItem({required this.name, required this.amount, required this.time, required this.isTop, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isTop ? AppColors.lightGreen : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: isTop ? Border.all(color: const Color(0x4D00C96B), width: 1) : null,
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(avatarUrl, width: 42, height: 42, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                            color: isTop ? const Color(0x3300C96B) : AppColors.surface,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(CupertinoIcons.person_fill, size: 20, color: CupertinoColors.activeBlue))),
              ),
              if (isTop)
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 16, height: 16,
                    decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
                    child: const Icon(CupertinoIcons.star_fill, color: AppColors.white, size: 9),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 2),
            Text(time, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: CupertinoColors.activeBlue)),
            if (isTop)
              const Text('Top donor', style: TextStyle(fontSize: 10, color: Color(0xFFFFB300), fontWeight: FontWeight.w600)),
          ]),
        ],
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final String name, amount, time, message, avatarUrl;
  const _SupportItem({required this.name, required this.amount, required this.time, required this.message, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(avatarUrl, width: 44, height: 44, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 44, height: 44, color: AppColors.lightGreen,
                    child: const Icon(CupertinoIcons.person_fill, size: 22, color: CupertinoColors.activeBlue))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
              const Spacer(),
              if (double.tryParse(amount.replaceAll('\$', '')) != null &&
                  double.parse(amount.replaceAll('\$', '')) > 0)
                Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: CupertinoColors.activeBlue)),
              Text(' · $time', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            ]),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
              child: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.muted, height: 1.5)),
            ),
          ])),
        ],
      ),
    );
  }
}