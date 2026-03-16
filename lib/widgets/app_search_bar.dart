import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:gofundme/screens/setting/profile_screen.dart';

class AppSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final List<String> categories;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onCategorySelected;

  const AppSearchBar({
    super.key,
    this.title = 'BrightFund',
    this.subtitle = 'Browse campaigns',
    this.categories = const [
      'All',
      'Education',
      'Technology',
      'Healthcare',
      'Business',
      'Creative Arts',
      'Community',
      'Environment',
      'Humanitarian',
    ],
    this.onSearchChanged,
    this.onCategorySelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(190);

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  late String _selectedCategory;
  final ScrollController _chipScrollController = ScrollController();
  late AnimationController _focusAnimController;
  late Animation<double> _focusAnim;

  static const _blue = Color(0xFF0A84FF);
  static const _surface = Color(0xFFF2F2F7);
  static const _label = Color(0xFF1C1C1E);
  static const _secondaryLabel = Color(0xFF8E8E93);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.isNotEmpty
        ? widget.categories.first
        : '';

    // Notify parent of the default category so its state is in sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCategorySelected?.call(_selectedCategory);
    });

    _focusAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _focusAnim = CurvedAnimation(
      parent: _focusAnimController,
      curve: Curves.easeOut,
    );
    _focusNode.addListener(() {
      final focused = _focusNode.hasFocus;
      if (focused) {
        _focusAnimController.forward();
      } else {
        _focusAnimController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _chipScrollController.dispose();
    _focusAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: Color(0x12000000), width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(),
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildCategoryChips(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subtitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _blue,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 40,
                        child: SvgPicture.asset(
                          'assets/logo/brightfund_logo_horizotal.svg',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _label,
                          letterSpacing: 0.2,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(builder: (_) => const ProfileScreen()));
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF0A84FF), Color(0xFF5E5CE6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _blue.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'T',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: _focusAnim,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color.lerp(
                  Colors.transparent,
                  _blue.withOpacity(0.4),
                  _focusAnim.value,
                )!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _blue.withOpacity(0.08 * _focusAnim.value),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: CupertinoSearchTextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: widget.onSearchChanged,
              backgroundColor: Colors.transparent,
              placeholder: 'Search campaigns',
              placeholderStyle: const TextStyle(
                fontSize: 15,
                color: _secondaryLabel,
                fontWeight: FontWeight.w400,
              ),
              style: const TextStyle(
                fontSize: 15,
                color: _label,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: _blue,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 34,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.separated(
          controller: _chipScrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: widget.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (context, index) {
            final category = widget.categories[index];
            final isSelected = category == _selectedCategory;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
                widget.onCategorySelected?.call(category);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF0A84FF), Color(0xFF007AFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : const Color(0xFFEEEEF3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _blue.withOpacity(0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF3A3A3C),
                    letterSpacing: isSelected ? -0.2 : -0.1,
                  ),
                  child: Text(category),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}