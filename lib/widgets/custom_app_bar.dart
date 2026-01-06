import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar variants for fitness gamification app
/// Implements adventure minimalism design with contextual actions
enum CustomAppBarVariant {
  standard,
  dashboard,
  profile,
  achievements,
  social,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: _buildTitle(context),
      centerTitle: centerTitle,
      elevation: elevation ?? theme.appBarTheme.elevation,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      systemOverlayStyle: _getSystemOverlayStyle(context),
      flexibleSpace: variant == CustomAppBarVariant.dashboard
          ? _buildDashboardBackground(context)
          : null,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.dashboard:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.appBarTheme.titleTextStyle?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );

      case CustomAppBarVariant.achievements:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              color: theme.colorScheme.tertiary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        );

      case CustomAppBarVariant.social:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.leaderboard,
              color: theme.colorScheme.secondary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        );

      case CustomAppBarVariant.profile:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        );

      default:
        return Text(title);
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          HapticFeedback.lightImpact();
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.of(context).pop();
          }
        },
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> defaultActions = [];

    switch (variant) {
      case CustomAppBarVariant.dashboard:
        defaultActions = [
          IconButton(
            icon: Badge(
              backgroundColor: theme.colorScheme.tertiary,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showNotifications(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showSettings(context);
            },
          ),
        ];
        break;

      case CustomAppBarVariant.profile:
        defaultActions = [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              _editProfile(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showProfileMenu(context);
            },
          ),
        ];
        break;

      case CustomAppBarVariant.achievements:
        defaultActions = [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              _shareAchievements(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              _filterAchievements(context);
            },
          ),
        ];
        break;

      case CustomAppBarVariant.social:
        defaultActions = [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              _searchFriends(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              _addFriends(context);
            },
          ),
        ];
        break;

      default:
        break;
    }

    return actions ?? defaultActions;
  }

  Widget? _buildDashboardBackground(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.05),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
    );
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
  }

  // Action methods
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('No new notifications'),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }

  void _editProfile(BuildContext context) {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _showSettings(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Handle logout
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareAchievements(BuildContext context) {
    // Handle share achievements
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing achievements...')),
    );
  }

  void _filterAchievements(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Achievements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Add filter options here
            const Text('Filter options coming soon...'),
          ],
        ),
      ),
    );
  }

  void _searchFriends(BuildContext context) {
    Navigator.pushNamed(context, '/search-friends');
  }

  void _addFriends(BuildContext context) {
    Navigator.pushNamed(context, '/add-friends');
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
