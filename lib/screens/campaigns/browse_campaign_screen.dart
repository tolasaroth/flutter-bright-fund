// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:gofundme/screens/campaigns/campaign_detail_screen.dart';
import 'package:gofundme/widgets/app_search_bar.dart';
export 'package:gofundme/widgets/campaign_tile.dart';
import 'package:gofundme/widgets/campaign_card.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:gofundme/state/app_state.dart';

class BrowseCampaignScreen extends StatefulWidget {
  const BrowseCampaignScreen({super.key});

  @override
  State<BrowseCampaignScreen> createState() => _BrowseCampaignScreenState();
}

class _BrowseCampaignScreenState extends State<BrowseCampaignScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Listen for state changes (new campaigns, donations, etc.)
    AppState.instance.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  List<Campaign> get _filteredCampaigns {
    return AppState.instance.campaigns.where((campaign) {
      final matchesCategory = _selectedCategory == 'All' ||
          campaign.categoryName.toLowerCase() == _selectedCategory.toLowerCase();

      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          campaign.title.toLowerCase().contains(query) ||
          campaign.organizerName.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCampaigns;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            AppSearchBar(
              onSearchChanged: (query) =>
                  setState(() => _searchQuery = query),
              onCategorySelected: (cat) =>
                  setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final campaign = filtered[index];
                        final map = campaign.toMap();
                        return CampaignCard(
                          title: campaign.title,
                          description: campaign.description,
                          imageUrl: campaign.coverImageUrl ??
                              'https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800',
                          coverImageBytes: campaign.coverImageBytes,
                          raisedAmount: campaign.raisedAmount,
                          goalAmount: campaign.goalAmount,
                          categoryName: campaign.categoryName,
                          organizerName: campaign.organizerName,
                          organizerImageUrl: map['organizerImageUrl'] as String?,
                          onTap: () =>
                              Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (_) => CampaignDetailScreen(
                                campaignId: campaign.id,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'No campaigns found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different search or category',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}