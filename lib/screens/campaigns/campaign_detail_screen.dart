import 'package:flutter/material.dart';

// ── Colour tokens ────────────────────────────────────────────────────────────
const _green = Color(0xFF00C96B);
const _darkGreen = Color(0xFF009952);
const _lightGreen = Color(0xFFE8FFF4);
const _ink = Color(0xFF1A1A2E);
const _muted = Color(0xFF6B7280);
const _surface = Color(0xFFF7F9FC);
const _white = Colors.white;

class CampaignDetailScreen extends StatefulWidget {
  const CampaignDetailScreen({super.key});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool _isExpanded = false;
  bool _isBookmarked = false;

  static const double _raised = 6000;
  static const double _goal = 70000;
  static const double _progress = _raised / _goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressCard(),
                _buildActionButtons(),
                _buildStorySection(),
                _buildDivider(),
                _buildUpdatesSection(),
                _buildDivider(),
                _buildDonationSection(),
                _buildDivider(),
                _buildOrganiserSection(),
                _buildDivider(),
                _buildWordsOfSupportSection(),
                const SizedBox(height: 100), // bottom padding for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildDonateFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── App Bar ─────────────────────────────────────────────────────────────────
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      elevation: 0,
      backgroundColor: _darkGreen,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: _white, size: 18),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _isBookmarked = !_isBookmarked),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? const Color(0xFFFFD700) : _white,
              size: 20,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.ios_share_rounded, color: _white, size: 20),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero image
            Image.network(
              'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: _lightGreen,
                child: const Center(
                  child: Icon(Icons.image_rounded, size: 60, color: _green),
                ),
              ),
            ),
            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.75),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            // Content overlay
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Education',
                      style: TextStyle(color: _white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  const Text(
                    'Help Nita Achieve Her Dream to be an AI Designer at MIT',
                    style: TextStyle(
                      color: _white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.3,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Organiser row
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://i.pravatar.cc/50?img=5',
                          width: 26,
                          height: 26,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const CircleAvatar(radius: 13, backgroundColor: _lightGreen),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'KhimHeng',
                        style: TextStyle(color: _white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded, color: _green, size: 14),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.access_time_rounded, color: _white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              '50 days left',
                              style: TextStyle(color: _white, fontSize: 11, fontWeight: FontWeight.w600),
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
      title: const Text(
        'Campaign Detail',
        style: TextStyle(color: _white, fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ── Progress Card ────────────────────────────────────────────────────────────
  Widget _buildProgressCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '\$6,000',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: _green, letterSpacing: -1),
                  ),
                  Text(
                    'raised of \$70,000 goal',
                    style: TextStyle(fontSize: 13, color: _muted, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '9%',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _darkGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Segmented progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: const Color(0xFFEEF2F7),
              valueColor: const AlwaysStoppedAnimation<Color>(_green),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            children: [
              _buildStatChip(Icons.people_rounded, '1.7K', 'donors'),
              const SizedBox(width: 12),
              _buildStatChip(Icons.calendar_today_rounded, '50', 'days left'),
              const SizedBox(width: 12),
              _buildStatChip(Icons.trending_up_rounded, '226', 'this week'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: _green, size: 16),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _ink)),
            Text(label, style: TextStyle(fontSize: 10, color: _muted, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ── Action Buttons ───────────────────────────────────────────────────────────
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          // Share
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.ios_share_rounded, size: 16),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _ink,
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: Color(0xFFDDE1E7), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Donate
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.volunteer_activism_rounded, size: 16),
              label: const Text('Donate Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: _white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Story Section ────────────────────────────────────────────────────────────
  Widget _buildStorySection() {
    const story =
        'Our special friend Lewis, husband to Sarah, father to two beautiful girls, and loved by all!\n\nOn Monday, 27th October 2025, Lewis\'s and his family\'s lives changed forever. What started as an ordinary afternoon, turned into an unimaginable tragedy. We are reaching out to the community to help this wonderful family during their time of need.\n\nEvery donation, no matter how small, brings hope and relief to those who need it most. Your generosity will directly impact their lives.';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              const Text(
                'Campaign Story',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.3),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            story,
            style: TextStyle(fontSize: 14, color: _muted, height: 1.7),
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
                  style: const TextStyle(fontSize: 14, color: _green, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: _green,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Updates Section ──────────────────────────────────────────────────────────
  Widget _buildUpdatesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Updates', '2'),
          const SizedBox(height: 14),
          _ImprovedUpdateItem(
            date: 'Nov 7',
            author: 'KhimHeng',
            avatarUrl: 'https://i.pravatar.cc/50?img=5',
            message:
                'We are nearly 60% there towards our goal to save our daughters life ❤️ We are so so grateful for everyone\'s support where it be sharing the story or kind donations — thank you all!',
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: _green),
            label: const Text('See 1 more update', style: TextStyle(color: _green, fontWeight: FontWeight.w700)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }

  // ── Donation Section ─────────────────────────────────────────────────────────
  Widget _buildDonationSection() {
    final donations = [
      {'name': 'Emp Pisey', 'amount': '\$50', 'time': 'Top donation', 'top': true, 'avatar': 'https://i.pravatar.cc/50?img=10'},
      {'name': 'Kong Chan', 'amount': '\$20', 'time': '1h ago', 'top': false, 'avatar': 'https://i.pravatar.cc/50?img=11'},
      {'name': 'KhimHeng', 'amount': '\$15', 'time': '3h ago', 'top': false, 'avatar': 'https://i.pravatar.cc/50?img=12'},
      {'name': 'Saruth Tola', 'amount': '\$10', 'time': '5h ago', 'top': false, 'avatar': 'https://i.pravatar.cc/50?img=13'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Donations', '1.7K'),
          const SizedBox(height: 10),
          // Activity notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: Color(0xFF3B82F6), size: 18),
                SizedBox(width: 8),
                Text(
                  '226 people donated this week',
                  style: TextStyle(fontSize: 13, color: Color(0xFF3B82F6), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...donations.map((d) => _ImprovedDonationItem(
                name: d['name'] as String,
                amount: d['amount'] as String,
                time: d['time'] as String,
                isTop: d['top'] as bool,
                avatarUrl: d['avatar'] as String,
              )),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.expand_more_rounded, color: _green),
              label: const Text('See all donations', style: TextStyle(color: _green, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Organiser Section ────────────────────────────────────────────────────────
  Widget _buildOrganiserSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4, height: 20,
                decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              const Text('Organiser', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _ink)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    'https://i.pravatar.cc/50?img=5',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const CircleAvatar(radius: 26, backgroundColor: _lightGreen),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('KhimHeng', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _ink)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, color: _green, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Campaign Organiser', style: TextStyle(fontSize: 12, color: _muted)),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _green,
                    side: const BorderSide(color: _green, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  child: const Text('Contact'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Words of Support ─────────────────────────────────────────────────────────
  Widget _buildWordsOfSupportSection() {
    final supports = [
      {
        'name': 'Jojo Carmody',
        'amount': '\$20',
        'time': '30d',
        'message': 'Wishing you all the best on this journey! 🙏',
        'avatar': 'https://i.pravatar.cc/50?img=20',
      },
      {
        'name': 'Sok Pisey',
        'amount': '\$20',
        'time': '30d',
        'message': 'I wish you\'ll get your dream! Never give up! ⭐',
        'avatar': 'https://i.pravatar.cc/50?img=21',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Words of Support', '2'),
          const SizedBox(height: 14),
          ...supports.map((s) => _ImprovedSupportItem(
                name: s['name']!,
                amount: s['amount']!,
                time: s['time']!,
                message: s['message']!,
                avatarUrl: s['avatar']!,
              )),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String count) {
    return Row(
      children: [
        Container(
          width: 4, height: 20,
          decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.3)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(20)),
          child: Text(count, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _darkGreen)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      height: 1,
      color: const Color(0xFFEEF2F7),
    );
  }

  Widget _buildDonateFAB() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.volunteer_activism_rounded, size: 20),
        label: const Text(
          'Donate Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.2),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: _white,
          elevation: 8,
          shadowColor: _green.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _ImprovedUpdateItem extends StatelessWidget {
  final String date;
  final String author;
  final String avatarUrl;
  final String message;

  const _ImprovedUpdateItem({
    required this.date,
    required this.author,
    required this.avatarUrl,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
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
                  errorBuilder: (_, __, ___) =>
                      const CircleAvatar(radius: 18, backgroundColor: _lightGreen),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _ink)),
                  Text(date, style: TextStyle(fontSize: 11, color: _muted)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(8)),
                child: const Text('Update', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _darkGreen)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: _muted, height: 1.6),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ImprovedDonationItem extends StatelessWidget {
  final String name;
  final String amount;
  final String time;
  final bool isTop;
  final String avatarUrl;

  const _ImprovedDonationItem({
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
        color: isTop ? _lightGreen : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isTop ? Border.all(color: _green.withOpacity(0.3), width: 1) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
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
                  errorBuilder: (_, __, ___) =>
                      CircleAvatar(radius: 21, backgroundColor: isTop ? _green.withOpacity(0.2) : _surface),
                ),
              ),
              if (isTop)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
                    child: const Icon(Icons.star_rounded, color: Colors.white, size: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _ink)),
                const SizedBox(height: 2),
                Text(time, style: TextStyle(fontSize: 12, color: _muted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _green),
              ),
              if (isTop)
                const Text('Top donor', style: TextStyle(fontSize: 10, color: Color(0xFFFFB300), fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImprovedSupportItem extends StatelessWidget {
  final String name;
  final String amount;
  final String time;
  final String message;
  final String avatarUrl;

  const _ImprovedSupportItem({
    required this.name,
    required this.amount,
    required this.time,
    required this.message,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
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
              errorBuilder: (_, __, ___) => const CircleAvatar(radius: 22, backgroundColor: _lightGreen),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _ink)),
                    const Spacer(),
                    Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _green)),
                    Text(' · $time', style: TextStyle(fontSize: 12, color: _muted)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 13, color: _muted, height: 1.5),
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