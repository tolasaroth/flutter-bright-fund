import 'package:flutter/cupertino.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';

// ── Data ─────────────────────────────────────────────────────────────────────

const _kImageUrl =
    'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800';

const _kCampaign = {
  'title': "Help Chan's Education",
  'category': 'Education',
  'description':
      "Our special friend Chan, a bright student with enormous potential, needs your support to pursue higher education.\n\nOn January 2026, his family faced unexpected financial hardship, making it impossible to cover tuition and living costs. We are reaching out to the community to help this wonderful family during their time of need.\n\nEvery donation, no matter how small, brings hope and relief. Your generosity will directly shape his future.",
  'raised': 2000.0,
  'goal': 4000.0,
  'donors': '128',
  'daysLeft': '18',
  'weeklyDonors': '34',
  'organizerName': 'John Doe',
  'organizerAvatar': 'https://i.pravatar.cc/50?img=5',
  'organizerRole': 'Campaign Organiser',
};

const _kUpdates = [
  {
    'author': 'John Doe',
    'date': 'Mar 10',
    'avatar': 'https://i.pravatar.cc/50?img=5',
    'message':
        'We have reached 50% of our goal! Thank you so much for your support and generosity. Every share matters!',
  },
  {
    'author': 'John Doe',
    'date': 'Mar 1',
    'avatar': 'https://i.pravatar.cc/50?img=5',
    'message':
        'Only 10 days left to reach our goal! Please share and donate if you can.',
  },
];

const _kDonations = [
  {
    'name': 'Jane Smith',
    'amount': '\$200',
    'time': 'Top donation',
    'top': true,
    'avatar': 'https://i.pravatar.cc/50?img=10',
  },
  {
    'name': 'Alice Smith',
    'amount': '\$150',
    'time': '2h ago',
    'top': false,
    'avatar': 'https://i.pravatar.cc/50?img=11',
  },
  {
    'name': 'Bob Lee',
    'amount': '\$80',
    'time': '5h ago',
    'top': false,
    'avatar': 'https://i.pravatar.cc/50?img=12',
  },
  {
    'name': 'Maria Santos',
    'amount': '\$50',
    'time': '1d ago',
    'top': false,
    'avatar': 'https://i.pravatar.cc/50?img=13',
  },
];

const _kComments = [
  {
    'name': 'Jane Smith',
    'amount': '\$200',
    'time': '2d',
    'message': 'Great campaign! I just donated. Wishing you all the best! 🙏',
    'avatar': 'https://i.pravatar.cc/50?img=20',
  },
  {
    'name': 'Alice Smith',
    'amount': '\$150',
    'time': '3d',
    'message':
        'I just donated as well! Keep up the great work. Never give up! ⭐',
    'avatar': 'https://i.pravatar.cc/50?img=21',
  },
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CampaignDetailScreen extends StatefulWidget {
  const CampaignDetailScreen({super.key});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool _isExpanded = false;
  bool _isBookmarked = false;

  static const _shadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  double get _progress =>
      (_kCampaign['raised'] as double) / (_kCampaign['goal'] as double);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      navigationBar: AppNavigationBar(
        title: 'Campaign Detail',
        showAddButton: false,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isBookmarked = !_isBookmarked),
              child: Icon(
                _isBookmarked
                    ? CupertinoIcons.bookmark_fill
                    : CupertinoIcons.bookmark,
                color: _isBookmarked
                    ? const Color(0xFFFFD700)
                    : CupertinoColors.activeBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                CupertinoIcons.share,
                color: CupertinoColors.activeBlue,
                size: 22,
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
                    _buildHeroCard(),
                    _buildActionButtons(),
                    _buildStorySection(),
                    _buildDivider(),
                    _buildUpdatesSection(),
                    _buildDivider(),
                    _buildDonationsSection(),
                    _buildDivider(),
                    _buildOrganiserSection(),
                    _buildDivider(),
                    _buildWordsOfSupportSection(),
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ],
          ),
          // Donate FAB pinned at bottom
          Positioned(left: 24, right: 24, bottom: 28, child: _buildDonateFAB()),
        ],
      ),
    );
  }

  // ── Hero Card (image + stats + progress) ───────────────────────────────────

  Widget _buildHeroCard() {
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
          // Image with overlay
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  _kImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Container(
                          height: 200,
                          color: AppColors.lightGreen,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: AppColors.lightGreen,
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.photo,
                        size: 48,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                ),
                // Gradient
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
                // Overlay content
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _kCampaign['category'] as String,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        _kCampaign['title'] as String,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Organiser row
                      Row(
                        children: [
                          _avatar(
                            _kCampaign['organizerAvatar'] as String,
                            size: 26,
                            radius: 8,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _kCampaign['organizerName'] as String,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            CupertinoIcons.checkmark_seal_fill,
                            color: CupertinoColors.activeBlue,
                            size: 13,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x60000000),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.clock,
                                  color: AppColors.white,
                                  size: 11,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_kCampaign['daysLeft']} days left',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
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

          // Progress content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Raised / goal / percentage
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${(_kCampaign['raised'] as double).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: CupertinoColors.activeBlue,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          'raised of \$${(_kCampaign['goal'] as double).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')} goal',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(_progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Progress bar
                LayoutBuilder(
                  builder: (_, constraints) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 10,
                      width: constraints.maxWidth,
                      child: Stack(
                        children: [
                          Container(color: const Color(0xFFEEF2F7)),
                          FractionallySizedBox(
                            widthFactor: _progress.clamp(0.0, 1.0),
                            child: Container(color: CupertinoColors.activeBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    _statChip(
                      CupertinoIcons.person_2_fill,
                      _kCampaign['donors'] as String,
                      'donors',
                    ),
                    const SizedBox(width: 10),
                    _statChip(
                      CupertinoIcons.calendar,
                      _kCampaign['daysLeft'] as String,
                      'days left',
                    ),
                    const SizedBox(width: 10),
                    _statChip(
                      CupertinoIcons.arrow_up_right,
                      _kCampaign['weeklyDonors'] as String,
                      'this week',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: CupertinoColors.activeBlue, size: 16),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Action Buttons ─────────────────────────────────────────────────────────

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          // Share
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFDDE1E7),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.share, size: 15, color: AppColors.ink),
                    SizedBox(width: 6),
                    Text(
                      'Share',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Donate
          Expanded(
            flex: 2,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.heart_fill,
                      size: 15,
                      color: AppColors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Donate Now',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
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

  Widget _buildStorySection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [_shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Campaign Story'),
          const SizedBox(height: 14),
          Text(
            _kCampaign['description'] as String,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.muted,
              height: 1.75,
            ),
            maxLines: _isExpanded ? null : 5,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                Text(
                  _isExpanded ? 'Read less' : 'Read more',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: CupertinoColors.activeBlue,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Updates Section ────────────────────────────────────────────────────────

  Widget _buildUpdatesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Updates', count: '${_kUpdates.length}'),
          const SizedBox(height: 14),
          ..._kUpdates.map(
            (u) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _UpdateItem(
                author: u['author']!,
                date: u['date']!,
                avatarUrl: u['avatar']!,
                message: u['message']!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Donations Section ──────────────────────────────────────────────────────

  Widget _buildDonationsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Donations', count: '${_kDonations.length}'),
          const SizedBox(height: 10),
          // Activity banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.chart_bar_alt_fill,
                  color: Color(0xFF3B82F6),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_kCampaign['weeklyDonors']} people donated this week',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ..._kDonations.map(
            (d) => _DonationItem(
              name: d['name'] as String,
              amount: d['amount'] as String,
              time: d['time'] as String,
              isTop: d['top'] as bool,
              avatarUrl: d['avatar'] as String,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: CupertinoColors.activeBlue,
                      size: 15,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'See all donations',
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Organiser Section ──────────────────────────────────────────────────────

  Widget _buildOrganiserSection() {
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [_shadow],
            ),
            child: Row(
              children: [
                _avatar(
                  _kCampaign['organizerAvatar'] as String,
                  size: 52,
                  radius: 14,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _kCampaign['organizerName'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            CupertinoIcons.checkmark_seal_fill,
                            color: CupertinoColors.activeBlue,
                            size: 14,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _kCampaign['organizerRole'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.activeBlue,
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
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

  Widget _buildWordsOfSupportSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Words of Support', count: '${_kComments.length}'),
          const SizedBox(height: 14),
          ..._kComments.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SupportItem(
                name: c['name']!,
                amount: c['amount']!,
                time: c['time']!,
                message: c['message']!,
                avatarUrl: c['avatar']!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Donate FAB ─────────────────────────────────────────────────────────────

  Widget _buildDonateFAB() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x5500C96B),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.heart_fill, color: AppColors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Donate Now',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, {String? count}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -0.3,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      height: 0.5,
      color: const Color(0xFFDDE1E7),
    );
  }

  /// Reusable network avatar with a fallback placeholder.
  Widget _avatar(String url, {required double size, double radius = 50}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          color: AppColors.lightGreen,
          child: Icon(
            CupertinoIcons.person_fill,
            size: size * 0.5,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _UpdateItem extends StatelessWidget {
  final String author;
  final String date;
  final String avatarUrl;
  final String message;

  const _UpdateItem({
    required this.author,
    required this.date,
    required this.avatarUrl,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  avatarUrl,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 36,
                    height: 36,
                    color: AppColors.lightGreen,
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      size: 18,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.muted,
              height: 1.6,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DonationItem extends StatelessWidget {
  final String name;
  final String amount;
  final String time;
  final bool isTop;
  final String avatarUrl;

  const _DonationItem({
    required this.name,
    required this.amount,
    required this.time,
    required this.isTop,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isTop ? AppColors.lightGreen : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: isTop
            ? Border.all(color: const Color(0x4D00C96B), width: 1)
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  avatarUrl,
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isTop
                          ? const Color(0x3300C96B)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      size: 20,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
              ),
              if (isTop)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.star_fill,
                      color: AppColors.white,
                      size: 9,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: CupertinoColors.activeBlue,
                ),
              ),
              if (isTop)
                const Text(
                  'Top donor',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFFFB300),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final String name;
  final String amount;
  final String time;
  final String message;
  final String avatarUrl;

  const _SupportItem({
    required this.name,
    required this.amount,
    required this.time,
    required this.message,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              avatarUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                color: AppColors.lightGreen,
                child: const Icon(
                  CupertinoIcons.person_fill,
                  size: 22,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    Text(
                      ' · $time',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
