import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/achievement_card.dart';
import './widgets/achievement_detail_modal.dart';
import './widgets/achievement_filter_chips.dart';
import './widgets/achievement_search_bar.dart';
import './widgets/achievement_stats_header.dart';

class AchievementGallery extends StatefulWidget {
  const AchievementGallery({super.key});

  @override
  State<AchievementGallery> createState() => _AchievementGalleryState();
}

class _AchievementGalleryState extends State<AchievementGallery>
    with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock achievement data
  final List<Map<String, dynamic>> _allAchievements = [
    // Starter step achievements
    {
      'id': 1001,
      'title': 'First Steps!',
      'description': 'Take 10 steps to start your journey.',
      'category': 'Steps',
      'rarity': 'common',
      'isEarned': false,
      'badgeImage': 'https://cdn.pixabay.com/photo/2017/01/31/13/14/foot-2024634_1280.png',
      'semanticLabel': 'Footprint with sparkles',
      'points': 10,
      'requirement': 'Take 10 steps',
    },
    {
      'id': 1002,
      'title': 'Getting Warmer',
      'description': 'Take 50 steps. You’re on your way!',
      'category': 'Steps',
      'rarity': 'common',
      'isEarned': false,
      'badgeImage': 'https://cdn.pixabay.com/photo/2013/07/12/13/58/shoe-147844_1280.png',
      'semanticLabel': 'Shoe with a warm glow',
      'points': 25,
      'requirement': 'Take 50 steps',
    },
    {
      'id': 1003,
      'title': 'Step Champion',
      'description': 'Take 100 steps. You’re unstoppable!',
      'category': 'Steps',
      'rarity': 'rare',
      'isEarned': false,
      'badgeImage': 'https://cdn.pixabay.com/photo/2012/04/13/00/22/shoe-31212_1280.png',
      'semanticLabel': 'Golden shoe with rays',
      'points': 50,
      'requirement': 'Take 100 steps',
    },
    // ...existing code...
    {
      'id': 1,
      'title': 'Mile One Magic',
      'description': 'Walk your first mile! Every journey starts with a single, magical step. Confetti guaranteed.',
      'category': 'Miles',
      'rarity': 'common',
      'isEarned': true,
      'badgeImage': 'https://cdn.pixabay.com/photo/2017/01/31/13/14/foot-2024634_1280.png',
      'semanticLabel': 'Sparkling golden shoe with confetti',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 15)),
      'points': 100,
      'statistics': {
        'milesWhenEarned': 1,
        'daysToComplete': 1,
      },
    },
    {
      'id': 2,
      'title': '5 Mile Fiesta',
      'description': 'Walk 5 miles and unlock a party! The badge is a dancing sneaker with a party hat.',
      'category': 'Miles',
      'rarity': 'common',
      'isEarned': true,
      'badgeImage': 'https://cdn.pixabay.com/photo/2013/07/12/13/58/shoe-147844_1280.png',
      'semanticLabel': 'Sneaker with party hat and streamers',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 12)),
      'points': 150,
      'statistics': {
        'milesWhenEarned': 5,
        'daysToComplete': 2,
      },
    },
    {
      'id': 3,
      'title': 'Marathon Marvel',
      'description': 'Complete 26.2 miles total. You’re officially a Marvel! Badge: superhero cape on a running shoe.',
      'category': 'Miles',
      'rarity': 'rare',
      'isEarned': true,
      'badgeImage': 'https://cdn.pixabay.com/photo/2012/04/13/00/22/shoe-31212_1280.png',
      'semanticLabel': 'Shoe with superhero cape and lightning',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 8)),
      'points': 300,
      'statistics': {
        'milesWhenEarned': 26.2,
        'daysToComplete': 7,
      },
    },
    {
      'id': 4,
      'title': '50 Mile Showdown',
      'description': 'Walk 50 miles and unlock a flaming trophy! Compete with friends for the fastest time.',
      'category': 'Miles',
      'rarity': 'epic',
      'isEarned': false,
      'progress': 0.7,
      'requirement': 'Walk 15 more miles to unlock',
      'points': 500,
    },
    {
      'id': 5,
      'title': 'Centurion Strider',
      'description': '100 miles! You’re a legend. Badge: Roman helmet on a sneaker. Compete for the leaderboard!',
      'category': 'Miles',
      'rarity': 'legendary',
      'isEarned': false,
      'progress': 0.4,
      'requirement': 'Walk 60 more miles to unlock',
      'points': 1000,
    },
    {
      'id': 6,
      'title': 'Streak Supreme',
      'description': 'Walk at least 1 mile every day for 30 days. Badge: flaming calendar with running shoes.',
      'category': 'Streak',
      'rarity': 'epic',
      'isEarned': true,
      'badgeImage': 'https://cdn.pixabay.com/photo/2014/04/03/10/32/calendar-312779_1280.png',
      'semanticLabel': 'Flaming calendar with shoes',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 45)),
      'points': 900,
      'statistics': {
        'milesWhenEarned': 30,
        'daysToComplete': 30,
      },
    },
    {
      'id': 7,
      'title': 'Midnight Milestone',
      'description': 'Walk a mile at midnight. Badge: glowing moon and neon shoes. Only for night owls!',
      'category': 'Challenge',
      'rarity': 'rare',
      'isEarned': false,
      'progress': 0.0,
      'requirement': 'Walk a mile at midnight',
      'points': 400,
    },
    {
      'id': 8,
      'title': 'Friendship Dash',
      'description': 'Walk 10 miles with friends (group challenge). Badge: shoes with sunglasses and high-fives.',
      'category': 'Social',
      'rarity': 'rare',
      'isEarned': true,
      'badgeImage': 'https://cdn.pixabay.com/photo/2016/03/31/19/56/feet-1290017_1280.png',
      'semanticLabel': 'Shoes with sunglasses and high-fives',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 22)),
      'points': 500,
      'statistics': {
        'milesWhenEarned': 10,
        'daysToComplete': 5,
      },
    },
    {
      'id': 9,
      'title': 'Globetrotter',
      'description': 'Walk 500 miles total. Badge: globe with running shoes orbiting. Compete for the world leaderboard!',
      'category': 'Miles',
      'rarity': 'legendary',
      'isEarned': false,
      'progress': 0.2,
      'requirement': 'Walk 400 more miles to unlock',
      'points': 2000,
    },
    {
      'id': 10,
      'title': 'King of the Hill',
      'description': 'Climb the most elevation in a week. Badge: crown on a mountain with shoes. Compete with friends!',
      'category': 'Competitive',
      'rarity': 'epic',
      'isEarned': false,
      'progress': 0.33,
      'requirement': 'Win 1 more weekly climb challenge',
      'points': 1200,
    },
  ];

  List<Map<String, dynamic>> _filteredAchievements = [];

  @override
  void initState() {
    super.initState();
    _filteredAchievements = _allAchievements;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterAchievements() {
    setState(() {
      _filteredAchievements = _allAchievements.where((achievement) {
        // Filter by category
        bool matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Recent' && achievement['isEarned'] == true) ||
            achievement['category']
                .toString()
                .toLowerCase()
                .contains(_selectedFilter.toLowerCase());

        // Filter by search query
        bool matchesSearch = _searchQuery.isEmpty ||
            achievement['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            achievement['description']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            achievement['category']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        return matchesFilter && matchesSearch;
      }).toList();

      // Sort achievements: earned first, then by rarity, then by points
      _filteredAchievements.sort((a, b) {
        if (a['isEarned'] != b['isEarned']) {
          return b['isEarned'] ? 1 : -1;
        }

        final rarityOrder = {'common': 1, 'rare': 2, 'epic': 3, 'legendary': 4};
        final aRarity = rarityOrder[a['rarity']] ?? 0;
        final bRarity = rarityOrder[b['rarity']] ?? 0;

        if (aRarity != bRarity) {
          return bRarity.compareTo(aRarity);
        }

        return (b['points'] as int).compareTo(a['points'] as int);
      });
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterAchievements();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterAchievements();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchQuery = '';
        _filterAchievements();
      }
    });
  }

  void _showAchievementDetail(Map<String, dynamic> achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AchievementDetailModal(achievement: achievement),
    );
  }

  void _shareAchievement(Map<String, dynamic> achievement) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Achievement',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                size: 6.w,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Share to Social Media'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Sharing "${achievement['title']}" achievement...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                size: 6.w,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Copy Achievement Link'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(
                  text:
                      'Check out my "${achievement['title']}" achievement in WalkScape!',
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Achievement link copied to clipboard!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshAchievements() async {
    HapticFeedback.lightImpact();
    // Simulate checking for new achievements
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    // Show celebration animation for newly earned achievements
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Checking for new achievements...'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  int get _totalAchievements => _allAchievements.length;
  int get _earnedAchievements =>
      _allAchievements.where((a) => a['isEarned'] == true).length;
  int get _totalPoints => _allAchievements
      .where((a) => a['isEarned'] == true)
      .fold(0, (sum, a) => sum + (a['points'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Achievements',
        variant: CustomAppBarVariant.achievements,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearchVisible ? 'close' : 'search',
              size: 6.w,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _refreshAchievements,
          child: CustomScrollView(
            slivers: [
              // Stats Header
              SliverToBoxAdapter(
                child: AchievementStatsHeader(
                  totalAchievements: _totalAchievements,
                  earnedAchievements: _earnedAchievements,
                  totalPoints: _totalPoints,
                ),
              ),

              // Search Bar (if visible)
              if (_isSearchVisible)
                SliverToBoxAdapter(
                  child: AchievementSearchBar(
                    searchQuery: _searchQuery,
                    onSearchChanged: _onSearchChanged,
                    onClearSearch: () {
                      setState(() {
                        _searchQuery = '';
                      });
                      _filterAchievements();
                    },
                  ),
                ),

              // Filter Chips
              SliverToBoxAdapter(
                child: AchievementFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

              // Achievement Grid
              _filteredAchievements.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'search_off',
                              size: 15.w,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No achievements found',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Try adjusting your search or filters',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 2.h,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final achievement = _filteredAchievements[index];
                            return AchievementCard(
                              achievement: achievement,
                              onTap: () => _showAchievementDetail(achievement),
                              onLongPress: achievement['isEarned'] == true
                                  ? () => _shareAchievement(achievement)
                                  : null,
                            );
                          },
                          childCount: _filteredAchievements.length,
                        ),
                      ),
                    ),

              // Bottom padding for navigation bar
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) {
            // Navigate to other screens
            final routes = [
              '/home-dashboard',
              '/social-leaderboard',
              '/achievement-gallery',
              '/user-profile'
            ];
            if (index < routes.length) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          }
        },
      ),
    );
  }
}

