import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ── Colour tokens ─────────────────────────────────────────────────────────────
const _green = Color(0xFF00C96B);
const _darkGreen = Color(0xFF009952);
const _lightGreen = Color(0xFFE8FFF4);
const _ink = Color(0xFF1A1A2E);
const _muted = Color(0xFF6B7280);
const _surface = Color(0xFFF7F9FC);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // 0.0 = fully expanded, 1.0 = fully collapsed
  double _collapseProgress = 0.0;
  static const double _collapseThreshold = 100.0;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.apps_rounded},
    {'label': 'Technology', 'icon': Icons.memory_rounded},
    {'label': 'Charity', 'icon': Icons.favorite_rounded},
    {'label': 'Education', 'icon': Icons.school_rounded},
    {'label': 'Medical', 'icon': Icons.local_hospital_rounded},
    {'label': 'Business', 'icon': Icons.business_center_rounded},
  ];

  final List<Map<String, dynamic>> _donationCampaigns = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600',
      'donationCount': '5.2k donations',
      'daysLeft': '50 days left',
      'title': 'Help Nita Achieve Her Dream',
      'raised': 3000,
      'goal': 5000,
      'category': 'Education',
      'avatarUrl': 'https://i.pravatar.cc/50?img=1',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1509099836639-18ba1795216d?w=600',
      'donationCount': '4.8k donations',
      'daysLeft': '20 days left',
      'title': "Support Chan's Education Journey",
      'raised': 2000,
      'goal': 4000,
      'category': 'Education',
      'avatarUrl': 'https://i.pravatar.cc/50?img=2',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=600',
      'donationCount': '3.6k donations',
      'daysLeft': '15 days left',
      'title': 'Tech Scholarships for Youth',
      'raised': 6000,
      'goal': 8000,
      'category': 'Technology',
      'avatarUrl': 'https://i.pravatar.cc/50?img=3',
    },
  ];

  final List<Map<String, dynamic>> _charityCampaigns = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=600',
      'donationCount': '3.1k donations',
      'daysLeft': '35 days left',
      'title': 'Food Drive for Families in Need',
      'raised': 1500,
      'goal': 3000,
      'category': 'Charity',
      'avatarUrl': 'https://i.pravatar.cc/50?img=4',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=600',
      'donationCount': '2.5k donations',
      'daysLeft': '40 days left',
      'title': 'Medical Aid for Children',
      'raised': 2500,
      'goal': 5000,
      'category': 'Medical',
      'avatarUrl': 'https://i.pravatar.cc/50?img=5',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset.clamp(0.0, _collapseThreshold);
    final progress = offset / _collapseThreshold;
    if ((progress - _collapseProgress).abs() > 0.01) {
      setState(() => _collapseProgress = progress);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAnimatedHeader(),
            _buildCategories(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  _buildStatsBanner(),
                  _buildSectionHeader('Trending Campaigns 🔥', 'View all'),
                  ..._donationCampaigns.map(_buildCampaignCard),
                  const SizedBox(height: 8),
                  _buildSectionHeader('Charity Drives ❤️', 'View all'),
                  ..._charityCampaigns.map(_buildCampaignCard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Animated Header ───────────────────────────────────────────────────────────
  Widget _buildAnimatedHeader() {
    // Interpolated values
    final double greetingOpacity = (1.0 - _collapseProgress * 2).clamp(
      0.0,
      1.0,
    );
    final double greetingHeight = (1.0 - _collapseProgress).clamp(0.0, 1.0);
    final double topRowHeight = (1.0 - _collapseProgress).clamp(0.0, 1.0);
    final double topRowOpacity = (1.0 - _collapseProgress * 1.5).clamp(
      0.0,
      1.0,
    );
    final double topPadding = 12 - (_collapseProgress * 4);
    final double bottomPadding = 20 - (_collapseProgress * 8);

    return AnimatedContainer(
      duration: Duration.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00D97E), Color(0xFF00A855)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        topPadding.clamp(8, 12),
        16,
        bottomPadding.clamp(12, 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row — collapses when scrolling
          ClipRect(
            child: AnimatedAlign(
              duration: Duration.zero,
              heightFactor: topRowHeight,
              alignment: Alignment.topLeft,
              child: Opacity(
                opacity: topRowOpacity,
                child: Row(
                  children: [
                    // Logo / collapsed title
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.volunteer_activism_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'FundRise',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Notification bell
                    _headerIconBtn(
                      size: 38,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Avatar
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://i.pravatar.cc/80?img=7',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Greeting — fades and collapses
          ClipRect(
            child: AnimatedAlign(
              duration: Duration.zero,
              heightFactor: greetingHeight,
              alignment: Alignment.topLeft,
              child: Opacity(
                opacity: greetingOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good morning, Alex 👋',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Find a campaign that matters to you',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search bar — always visible, shrinks slightly
          AnimatedContainer(
            duration: Duration.zero,
            height: _collapseProgress > 0.6 ? 40 : 46,
            margin: EdgeInsets.only(top: _collapseProgress > 0.6 ? 10 : 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                _collapseProgress > 0.6 ? 12 : 14,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14, color: _ink),
              decoration: InputDecoration(
                hintText: 'Search campaigns...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: _green,
                  size: 20,
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerIconBtn({required Widget child, double size = 38}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(size > 34 ? 12 : 10),
      ),
      child: child,
    );
  }

  // ── Categories ────────────────────────────────────────────────────────────────
  Widget _buildCategories() {
    return Container(
      color: const Color(0xFF009952),
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _categories.map((cat) {
            final isSelected = cat['label'] == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () =>
                    setState(() => _selectedCategory = cat['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat['icon'] as IconData,
                        size: 14,
                        color: isSelected ? _darkGreen : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat['label'] as String,
                        style: TextStyle(
                          color: isSelected ? _darkGreen : Colors.white,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Stats Banner ──────────────────────────────────────────────────────────────
  Widget _buildStatsBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _statItem(Icons.campaign_rounded, '12.4K', 'Campaigns'),
          Container(width: 1, height: 38, color: Colors.white.withOpacity(0.1)),
          _statItem(Icons.attach_money_rounded, '\$2.1M', 'Raised'),
          Container(width: 1, height: 38, color: Colors.white.withOpacity(0.1)),
          _statItem(Icons.people_rounded, '98K', 'Donors'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: _green, size: 18),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
        ),
      ],
    ),
  );

  // ── Section Header ────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _ink,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: _green,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              side: const BorderSide(color: _green, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('View all'),
          ),
        ],
      ),
    );
  }

  // ── Campaign Card ─────────────────────────────────────────────────────────────
  Widget _buildCampaignCard(Map<String, dynamic> c) {
    final raised = (c['raised'] as int).toDouble();
    final goal = (c['goal'] as int).toDouble();
    final progress = raised / goal;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  c['imageUrl'] as String,
                  height: 165,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 165,
                    color: _lightGreen,
                    child: const Center(
                      child: Icon(Icons.image_rounded, color: _green, size: 40),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.45),
                        ],
                        stops: const [0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      c['category'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.bookmark_border_rounded,
                      color: _ink,
                      size: 18,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.52),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          c['daysLeft'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        c['avatarUrl'] as String,
                        width: 22,
                        height: 22,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const CircleAvatar(
                          radius: 11,
                          backgroundColor: _lightGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      c['donationCount'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.verified_rounded, color: _green, size: 13),
                    const SizedBox(width: 3),
                    const Text(
                      'Verified',
                      style: TextStyle(
                        fontSize: 11,
                        color: _green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  c['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                    letterSpacing: -0.3,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFEEF2F7),
                    valueColor: const AlwaysStoppedAnimation<Color>(_green),
                    minHeight: 7,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${_fmt(raised.toInt())}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _green,
                            ),
                          ),
                          const TextSpan(
                            text: ' raised',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).toInt()}% of \$${_fmt(c['goal'] as int)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.volunteer_activism_rounded,
                      size: 16,
                    ),
                    label: const Text('Donate Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
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

  String _fmt(int n) => n >= 1000
      ? '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k'
      : '$n';
}
