import 'package:flutter/cupertino.dart';
import 'package:gofundme/screens/campaigns/campaign_detail_screen.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';
import 'package:gofundme/widgets/campaign_card.dart';
import 'package:gofundme/screens/campaigns/create_campaign_screen.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

const _kMyCampaigns = [
  {
    'title': "Help Chan's Education",
    'description':
        "Support Chan's education and help him achieve his dreams and a brighter future.",
    'category': 'Education',
    'imageUrl':
        'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
    'raised': 2000.0,
    'goal': 4000.0,
    'donors': 128,
    'daysLeft': 18,
    'status': 'active',
    'organizerName': 'John Doe',
    'organizerImageUrl': 'https://i.pravatar.cc/50?img=5',
    'createdAt': 'Feb 14, 2026',
  },
  {
    'title': 'Community Garden Project',
    'description':
        'Turn an empty lot into a thriving community garden that feeds local families.',
    'category': 'Community',
    'imageUrl':
        'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=800',
    'raised': 3100.0,
    'goal': 6000.0,
    'donors': 74,
    'daysLeft': 25,
    'status': 'active',
    'organizerName': 'Maria Santos',
    'organizerImageUrl': 'https://i.pravatar.cc/50?img=6',
    'createdAt': 'Mar 1, 2026',
  },
  {
    'title': 'Save the Rainforest',
    'description':
        'Help us protect the Amazon rainforest and its wildlife for future generations.',
    'category': 'Environment',
    'imageUrl':
        'https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800',
    'raised': 25000.0,
    'goal': 25000.0,
    'donors': 410,
    'daysLeft': 0,
    'status': 'completed',
    'organizerName': 'John Doe',
    'organizerImageUrl': 'https://i.pravatar.cc/50?img=5',
    'createdAt': 'Jan 3, 2026',
  },
  {
    'title': 'New School Library',
    'description':
        'Help build a new library for the local school and inspire a love of reading.',
    'category': 'Education',
    'imageUrl':
        'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=800',
    'raised': 0.0,
    'goal': 10000.0,
    'donors': 0,
    'daysLeft': 30,
    'status': 'paused',
    'organizerName': 'Alice Kim',
    'organizerImageUrl': 'https://i.pravatar.cc/50?img=7',
    'createdAt': 'Mar 12, 2026',
  },
];

// ── Screen ────────────────────────────────────────────────────────────────────

class MyCampaignScreen extends StatefulWidget {
  const MyCampaignScreen({super.key});

  @override
  State<MyCampaignScreen> createState() => _MyCampaignScreenState();
}

class _MyCampaignScreenState extends State<MyCampaignScreen> {
  int _selectedFilter = 0; // 0=All 1=Active 2=Completed 3=Paused

  late final List<Map<String, dynamic>> _campaigns;

  @override
  void initState() {
    super.initState();
    _campaigns = _kMyCampaigns
        .map((c) => Map<String, dynamic>.from(c))
        .toList();
  }

  static const _filters = ['All', 'Active', 'Paused', 'Completed'];
  static const _shadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0) return _campaigns;
    final label = _filters[_selectedFilter].toLowerCase();
    return _campaigns.where((c) => (c['status'] as String) == label).toList();
  }

  // ── Summary stats ──────────────────────────────────────────────────────────

  double get _totalRaised =>
      _campaigns.fold(0.0, (s, c) => s + (c['raised'] as double));

  int get _totalDonors =>
      _campaigns.fold(0, (s, c) => s + (c['donors'] as int));

  int get _activeCampaigns =>
      _campaigns.where((c) => c['status'] == 'active').length;

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      navigationBar: AppNavigationBar(
        title: 'My Campaigns',
        showAddButton: true,
        onAddPressed: () {},
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
                    _buildSummaryCard(),
                    _buildFilterTabs(),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              _filtered.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final c = _filtered[index];
                        final last = index == _filtered.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: last ? 88 : 0),
                          child: CampaignCard(
                            title: c['title'] as String,
                            description: c['description'] as String,
                            imageUrl: c['imageUrl'] as String,
                            raisedAmount: c['raised'] as double,
                            goalAmount: c['goal'] as double,
                            categoryName: c['category'] as String,
                            organizerName: c['organizerName'] as String,
                            organizerImageUrl:
                                c['organizerImageUrl'] as String?,
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute(
                                    builder: (_) =>
                                        const CampaignDetailScreen(),
                                  ),
                                ),
                            onEdit: () => {
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                  builder: (_) =>
                                      const CreateCampaignScreen(isEditing: true),
                                ),
                              )
                            },
                            onDelete: () => _showDeleteDialog(context, index),
                          ),
                        );
                      }, childCount: _filtered.length),
                    ),
            ],
          ),
          // Create campaign FAB
          Positioned(right: 16, bottom: 26, child: _buildCreateFAB()),
        ],
      ),
    );
  }

  // ── Summary card ───────────────────────────────────────────────────────────

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CupertinoColors.activeBlue, CupertinoColors.systemBlue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4400C96B),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _summaryStatItem(
            '\$${_totalRaised >= 1000 ? '${(_totalRaised / 1000).toStringAsFixed(1)}k' : _totalRaised.toStringAsFixed(0)}',
            'Total Raised',
            CupertinoIcons.money_dollar_circle_fill,
          ),
          _verticalDivider(),
          _summaryStatItem(
            '$_activeCampaigns',
            'Active',
            CupertinoIcons.chart_bar_fill,
          ),
          _verticalDivider(),
          _summaryStatItem(
            '$_totalDonors',
            'Donors',
            CupertinoIcons.heart_fill,
          ),
        ],
      ),
    );
  }

  Widget _summaryStatItem(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xCCFFFFFF), size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 48, color: const Color(0x40FFFFFF));
  }

  // ── Filter tabs ────────────────────────────────────────────────────────────

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: active ? CupertinoColors.activeBlue : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: active ? const [_shadow] : null,
                border: active
                    ? null
                    : Border.all(color: const Color(0xFFDDE1E7), width: 1),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  color: active ? AppColors.white : AppColors.muted,
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              CupertinoIcons.chart_bar_alt_fill,
              size: 38,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No campaigns here',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Start a campaign and make a difference.',
            style: TextStyle(fontSize: 14, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  // ── Create FAB ─────────────────────────────────────────────────────────────

  Widget _buildCreateFAB() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => const CreateCampaignScreen()),
        );
      },
      child: Container(
        height: 54,
        width: 54,
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
            Icon(
              CupertinoIcons.add_circled_solid,
              color: AppColors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ── Edit dialog ────────────────────────────────────────────────────────────

  void _showEditDialog(BuildContext context, Map<String, dynamic> campaign) {
    final titleController = TextEditingController(
      text: campaign['title'] as String,
    );
    final descController = TextEditingController(
      text: campaign['description'] as String,
    );

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Edit Campaign'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              CupertinoTextField(
                controller: titleController,
                placeholder: 'Campaign title',
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: descController,
                placeholder: 'Description',
                maxLines: 3,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: false,
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Save'),
            onPressed: () {
              setState(() {
                campaign['title'] = titleController.text.trim();
                campaign['description'] = descController.text.trim();
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // ── Delete dialog ──────────────────────────────────────────────────────────

  void _showDeleteDialog(BuildContext context, int index) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Campaign'),
        content: const Text(
          'Are you sure you want to delete this campaign? This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: AppColors.muted)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              setState(() {
                final item = _filtered[index];
                _campaigns.remove(item);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
