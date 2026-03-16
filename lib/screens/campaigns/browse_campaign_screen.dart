// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:gofundme/screens/campaigns/campaign_detail_screen.dart';
import 'package:gofundme/widgets/app_search_bar.dart';
export 'package:gofundme/widgets/campaign_tile.dart';
import 'package:gofundme/widgets/campaign_card.dart';
import 'package:gofundme/utils/colors.dart';

class BrowseCampaignScreen extends StatefulWidget {
  const BrowseCampaignScreen({super.key});

  @override
  State<BrowseCampaignScreen> createState() => _BrowseCampaignScreenState();
}

final List<Map<String, dynamic>> _campaigns = [
  {
    'title': 'Save the Rainforest',
    'description':
        'Help us protect the Amazon rainforest and its wildlife for future generations.',
    'imageUrl':
        'https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800',
    'raisedAmount': 12500.0,
    'goalAmount': 25000.0,
    'categoryName': 'Environment',
    'organizerName': 'John Doe',
    'organizerImageUrl': 'https://via.placeholder.com/150',
  },
  {
    'title': "Help Chan's Education",
    'description':
        "Support Chan's education and help him achieve his dreams and a brighter future.",
    'imageUrl':
        'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
    'raisedAmount': 2000.0,
    'goalAmount': 4000.0,
    'categoryName': 'Education',
    'organizerName': 'Jane Smith',
    'organizerImageUrl': 'https://via.placeholder.com/150',
  },
  {
    'title': 'Medical Aid for Sophea',
    'description':
        'Sophea needs urgent surgery. Every contribution brings her closer to recovery.',
    'imageUrl':
        'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
    'raisedAmount': 8750.0,
    'goalAmount': 15000.0,
    'categoryName': 'Medical',
    'organizerName': 'Alice Kim',
    'organizerImageUrl': 'https://via.placeholder.com/150',
  },
  {
    'title': 'Rebuild After the Flood',
    'description':
        'Families lost everything in the recent floods. Help them rebuild their homes.',
    'imageUrl':
        'https://images.unsplash.com/photo-1547683905-f686c993aae5?w=800',
    'raisedAmount': 5300.0,
    'goalAmount': 20000.0,
    'categoryName': 'Disaster Relief',
    'organizerName': 'Bob Lee',
    'organizerImageUrl': 'https://via.placeholder.com/150',
  },
  {
    'title': 'Community Garden Project',
    'description':
        'Turn an empty lot into a thriving community garden that feeds local families.',
    'imageUrl':
        'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=800',
    'raisedAmount': 3100.0,
    'goalAmount': 6000.0,
    'categoryName': 'Community',
    'organizerName': 'Maria Santos',
    'organizerImageUrl': 'https://via.placeholder.com/150',
  },
];

class _BrowseCampaignScreenState extends State<BrowseCampaignScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Map<String, dynamic>> get _filteredCampaigns {
    return _campaigns.where((campaign) {
      // Category filter — 'All' shows everything
      final matchesCategory = _selectedCategory == 'All' ||
          campaign['categoryName']
              .toString()
              .toLowerCase() ==
              _selectedCategory.toLowerCase();

      // Search filter — matches title or organizer name
      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          campaign['title'].toString().toLowerCase().contains(query) ||
          campaign['organizerName'].toString().toLowerCase().contains(query);

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
                        return CampaignCard(
                          title: campaign['title'],
                          description: campaign['description'],
                          imageUrl: campaign['imageUrl'],
                          raisedAmount: campaign['raisedAmount'],
                          goalAmount: campaign['goalAmount'],
                          categoryName: campaign['categoryName'],
                          organizerName: campaign['organizerName'],
                          organizerImageUrl: campaign['organizerImageUrl'],
                          onTap: () =>
                              Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              // ✅ Pass the tapped campaign to the detail screen
                              builder: (_) =>
                                  CampaignDetailScreen(campaign: campaign),
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
          const Text(
            '🔍',
            style: TextStyle(fontSize: 48),
          ),
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