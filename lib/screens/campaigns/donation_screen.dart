// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gofundme/state/app_state.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:flutter/material.dart' show Colors, LinearProgressIndicator, Divider;

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key, required this.campaignId});
  final String campaignId;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int _selectedAmountIndex = 1;
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedBankOption = 'ABA';
  bool _isAnonymous = false;

  final List<Map<String, dynamic>> _presetAmounts = [
    {'amount': 10, 'label': '\$10'},
    {'amount': 25, 'label': '\$25'},
    {'amount': 50, 'label': '\$50'},
    {'amount': 100, 'label': '\$100'},
  ];

  final List<String> _bankOptions = ['ABA', 'ACLEDA', 'Wing Bank'];

  static const Map<String, String> _bankLogoAssets = {
    'ABA': 'assets/logo/aba.svg',
    'ACLEDA': 'assets/logo/aceleda.svg',
    'Wing Bank': 'assets/logo/wing.svg',
  };

  @override
  void initState() {
    super.initState();
    AppState.instance.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_onStateChanged);
    _customAmountController.dispose();
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  Campaign? get _campaign => AppState.instance.findById(widget.campaignId);

  double get _raisedAmount => _campaign?.raisedAmount ?? 0;
  double get _goalAmount => _campaign?.goalAmount ?? 1;
  double get _progress => _raisedAmount / _goalAmount;

  int get _selectedDonationAmount {
    if (_selectedAmountIndex < _presetAmounts.length) {
      return _presetAmounts[_selectedAmountIndex]['amount'] as int;
    }
    return int.tryParse(_customAmountController.text) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final campaign = _campaign;
    if (campaign == null) {
      return const CupertinoPageScaffold(child: Center(child: Text('Campaign not found')));
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(CupertinoIcons.chevron_left, color: CupertinoColors.activeBlue, size: 28),
        ),
        middle: const Text('Donation'),
        backgroundColor: AppColors.surface,
        border: const Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.5)),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            _buildCampaignSummary(campaign),
            const SizedBox(height: 20),
            _buildSectionHeader('Choose Amount'),
            _buildAmountSelector(),
            const SizedBox(height: 20),
            _buildSectionHeader('Select Bank Option'),
            _buildBankOptionSelector(),
            const SizedBox(height: 20),
            _buildSectionHeader('Your Name'),
            _buildNameField(),
            const SizedBox(height: 20),
            _buildSectionHeader('Personal Info'),
            _buildPersonalInfoSection(),
            const SizedBox(height: 20),
            _buildSectionHeader('Message of Support'),
            _buildMessageField(),
            const SizedBox(height: 20),
            _buildDonationSummary(campaign),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignSummary(Campaign campaign) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(campaign.categoryName,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF007AFF), fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.clock, size: 13, color: CupertinoColors.secondaryLabel),
              const SizedBox(width: 4),
              Text(
                '${campaign.endDate != null ? campaign.endDate!.difference(DateTime.now()).inDays.clamp(0, 9999) : '—'} days left',
                style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
              ),
            ]),
            const SizedBox(height: 10),
            Text(campaign.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: CupertinoColors.label)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(CupertinoIcons.person_fill, size: 13, color: Color(0xFF007AFF)),
              const SizedBox(width: 4),
              Text(campaign.organizerName,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF007AFF), fontWeight: FontWeight.w500)),
              const SizedBox(width: 4),
              const Icon(CupertinoIcons.checkmark_seal_fill, size: 13, color: Color(0xFF007AFF)),
            ]),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('\$${_raisedAmount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF007AFF))),
                  Text('raised of \$${_goalAmount.toStringAsFixed(0)} goal',
                      style: const TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text('${(_progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF34C759))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress.clamp(0.0, 1.0), minHeight: 6,
                backgroundColor: const Color(0xFFE5E5EA),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
              ),
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildStatItem(CupertinoIcons.group_solid, '${campaign.donorCount}', 'donors'),
              _buildDivider(),
              _buildStatItem(CupertinoIcons.calendar,
                  campaign.endDate != null
                      ? '${campaign.endDate!.difference(DateTime.now()).inDays.clamp(0, 9999)}'
                      : '—',
                  'days left'),
              _buildDivider(),
              _buildStatItem(CupertinoIcons.arrow_up_right, '${campaign.weeklyDonors}', 'this week'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, size: 18, color: const Color(0xFF007AFF)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      Text(label, style: const TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel)),
    ]);
  }

  Widget _buildDivider() =>
      Container(height: 30, width: 0.5, color: CupertinoColors.separator);

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel, letterSpacing: 0.5)),
    );
  }

  Widget _buildAmountSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: List.generate(_presetAmounts.length, (i) {
              final selected = _selectedAmountIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedAmountIndex = i),
                  child: Container(
                    margin: EdgeInsets.only(right: i < _presetAmounts.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF007AFF) : const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(_presetAmounts[i]['label'] as String,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                            color: selected ? CupertinoColors.white : CupertinoColors.label)),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _selectedAmountIndex = _presetAmounts.length),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _selectedAmountIndex == _presetAmounts.length
                    ? const Color(0xFF007AFF).withOpacity(0.07) : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(10),
                border: _selectedAmountIndex == _presetAmounts.length
                    ? Border.all(color: const Color(0xFF007AFF), width: 1.5) : null,
              ),
              child: Row(children: [
                const Text('\$', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                    color: CupertinoColors.secondaryLabel)),
                const SizedBox(width: 6),
                Expanded(
                  child: CupertinoTextField(
                    controller: _customAmountController,
                    placeholder: 'Custom amount',
                    keyboardType: TextInputType.number,
                    decoration: const BoxDecoration(),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    placeholderStyle: const TextStyle(color: CupertinoColors.tertiaryLabel, fontSize: 15),
                    onTap: () => setState(() => _selectedAmountIndex = _presetAmounts.length),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ]),
            ),
          ),
          if (_selectedDonationAmount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('You are donating: ',
                    style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel)),
                Text('\$$_selectedDonationAmount',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF007AFF))),
              ]),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _buildBankOptionSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: List.generate(_bankOptions.length, (i) {
          final option = _bankOptions[i];
          final isSelected = _selectedBankOption == option;
          final isLast = i == _bankOptions.length - 1;
          final logoAsset = _bankLogoAssets[option];

          return GestureDetector(
            onTap: () => setState(() => _selectedBankOption = option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.5)),
              ),
              child: Row(children: [
                Container(
                  width: 36, height: 36, clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF007AFF).withOpacity(0.1) : const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: logoAsset != null
                      ? SvgPicture.asset(logoAsset, fit: BoxFit.cover)
                      : Icon(CupertinoIcons.building_2_fill, size: 18,
                          color: isSelected ? const Color(0xFF007AFF) : CupertinoColors.secondaryLabel),
                ),
                const SizedBox(width: 12),
                Text(option, style: TextStyle(fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? const Color(0xFF007AFF) : CupertinoColors.label)),
                const Spacer(),
                if (isSelected)
                  const Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF007AFF), size: 22)
                else
                  const Icon(CupertinoIcons.circle, color: CupertinoColors.tertiaryLabel, size: 22),
              ]),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: CupertinoTextField(
        controller: _nameController,
        placeholder: 'Your name (shown with donation)',
        decoration: const BoxDecoration(),
        style: const TextStyle(fontSize: 15),
        placeholderStyle: const TextStyle(color: CupertinoColors.tertiaryLabel, fontSize: 15),
        enabled: !_isAnonymous,
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: const Color(0xFFF2F2F7), borderRadius: BorderRadius.circular(8)),
            child: const Icon(CupertinoIcons.eye_slash_fill, size: 18, color: CupertinoColors.secondaryLabel),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Donate Anonymously', style: TextStyle(fontSize: 16)),
            Text('Your name will not be shown publicly',
                style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
          ])),
          CupertinoSwitch(
            value: _isAnonymous, activeColor: const Color(0xFF007AFF),
            onChanged: (v) => setState(() => _isAnonymous = v),
          ),
        ]),
      ),
    );
  }

  Widget _buildMessageField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(16),
      child: CupertinoTextField(
        controller: _messageController,
        placeholder: 'Write a message of support...',
        maxLines: 4,
        decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(12),
        style: const TextStyle(fontSize: 15),
        placeholderStyle: const TextStyle(color: CupertinoColors.tertiaryLabel, fontSize: 15),
      ),
    );
  }

  Widget _buildDonationSummary(Campaign campaign) {
    final amount = _selectedDonationAmount;
    final fee = (amount * 0.03).toStringAsFixed(2);
    final total = (amount * 1.03).toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Summary', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 14),
            _buildSummaryRow('Donation Amount', amount > 0 ? '\$$amount' : '--'),
            const SizedBox(height: 8),
            _buildSummaryRow('Processing Fee (3%)', amount > 0 ? '\$$fee' : '--'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: CupertinoColors.separator),
            ),
            _buildSummaryRow('Total', amount > 0 ? '\$$total' : '--', isBold: true),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: CupertinoButton(
            onPressed: amount > 0 ? () => _handleDonate(campaign) : null,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: amount > 0
                    ? const LinearGradient(
                        colors: [Color(0xFF007AFF), Color(0xFF0055D4)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                color: amount > 0 ? null : const Color(0xFFD1D1D6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(CupertinoIcons.heart_fill, color: CupertinoColors.white, size: 18),
                const SizedBox(width: 8),
                Text(amount > 0 ? 'Donate \$$total Now' : 'Donate Now',
                    style: const TextStyle(color: CupertinoColors.white, fontSize: 17, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(CupertinoIcons.lock_fill, size: 12, color: CupertinoColors.secondaryLabel),
            SizedBox(width: 4),
            Text('Secure & encrypted payment',
                style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 15,
          color: isBold ? CupertinoColors.label : CupertinoColors.secondaryLabel,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
      Text(value, style: TextStyle(fontSize: 15,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          color: isBold ? const Color(0xFF007AFF) : CupertinoColors.label)),
    ]);
  }

  void _handleDonate(Campaign campaign) {
    final amount = _selectedDonationAmount.toDouble();
    final total = (amount * 1.03).toStringAsFixed(2);

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Confirm Donation'),
        content: Text(
            'You are about to donate \$$total via $_selectedBankOption to "${campaign.title}".'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              // ✅ Persist donation to AppState in RAM
              final donorName = _nameController.text.trim().isEmpty
                  ? 'Anonymous'
                  : _nameController.text.trim();
              AppState.instance.addDonation(
                campaignId: widget.campaignId,
                donorName: donorName,
                amount: amount,
                message: _messageController.text.trim().isEmpty
                    ? null
                    : _messageController.text.trim(),
                isAnonymous: _isAnonymous,
                bankOption: _selectedBankOption,
              );
              _showSuccessDialog(total);
            },
            child: const Text('Confirm', style: TextStyle(color: CupertinoColors.activeBlue)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String total) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Thank you! 🎉'),
        content: Text('Your donation of \$$total has been recorded.\n\nScan KHQR in your banking app to complete the payment.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // go back to detail
            },
            child: const Text('Done', style: TextStyle(color: CupertinoColors.activeBlue)),
          ),
        ],
      ),
    );
  }
}