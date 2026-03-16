import 'dart:typed_data';
import 'package:flutter/foundation.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class Campaign {
  final String id;
  String title;
  String description;
  String categoryName;
  double raisedAmount;
  double goalAmount;
  String organizerName;
  String organizerRole;
  String status; // active | paused | completed
  String? daysLeft;
  Uint8List? coverImageBytes;
  String? coverImageUrl; // fallback network url
  List<Donation> donations;
  List<CampaignUpdate> updates;
  List<Comment> comments;
  DateTime createdAt;
  DateTime? endDate;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryName,
    required this.raisedAmount,
    required this.goalAmount,
    required this.organizerName,
    this.organizerRole = 'Campaign Organiser',
    this.status = 'active',
    this.daysLeft,
    this.coverImageBytes,
    this.coverImageUrl,
    List<Donation>? donations,
    List<CampaignUpdate>? updates,
    List<Comment>? comments,
    DateTime? createdAt,
    this.endDate,
  })  : donations = donations ?? [],
        updates = updates ?? [],
        comments = comments ?? [],
        createdAt = createdAt ?? DateTime.now();

  int get donorCount => donations.length;

  int get weeklyDonors {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return donations.where((d) => d.createdAt.isAfter(weekAgo)).length;
  }

  double get progress => (raisedAmount / goalAmount).clamp(0.0, 1.0);

  /// Convert to the legacy Map<String,dynamic> format expected by existing screens
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryName': categoryName,
      'raisedAmount': raisedAmount,
      'goalAmount': goalAmount,
      'organizerName': organizerName,
      'organizerRole': organizerRole,
      'organizerImageUrl': 'https://i.pravatar.cc/50?img=5',
      'imageUrl': coverImageUrl ?? 'https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800',
      'coverImageBytes': coverImageBytes,
      'status': status,
      'donors': '$donorCount',
      'daysLeft': daysLeft ?? _computeDaysLeft(),
      'weeklyDonors': '$weeklyDonors',
      'createdAt': '${createdAt.year}',
    };
  }

  String _computeDaysLeft() {
    if (endDate == null) return '—';
    final diff = endDate!.difference(DateTime.now()).inDays;
    return diff < 0 ? '0' : '$diff';
  }

  Campaign copyWith({
    String? title,
    String? description,
    String? categoryName,
    double? raisedAmount,
    double? goalAmount,
    String? organizerName,
    String? organizerRole,
    String? status,
    String? daysLeft,
    Uint8List? coverImageBytes,
    String? coverImageUrl,
    DateTime? endDate,
  }) {
    return Campaign(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryName: categoryName ?? this.categoryName,
      raisedAmount: raisedAmount ?? this.raisedAmount,
      goalAmount: goalAmount ?? this.goalAmount,
      organizerName: organizerName ?? this.organizerName,
      organizerRole: organizerRole ?? this.organizerRole,
      status: status ?? this.status,
      daysLeft: daysLeft ?? this.daysLeft,
      coverImageBytes: coverImageBytes ?? this.coverImageBytes,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      donations: donations,
      updates: updates,
      comments: comments,
      createdAt: createdAt,
      endDate: endDate ?? this.endDate,
    );
  }
}

class Donation {
  final String id;
  final String campaignId;
  final String donorName;
  final double amount;
  final String? message;
  final bool isAnonymous;
  final String bankOption;
  final DateTime createdAt;

  Donation({
    required this.id,
    required this.campaignId,
    required this.donorName,
    required this.amount,
    this.message,
    this.isAnonymous = false,
    this.bankOption = 'ABA',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get displayName => isAnonymous ? 'Anonymous' : donorName;

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class CampaignUpdate {
  final String id;
  final String author;
  final String avatarUrl;
  final String message;
  final DateTime createdAt;

  CampaignUpdate({
    required this.id,
    required this.author,
    required this.avatarUrl,
    required this.message,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get formattedDate {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[createdAt.month - 1]} ${createdAt.day}';
  }
}

class Comment {
  final String id;
  final String name;
  final double donationAmount;
  final String message;
  final String avatarUrl;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.name,
    required this.donationAmount,
    required this.message,
    required this.avatarUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays == 0) return 'today';
    return '${diff.inDays}d';
  }

  String get formattedAmount => '\$${donationAmount.toStringAsFixed(0)}';
}

// ── AppState Singleton ─────────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  AppState._internal() {
    _seedData();
  }
  static final AppState instance = AppState._internal();

  final List<Campaign> _campaigns = [];
  int _idCounter = 100;

  String _newId() => '${++_idCounter}';

  List<Campaign> get campaigns => List.unmodifiable(_campaigns);

  List<Campaign> get myCampaigns => _campaigns.toList();

  Campaign? findById(String id) {
    try {
      return _campaigns.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  Campaign addCampaign({
    required String title,
    required String description,
    required String categoryName,
    required double goalAmount,
    double raisedAmount = 0,
    String organizerName = 'You',
    String status = 'active',
    Uint8List? coverImageBytes,
    String? coverImageUrl,
    DateTime? endDate,
  }) {
    final campaign = Campaign(
      id: _newId(),
      title: title,
      description: description,
      categoryName: categoryName,
      raisedAmount: raisedAmount,
      goalAmount: goalAmount,
      organizerName: organizerName,
      status: status,
      coverImageBytes: coverImageBytes,
      coverImageUrl: coverImageUrl,
      endDate: endDate,
    );
    _campaigns.insert(0, campaign);
    notifyListeners();
    return campaign;
  }

  void updateCampaign(
    String id, {
    String? title,
    String? description,
    String? categoryName,
    double? goalAmount,
    double? raisedAmount,
    String? status,
    Uint8List? coverImageBytes,
    String? coverImageUrl,
    DateTime? endDate,
  }) {
    final index = _campaigns.indexWhere((c) => c.id == id);
    if (index == -1) return;
    final c = _campaigns[index];
    if (title != null) c.title = title;
    if (description != null) c.description = description;
    if (categoryName != null) c.categoryName = categoryName;
    if (goalAmount != null) c.goalAmount = goalAmount;
    if (raisedAmount != null) c.raisedAmount = raisedAmount;
    if (status != null) c.status = status;
    if (coverImageBytes != null) c.coverImageBytes = coverImageBytes;
    if (coverImageUrl != null) c.coverImageUrl = coverImageUrl;
    if (endDate != null) c.endDate = endDate;
    notifyListeners();
  }

  void deleteCampaign(String id) {
    _campaigns.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ── Donations ──────────────────────────────────────────────────────────────

  Donation addDonation({
    required String campaignId,
    required String donorName,
    required double amount,
    String? message,
    bool isAnonymous = false,
    String bankOption = 'ABA',
  }) {
    final campaign = findById(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final donation = Donation(
      id: _newId(),
      campaignId: campaignId,
      donorName: donorName,
      amount: amount,
      message: message,
      isAnonymous: isAnonymous,
      bankOption: bankOption,
    );

    campaign.donations.insert(0, donation);
    campaign.raisedAmount += amount;

    // Add auto comment if message provided
    if (message != null && message.trim().isNotEmpty) {
      addComment(
        campaignId: campaignId,
        name: donation.displayName,
        donationAmount: amount,
        message: message,
        avatarUrl: 'https://i.pravatar.cc/50?img=${(amount % 70).toInt() + 1}',
      );
    }

    notifyListeners();
    return donation;
  }

  // ── Updates ────────────────────────────────────────────────────────────────

  CampaignUpdate addUpdate({
    required String campaignId,
    required String author,
    required String message,
    String avatarUrl = 'https://i.pravatar.cc/50?img=5',
  }) {
    final campaign = findById(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final update = CampaignUpdate(
      id: _newId(),
      author: author,
      avatarUrl: avatarUrl,
      message: message,
    );
    campaign.updates.insert(0, update);
    notifyListeners();
    return update;
  }

  // ── Comments ───────────────────────────────────────────────────────────────

  Comment addComment({
    required String campaignId,
    required String name,
    required double donationAmount,
    required String message,
    required String avatarUrl,
  }) {
    final campaign = findById(campaignId);
    if (campaign == null) throw Exception('Campaign not found');

    final comment = Comment(
      id: _newId(),
      name: name,
      donationAmount: donationAmount,
      message: message,
      avatarUrl: avatarUrl,
    );
    campaign.comments.insert(0, comment);
    notifyListeners();
    return comment;
  }

  void deleteComment(String campaignId, String commentId) {
    final campaign = findById(campaignId);
    if (campaign == null) return;
    campaign.comments.removeWhere((c) => c.id == commentId);
    notifyListeners();
  }

  // ── Seed Data ──────────────────────────────────────────────────────────────

  void _seedData() {
    final c1 = Campaign(
      id: '1',
      title: 'Save the Rainforest',
      description: 'Help us protect the Amazon rainforest and its wildlife for future generations. Every dollar helps fund conservation efforts, support local communities, and fight illegal deforestation.',
      categoryName: 'Environment',
      raisedAmount: 12500.0,
      goalAmount: 25000.0,
      organizerName: 'John Doe',
      status: 'active',
      coverImageUrl: 'https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800',
      endDate: DateTime.now().add(const Duration(days: 15)),
    );
    c1.updates.addAll([
      CampaignUpdate(id: 'u1', author: 'John Doe', avatarUrl: 'https://i.pravatar.cc/50?img=5',
          message: 'We have reached 50% of our goal! Thank you so much for your support and generosity. Every share matters!',
          createdAt: DateTime.now().subtract(const Duration(days: 6))),
      CampaignUpdate(id: 'u2', author: 'John Doe', avatarUrl: 'https://i.pravatar.cc/50?img=5',
          message: 'Only 10 days left to reach our goal! Please share and donate if you can.',
          createdAt: DateTime.now().subtract(const Duration(days: 15))),
    ]);
    c1.donations.addAll([
      Donation(id: 'd1', campaignId: '1', donorName: 'Jane Smith', amount: 200,
          createdAt: DateTime.now().subtract(const Duration(hours: 2))),
      Donation(id: 'd2', campaignId: '1', donorName: 'Alice Smith', amount: 150,
          createdAt: DateTime.now().subtract(const Duration(hours: 5))),
      Donation(id: 'd3', campaignId: '1', donorName: 'Bob Lee', amount: 80,
          createdAt: DateTime.now().subtract(const Duration(hours: 8))),
    ]);
    c1.comments.addAll([
      Comment(id: 'cm1', name: 'Jane Smith', donationAmount: 200,
          message: 'Great campaign! I just donated. Wishing you all the best! 🙏',
          avatarUrl: 'https://i.pravatar.cc/50?img=20',
          createdAt: DateTime.now().subtract(const Duration(days: 2))),
      Comment(id: 'cm2', name: 'Alice Smith', donationAmount: 150,
          message: 'I just donated as well! Keep up the great work. Never give up! ⭐',
          avatarUrl: 'https://i.pravatar.cc/50?img=21',
          createdAt: DateTime.now().subtract(const Duration(days: 3))),
    ]);

    final c2 = Campaign(
      id: '2',
      title: "Help Chan's Education",
      description: "Support Chan's education and help him achieve his dreams and a brighter future. Chan is a talented student from a low-income family who needs support for tuition and school supplies.",
      categoryName: 'Education',
      raisedAmount: 2000.0,
      goalAmount: 4000.0,
      organizerName: 'Jane Smith',
      status: 'active',
      coverImageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
      endDate: DateTime.now().add(const Duration(days: 18)),
    );

    final c3 = Campaign(
      id: '3',
      title: 'Medical Aid for Sophea',
      description: 'Sophea needs urgent surgery. Every contribution brings her closer to recovery. She has been diagnosed with a condition requiring immediate treatment.',
      categoryName: 'Medical',
      raisedAmount: 8750.0,
      goalAmount: 15000.0,
      organizerName: 'Alice Kim',
      status: 'active',
      coverImageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
      endDate: DateTime.now().add(const Duration(days: 10)),
    );

    final c4 = Campaign(
      id: '4',
      title: 'Community Garden Project',
      description: 'Turn an empty lot into a thriving community garden that feeds local families. We plan to grow vegetables, fruits and create a green space for everyone.',
      categoryName: 'Community',
      raisedAmount: 3100.0,
      goalAmount: 6000.0,
      organizerName: 'Maria Santos',
      status: 'active',
      coverImageUrl: 'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=800',
      endDate: DateTime.now().add(const Duration(days: 25)),
    );

    _campaigns.addAll([c1, c2, c3, c4]);
  }
}