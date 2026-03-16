import 'dart:typed_data';
import 'dart:io';
import 'package:gofundme/services/campaign_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gofundme/services/category_service.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:file_picker/file_picker.dart';

class _C {
  static const ink = Color(0xFF1A1A1A);
  static const muted = Color(0xFF8E8E93);
  static const border = Color(0xFFE8E3DC);
  static const accent = Color(0xFF007AFF);
  static const red = Color(0xFFFF3B30);
  static const green = Color(0xFF34C759);
  static const indigo = Color(0xFF5856D6);
  static const orange = Color(0xFFFF9500);
  static const teal = Color(0xFF32ADE6);
  static const violet = Color(0xFFAF52DE);
  static const pink = Color(0xFFFF2D55);
}

class _Category {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  const _Category({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

const _categories = [
  _Category(
    id: 'education',
    label: 'Education',
    icon: CupertinoIcons.book_fill,
    color: _C.accent,
  ),
  _Category(
    id: 'medical',
    label: 'Medical',
    icon: CupertinoIcons.heart_fill,
    color: _C.red,
  ),
  _Category(
    id: 'community',
    label: 'Community',
    icon: CupertinoIcons.person_3_fill,
    color: _C.green,
  ),
  _Category(
    id: 'environment',
    label: 'Environment',
    icon: CupertinoIcons.leaf_arrow_circlepath,
    color: Color(0xFF30D158),
  ),
  _Category(
    id: 'disaster',
    label: 'Disaster',
    icon: CupertinoIcons.shield_fill,
    color: _C.orange,
  ),
  _Category(
    id: 'animal',
    label: 'Animals',
    icon: CupertinoIcons.paw,
    color: _C.violet,
  ),
  _Category(
    id: 'arts',
    label: 'Arts',
    icon: CupertinoIcons.paintbrush_fill,
    color: _C.pink,
  ),
  _Category(
    id: 'sports',
    label: 'Sports',
    icon: CupertinoIcons.sportscourt_fill,
    color: _C.teal,
  ),
];

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────
class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {

  final CampaignService _campaignService = CampaignService();

  final _titleCtrl = TextEditingController();
  final _taglineCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _storyCtrl = TextEditingController();
  final _thankCommentCtrl = TextEditingController();
  final _currentAmountCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _accountNameCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();

  List<_Category> _availableCategories = _categories;

  String? _selectedCategoryId;
  String _selectedStatus = 'active';
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _hasDeadline = true;
  Uint8List? _coverImageBytes;
  Uint8List? _qrImageBytes;
  String? _pdfFileName;
  String _selectedBank = 'ABA';

  static const _bankOptions = ['ABA', 'ACLEDA', 'Wing Bank'];
  static const _bankLogoAssets = {
    'ABA': 'assets/logo/aba.svg',
    'ACLEDA': 'assets/logo/aceleda.svg',
    'Wing Bank': 'assets/logo/wing.svg',
  };

  // Validation
  String? _titleError;
  String? _storyError;
  String? _thankCommentError;
  String? _currentAmountError;
  String? _goalError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  _Category? _matchPresetCategory(String name) {
    final normalizedName = name.trim().toLowerCase();
    for (final category in _categories) {
      if (category.label.toLowerCase() == normalizedName ||
          normalizedName.contains(category.label.toLowerCase()) ||
          category.id.toLowerCase() == normalizedName) {
        return category;
      }
    }
    return null;
  }

  Future<File> _bytesToFile(Uint8List bytes, String name) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    return await file.writeAsBytes(bytes);
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await categoryService.fetchCategories();
      if (!mounted || categories.isEmpty) return;

      final mapped = categories.asMap().entries.map((entry) {
        final apiCategory = entry.value;
        final name = apiCategory.name.trim();
        final matched = _matchPresetCategory(name);
        final fallback = _categories[entry.key % _categories.length];

        return _Category(
          id: apiCategory.id,
          label: name,
          icon: matched?.icon ?? fallback.icon,
          color: matched?.color ?? fallback.color,
        );
      }).toList();

      setState(() {
        _availableCategories = mapped;
        if (_selectedCategoryId != null &&
            !_availableCategories.any((c) => c.id == _selectedCategoryId)) {
          _selectedCategoryId = null;
        }
      });
    } catch (_) {
      // Keep preset categories if the API call fails.
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _locationCtrl.dispose();
    _websiteCtrl.dispose();
    _storyCtrl.dispose();
    _thankCommentCtrl.dispose();
    _currentAmountCtrl.dispose();
    _goalCtrl.dispose();
    _bankNameCtrl.dispose();
    _accountNameCtrl.dispose();
    _accountNumberCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get _formattedDate {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${m[_endDate.month - 1]} ${_endDate.day}, ${_endDate.year}';
  }

  bool _validate() {
    setState(() {
      _titleError = _titleCtrl.text.trim().isEmpty ? 'Required' : null;
      _categoryError = _selectedCategoryId == null
          ? 'Please choose a category'
          : null;
      _storyError = _storyCtrl.text.trim().length < 20
          ? 'Write at least 20 characters'
          : null;

      if (widget.isEditing) {
        _thankCommentError = _thankCommentCtrl.text.trim().isEmpty
            ? 'Required'
            : null;
      }

      final current = double.tryParse(
        _currentAmountCtrl.text.replaceAll(',', ''),
      );
      _currentAmountError = (current == null || current < 0)
          ? 'Enter a valid current amount'
          : null;

      final g = double.tryParse(_goalCtrl.text.replaceAll(',', ''));
      _goalError = (g == null || g <= 0) ? 'Enter a valid amount' : null;

      if (_currentAmountError == null && _goalError == null && current! > g!) {
        _currentAmountError = 'Current amount cannot exceed fundraising goal';
      }
    });
    return _titleError == null &&
        _categoryError == null &&
        _storyError == null &&
        _thankCommentError == null &&
        _currentAmountError == null &&
        _goalError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    try {
      final goal = double.parse(_goalCtrl.text.replaceAll(',', ''));

      final result = await _campaignService.createCampaign(
        title: _titleCtrl.text.trim(),
        description: _storyCtrl.text.trim(),
        goalAmount: goal,
        categoryId: _selectedCategoryId,
        startDate: DateTime.now().toIso8601String(),
        endDate: _hasDeadline ? _endDate.toIso8601String() : null,
      );

      final campaignId = result['id'];

      /// Upload Cover Image
      if (_coverImageBytes != null) {
        final file = await _bytesToFile(_coverImageBytes!, 'cover.jpg');
        await _campaignService.uploadImages(campaignId, [file]);
      }

      /// Upload PDF Document
      if (_pdfFileName != null) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          await _campaignService.uploadDocuments(campaignId, [file]);
        }
      }

      if (!mounted) return;

      showCupertinoDialog<void>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Campaign Created! 🎉'),
          content: Text('"${_titleCtrl.text.trim()}" was submitted successfully.'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      showCupertinoDialog<void>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: Text(
                    'Done',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _endDate,
                minimumDate: DateTime.now().add(const Duration(days: 1)),
                maximumDate: DateTime.now().add(const Duration(days: 365)),
                onDateTimeChanged: (dt) => setState(() => _endDate = dt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCoverImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final bytes = result.files.first.bytes;
      if (bytes != null) setState(() => _coverImageBytes = bytes);
    }
  }

  Future<void> _pickQrImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final bytes = result.files.first.bytes;
      if (bytes != null) setState(() => _qrImageBytes = bytes);
    }
  }

  Future<void> _pickPdfDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pdfFileName = result.files.first.name);
    }
  }

  void _showImageSheet(String title, Future<void> Function() onPick) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(title),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(sheetContext);
              await onPick();
            },
            child: const Text(
              'Choose from Library',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: const Text(
            'Cancel',
            style: TextStyle(color: CupertinoColors.destructiveRed),
          ),
        ),
      ),
    );
  }

  void _showDocumentSheet(String title, Future<void> Function() onPick) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(title),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(sheetContext);
              await onPick();
            },
            child: const Text(
              'Choose PDF from Files',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: const Text(
            'Cancel',
            style: TextStyle(color: CupertinoColors.destructiveRed),
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.chevron_left,
                size: 28,
                color: CupertinoColors.activeBlue,
              ),
            ],
          ),
        ),
        middle: Text(
          widget.isEditing ? 'Edit Campaign' : 'New Campaign',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    _FieldGroup(
                      label: 'Cover Photo',
                      child: _ImagePickerField(
                        hasImage: _coverImageBytes != null,
                        imageBytes: _coverImageBytes,
                        icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                        accentColor: _C.accent,
                        emptyLabel: 'Add Cover Photo',
                        emptyHint: 'Campaigns with photos raise 3× more',
                        doneLabel: 'Cover photo added',
                        onTap: () =>
                            _showImageSheet('Cover Photo', _pickCoverImage),
                        onRemove: () => setState(() => _coverImageBytes = null),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _FieldGroup(
                      label: 'Campaign Title *',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StyledTextField(
                            controller: _titleCtrl,
                            placeholder: 'e.g. Help Build a Village School',
                            autocorrect: true,
                            onChanged: (_) {
                              if (_titleError != null) {
                                setState(() => _titleError = null);
                              }
                            },
                          ),
                          if (_titleError != null) _ErrorText(_titleError!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _FieldGroup(
                      label: 'Your Story *',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StyledTextField(
                            controller: _storyCtrl,
                            placeholder:
                                'Explain the problem, who it affects, and how the funds will create real change...',
                            maxLines: 8,
                            onChanged: (_) {
                              if (_storyError != null) {
                                setState(() => _storyError = null);
                              }
                            },
                          ),
                          if (_storyError != null) _ErrorText(_storyError!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (widget.isEditing) ...[
                      _FieldGroup(
                        label: 'Thank Comment *',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StyledTextField(
                              controller: _thankCommentCtrl,
                              placeholder:
                                  'Write a thank-you message for your donors...',
                              maxLines: 4,
                              onChanged: (_) {
                                if (_thankCommentError != null) {
                                  setState(() => _thankCommentError = null);
                                }
                              },
                            ),
                            if (_thankCommentError != null)
                              _ErrorText(_thankCommentError!),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    _FieldGroup(
                      label: 'Status',
                      child: _StatusSelector(
                        selectedStatus: _selectedStatus,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedStatus = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    _FieldGroup(
                      label: 'Category *',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_categoryError != null) ...[
                            _ErrorText(_categoryError!),
                            const SizedBox(height: 6),
                          ],
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                            children: _availableCategories
                                .map(
                                  (cat) => _CategoryChip(
                                    category: cat,
                                    isSelected: _selectedCategoryId == cat.id,
                                    onTap: () => setState(() {
                                      _selectedCategoryId = cat.id;
                                      _categoryError = null;
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _FieldGroup(
                      label: 'Supporting Document (PDF)',
                      child: _ImagePickerField(
                        hasImage: _pdfFileName != null,
                        icon: CupertinoIcons.doc_text_fill,
                        accentColor: _C.teal,
                        emptyLabel: 'Upload PDF Document',
                        emptyHint: 'Proposal, budget, or verification document',
                        doneLabel: _pdfFileName ?? 'PDF document uploaded',
                        onTap: () => _showDocumentSheet(
                          'Upload PDF Document',
                          _pickPdfDocument,
                        ),
                        onRemove: () => setState(() => _pdfFileName = null),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _FieldGroup(
                      label: 'Current Amount (USD) *',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StyledTextField(
                            controller: _currentAmountCtrl,
                            placeholder: '0',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            prefix: Text(
                              '\$',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _C.ink,
                              ),
                            ),
                            onChanged: (_) {
                              if (_currentAmountError != null) {
                                setState(() => _currentAmountError = null);
                              }
                            },
                          ),
                          if (_currentAmountError != null)
                            _ErrorText(_currentAmountError!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _FieldGroup(
                      label: 'Fundraising Goal (USD) *',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StyledTextField(
                            controller: _goalCtrl,
                            placeholder: '0',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            prefix: Text(
                              '\$',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _C.ink,
                              ),
                            ),
                            onChanged: (_) {
                              if (_goalError != null) {
                                setState(() => _goalError = null);
                              }
                            },
                          ),
                          if (_goalError != null) _ErrorText(_goalError!),
                          const SizedBox(height: 10),
                          // Quick-select chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                ['1,000', '5,000', '10,000', '25,000', '50,000']
                                    .map(
                                      (a) => _QuickAmountChip(
                                        label: '\$$a',
                                        onTap: () =>
                                            setState(() => _goalCtrl.text = a),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── End Date ────────────────────────────────────────
                    _FieldGroup(
                      label: 'Campaign Duration',
                      child: Column(
                        children: [
                          _SwitchField(
                            label: 'Set End Date',
                            value: _hasDeadline,
                            onChanged: (v) => setState(() => _hasDeadline = v),
                          ),
                          if (_hasDeadline) ...[
                            const SizedBox(height: 10),
                            _TappableField(
                              label: 'End Date',
                              value: _formattedDate,
                              onTap: _showDatePicker,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Bank Selection ──────────────────────────────────
                    _FieldGroup(
                      label: 'Receiving Bank',
                      child: _BankSelector(
                        options: _bankOptions,
                        logoAssets: _bankLogoAssets,
                        selected: _selectedBank,
                        onChanged: (bank) => setState(() => _selectedBank = bank),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── QR Code Upload ──────────────────────────────────
                    _FieldGroup(
                      label: 'Payment QR Code',
                      child: _ImagePickerField(
                        hasImage: _qrImageBytes != null,
                        imageBytes: _qrImageBytes,
                        icon: CupertinoIcons.qrcode,
                        accentColor: _C.indigo,
                        emptyLabel: 'Upload QR Code',
                        emptyHint: 'KHQR, ABA, Wing or any scan-to-pay image',
                        doneLabel: 'QR code uploaded',
                        onTap: () => _showImageSheet(
                          'Upload Payment QR Code',
                          _pickQrImage,
                        ),
                        onRemove: () => setState(() => _qrImageBytes = null),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Launch Button ───────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: _C.accent,
                        borderRadius: BorderRadius.circular(16),
                        onPressed: _submit,
                        child: Text(
                          widget.isEditing
                              ? 'Save Changes'
                              : 'Launch Campaign 🚀',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40 + MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.04 * 11.5,
            color: _C.muted,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _StyledTextField extends StatefulWidget {
  const _StyledTextField({
    this.controller,
    required this.placeholder,
    this.keyboardType,
    this.autocorrect = true,
    this.prefix,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final Widget? prefix;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  State<_StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<_StyledTextField> {
  late final TextEditingController _fallbackController;

  @override
  void initState() {
    super.initState();
    _fallbackController = TextEditingController();
  }

  @override
  void dispose() {
    _fallbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller ?? _fallbackController;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 1.5),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: widget.placeholder,
        keyboardType: widget.keyboardType,
        autocorrect: widget.autocorrect,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(),
        style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
        placeholderStyle: GoogleFonts.dmSans(
          fontSize: 15,
          color: const Color(0xFFC0B9AE),
        ),
        prefix: widget.prefix != null
            ? Padding(
                padding: const EdgeInsets.only(left: 14),
                child: widget.prefix,
              )
            : null,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}

class _SwitchField extends StatelessWidget {
  const _SwitchField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: _C.accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({
    required this.selectedStatus,
    required this.onChanged,
  });

  final String selectedStatus;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 1.5),
      ),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<String>(
          groupValue: selectedStatus,
          children: {
            'active': Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Active',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _C.green,
                ),
              ),
            ),
            'paused': Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Paused',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemRed,
                ),
              ),
            ),
            'completed': Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Completed',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _C.accent,
                ),
              ),
            ),
          },
          thumbColor: const Color(0xFFF2EEE8),
          onValueChanged: onChanged,
        ),
      ),
    );
  }
}

class _TappableField extends StatelessWidget {
  const _TappableField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 1.5),
        ),
        child: Row(
          children: [
            Text(label, style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink)),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _C.accent,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(CupertinoIcons.chevron_right, size: 14, color: _C.muted),
          ],
        ),
      ),
    );
  }
}

class _ImagePickerField extends StatelessWidget {
  const _ImagePickerField({
    required this.hasImage,
    this.imageBytes,
    required this.icon,
    required this.accentColor,
    required this.emptyLabel,
    required this.emptyHint,
    required this.doneLabel,
    required this.onTap,
    required this.onRemove,
  });

  final bool hasImage;
  final Uint8List? imageBytes;
  final IconData icon;
  final Color accentColor;
  final String emptyLabel;
  final String emptyHint;
  final String doneLabel;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: hasImage
            ? accentColor.withValues(alpha: 0.06)
            : CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasImage ? accentColor.withValues(alpha: 0.4) : _C.border,
          width: 1.5,
        ),
      ),
      child: hasImage
          ? Row(
              children: [
                if (imageBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(
                      imageBytes!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Icon(
                    CupertinoIcons.checkmark_seal_fill,
                    color: accentColor,
                    size: 22,
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    doneLabel,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onTap,
                  child: Text(
                    'Replace',
                    style: GoogleFonts.dmSans(fontSize: 13, color: _C.accent),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onRemove,
                  child: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    size: 20,
                    color: _C.red,
                  ),
                ),
              ],
            )
          : CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onTap,
              child: Row(
                children: [
                  Icon(icon, color: accentColor, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emptyLabel,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          emptyHint,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: _C.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.plus_circle,
                    color: accentColor,
                    size: 20,
                  ),
                ],
              ),
            ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final _Category category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = CupertinoColors.activeBlue;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: SizedBox.expand(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: isSelected
                ? active.withValues(alpha: 0.1)
                : CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? active : _C.border,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 22,
                color: isSelected ? active : _C.muted,
              ),
              const SizedBox(height: 5),
              Text(
                category.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.dmSans(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? active : _C.muted,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _C.border, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _C.ink,
          ),
        ),
      ),
    );
  }
}

class _BankSelector extends StatelessWidget {
  const _BankSelector({
    required this.options,
    required this.logoAssets,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final Map<String, String> logoAssets;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 1.5),
      ),
      child: Column(
        children: List.generate(options.length, (i) {
          final option = options[i];
          final isSelected = selected == option;
          final isLast = i == options.length - 1;
          final logoAsset = logoAssets[option];

          return GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(14) : Radius.zero,
                  bottom: isLast ? const Radius.circular(14) : Radius.zero,
                ),
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
                          ? _C.accent.withValues(alpha: 0.1)
                          : const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: logoAsset != null
                        ? SvgPicture.asset(logoAsset, fit: BoxFit.cover)
                        : Icon(
                            CupertinoIcons.building_2_fill,
                            size: 18,
                            color: isSelected
                                ? _C.accent
                                : CupertinoColors.secondaryLabel,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? _C.accent : _C.ink,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isSelected
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.circle,
                    size: 22,
                    color: isSelected
                        ? _C.accent
                        : CupertinoColors.tertiaryLabel,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 2),
      child: Text(
        message,
        style: GoogleFonts.dmSans(fontSize: 12, color: _C.red),
      ),
    );
  }
}
