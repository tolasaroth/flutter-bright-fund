// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:flutter/material.dart'
    show Colors, LinearProgressIndicator, Divider;

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key, required this.campaign});

  final Map<String, dynamic> campaign;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int _selectedAmountIndex = 1;
  final TextEditingController _customAmountController = TextEditingController();
  String _selectedBankOption = 'ABA';
  bool _isAnonymous = false;
  String _message = '';

  final List<Map<String, dynamic>> _presetAmounts = [
    {'amount': 10, 'label': '\$10'},
    {'amount': 25, 'label': '\$25'},
    {'amount': 50, 'label': '\$50'},
    {'amount': 100, 'label': '\$100'},
  ];

  final List<String> _bankOptions = ['ABA', 'ACLEDA', 'Wing Bank'];

  static const Map<String, String> _bankLogoAssets = {
    'ABA': '/logo/aba.svg',
    'ACLEDA': '/logo/aceleda.svg',
    'Wing Bank': '/logo/wing.svg',
  };

  double get _raisedAmount =>
      (widget.campaign['raisedAmount'] as num?)?.toDouble() ?? 0;
  double get _goalAmount =>
      (widget.campaign['goalAmount'] as num?)?.toDouble() ?? 1;
  double get _progress => _raisedAmount / _goalAmount;

  int get _selectedDonationAmount {
    if (_selectedAmountIndex < _presetAmounts.length) {
      return _presetAmounts[_selectedAmountIndex]['amount'] as int;
    }
    return int.tryParse(_customAmountController.text) ?? 0;
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
            CupertinoIcons.chevron_left,
            color: CupertinoColors.activeBlue,
            size: 28,
          ),
        ),
        middle: const Text('Donation'),
        backgroundColor: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            // Campaign Summary Card
            _buildCampaignSummary(),

            const SizedBox(height: 20),

            // Amount Selection
            _buildSectionHeader('Choose Amount'),
            _buildAmountSelector(),

            const SizedBox(height: 20),

            _buildSectionHeader('Select Bank Option'),
            _buildBankOptionSelector(),

            const SizedBox(height: 20),

            _buildSectionHeader('Personal Info'),
            _buildPersonalInfoSection(),

            const SizedBox(height: 20),

            _buildSectionHeader('Message of Support'),
            _buildMessageField(),

            const SizedBox(height: 20),

            // Donation Summary
            _buildDonationSummary(),
          ],
        ),
      ),
    );
  }

  // ── Campaign Summary ──────────────────────────────────────────────────────

  Widget _buildCampaignSummary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.campaign['categoryName'] as String? ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF007AFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  CupertinoIcons.clock,
                  size: 13,
                  color: CupertinoColors.secondaryLabel,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.campaign['daysLeft'] ?? '—'} days left',
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.campaign['title'] as String? ?? '',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.person_fill,
                  size: 13,
                  color: Color(0xFF007AFF),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.campaign['organizerName'] as String? ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  size: 13,
                  color: Color(0xFF007AFF),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${_raisedAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                    Text(
                      'raised of \$${_goalAmount.toStringAsFixed(0)} goal',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34C759).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                  '${((_raisedAmount / _goalAmount) * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF34C759),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E5EA),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF007AFF),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(CupertinoIcons.group_solid,
                    widget.campaign['donors'] as String? ?? '—', 'donors'),
                _buildDivider(),
                _buildStatItem(CupertinoIcons.calendar,
                    widget.campaign['daysLeft'] as String? ?? '—', 'days left'),
                _buildDivider(),
                _buildStatItem(
                  CupertinoIcons.arrow_up_right,
                  widget.campaign['weeklyDonors'] as String? ?? '—',
                  'this week',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF007AFF)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 0.5, color: CupertinoColors.separator);
  }

  // ── Section Header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.secondaryLabel,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Amount Selector ───────────────────────────────────────────────────────

  Widget _buildAmountSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preset chips
            Row(
              children: List.generate(_presetAmounts.length, (i) {
                final selected = _selectedAmountIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedAmountIndex = i),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: i < _presetAmounts.length - 1 ? 8 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF007AFF)
                            : const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _presetAmounts[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? CupertinoColors.white
                              : CupertinoColors.label,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            // Custom amount field
            GestureDetector(
              onTap: () =>
                  setState(() => _selectedAmountIndex = _presetAmounts.length),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _selectedAmountIndex == _presetAmounts.length
                      ? const Color(0xFF007AFF).withOpacity(0.07)
                      : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(10),
                  border: _selectedAmountIndex == _presetAmounts.length
                      ? Border.all(color: const Color(0xFF007AFF), width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    const Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: CupertinoTextField(
                        controller: _customAmountController,
                        placeholder: 'Custom amount',
                        keyboardType: TextInputType.number,
                        decoration: const BoxDecoration(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        placeholderStyle: const TextStyle(
                          color: CupertinoColors.tertiaryLabel,
                          fontSize: 15,
                        ),
                        onTap: () => setState(
                          () => _selectedAmountIndex = _presetAmounts.length,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Selected amount display
            if (_selectedDonationAmount > 0)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You are donating: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    Text(
                      '\$$_selectedDonationAmount',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Bank Option ──────────────────────────────────────────────────────────

  Widget _buildBankOptionSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
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
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: CupertinoColors.separator,
                          width: 0.5,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF007AFF).withOpacity(0.1)
                          : const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: logoAsset != null
                        ? SvgPicture.asset(logoAsset, fit: BoxFit.cover)
                        : Icon(
                            CupertinoIcons.building_2_fill,
                            size: 18,
                            color: isSelected
                                ? const Color(0xFF007AFF)
                                : CupertinoColors.secondaryLabel,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFF007AFF)
                          : CupertinoColors.label,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: Color(0xFF007AFF),
                      size: 22,
                    )
                  else
                    const Icon(
                      CupertinoIcons.circle,
                      color: CupertinoColors.tertiaryLabel,
                      size: 22,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Personal Info ─────────────────────────────────────────────────────────

  Widget _buildPersonalInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: CupertinoColors.separator, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.eye_slash_fill,
                size: 18,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Donate Anonymously', style: TextStyle(fontSize: 16)),
                  Text(
                    'Your name will not be shown publicly',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: _isAnonymous,
              onChanged: (v) => setState(() => _isAnonymous = v),
              activeColor: const Color(0xFF007AFF),
            ),
          ],
        ),
      ),
    );
  }

  // ── Message ───────────────────────────────────────────────────────────────

  Widget _buildMessageField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: CupertinoTextField(
        placeholder: 'Write a message of support...',
        maxLines: 4,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        style: const TextStyle(fontSize: 15),
        placeholderStyle: const TextStyle(
          color: CupertinoColors.tertiaryLabel,
          fontSize: 15,
        ),
        onChanged: (v) => setState(() => _message = v),
      ),
    );
  }

  // ── Donation Summary + CTA ────────────────────────────────────────────────

  Widget _buildDonationSummary() {
    final amount = _selectedDonationAmount;
    final fee = (amount * 0.03).toStringAsFixed(2);
    final total = (amount * 1.03).toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildSummaryRow(
                  'Donation Amount',
                  amount > 0 ? '\$$amount' : '--',
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Processing Fee (3%)',
                  amount > 0 ? '\$$fee' : '--',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: CupertinoColors.separator),
                ),
                _buildSummaryRow(
                  'Total',
                  amount > 0 ? '\$$total' : '--',
                  isBold: true,
                ),
              ],
            ),
          ),
          // Donate Now button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: CupertinoButton(
              onPressed: amount > 0 ? _handleDonate : null,
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: amount > 0
                      ? const LinearGradient(
                          colors: [Color(0xFF007AFF), Color(0xFF0055D4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: amount > 0 ? null : const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.heart_fill,
                      color: CupertinoColors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amount > 0 ? 'Donate \$$total Now' : 'Donate Now',
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CupertinoIcons.lock_fill,
                  size: 12,
                  color: CupertinoColors.secondaryLabel,
                ),
                SizedBox(width: 4),
                Text(
                  'Secure & encrypted payment',
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isBold
                ? CupertinoColors.label
                : CupertinoColors.secondaryLabel,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? const Color(0xFF007AFF) : CupertinoColors.label,
          ),
        ),
      ],
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _handleDonate() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirm Donation'),
        content: Text(
          'You are about to donate \$${(_selectedDonationAmount * 1.03).toStringAsFixed(2)} via $_selectedBankOption to "${widget.campaign['title'] ?? 'this campaign'}".',
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar();
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar() {
    final payableAmount = _selectedDonationAmount * 1.03;
    final amountLabel = payableAmount > 0
        ? payableAmount.toStringAsFixed(2)
        : '0.00';

    showCupertinoDialog(
      context: context,
      builder: (context) => Center(
        child: CupertinoPopupSurface(
          isSurfacePainted: true,
          child: Container(
            width: 360,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            color: const Color(0xFFF5F5F5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Scan KHQR to Pay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.asset(
                        '/images/KHQR.png',
                        width: 320,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 93,
                        left: 74,
                        child: Container(
                          color: const Color(0xFFFFFFFF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Color(0xFF3A3A3C),
                                height: 1,
                              ),
                              children: [
                                TextSpan(
                                  text: amountLabel,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' USD',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: CupertinoColors.activeBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
