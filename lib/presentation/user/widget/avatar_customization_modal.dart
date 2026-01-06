import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvatarCustomizationModal extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onAvatarUpdate;

  const AvatarCustomizationModal({
    super.key,
    required this.userData,
    required this.onAvatarUpdate,
  });

  @override
  State<AvatarCustomizationModal> createState() =>
      _AvatarCustomizationModalState();
}

class _AvatarCustomizationModalState extends State<AvatarCustomizationModal>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedAvatar = '';
  String selectedTheme = '';

  final List<Map<String, dynamic>> avatarOptions = [
    {
      "id": "avatar_1",
      "imageUrl":
          "https://images.unsplash.com/photo-1705408115513-3ff15ef55a8d",
      "semanticLabel":
          "Young woman with curly brown hair wearing a white t-shirt, smiling outdoors",
      "unlocked": true,
    },
    {
      "id": "avatar_2",
      "imageUrl":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1f01089fb-1762273740576.png",
      "semanticLabel":
          "Professional man with short dark hair wearing a navy blue suit jacket",
      "unlocked": true,
    },
    {
      "id": "avatar_3",
      "imageUrl":
          "https://images.unsplash.com/photo-1733077151455-113715b5a4be",
      "semanticLabel":
          "Athletic woman with blonde hair in ponytail wearing workout clothes",
      "unlocked": false,
    },
    {
      "id": "avatar_4",
      "imageUrl":
          "https://images.unsplash.com/photo-1609126110613-fc7adf59f543",
      "semanticLabel": "Bearded man with glasses wearing a casual gray sweater",
      "unlocked": true,
    },
    {
      "id": "avatar_5",
      "imageUrl":
          "https://images.unsplash.com/photo-1505669845733-1aa234f696b1",
      "semanticLabel":
          "Young woman with long dark hair wearing a red top, smiling",
      "unlocked": false,
    },
    {
      "id": "avatar_6",
      "imageUrl":
          "https://images.unsplash.com/photo-1616641610572-8b4560e60fb1",
      "semanticLabel":
          "Man with short brown hair wearing a black t-shirt outdoors",
      "unlocked": true,
    },
  ];

  final List<Map<String, dynamic>> themeOptions = [
    {
      "id": "forest_trail",
      "name": "Forest Trail",
      "imageUrl":
          "https://images.unsplash.com/photo-1720534670906-ae9286ccba92",
      "semanticLabel":
          "Misty forest trail winding through tall green trees at dawn",
      "unlocked": true,
    },
    {
      "id": "city_run",
      "name": "City Run",
      "imageUrl":
          "https://images.unsplash.com/photo-1639101283369-3b6f02a69b31",
      "semanticLabel":
          "Modern city skyline with tall buildings and urban streets",
      "unlocked": true,
    },
    {
      "id": "mountain_peak",
      "name": "Mountain Peak",
      "imageUrl":
          "https://images.unsplash.com/photo-1677922069611-3019fcb0f696",
      "semanticLabel": "Snow-capped mountain peaks against a clear blue sky",
      "unlocked": false,
    },
    {
      "id": "beach_walk",
      "name": "Beach Walk",
      "imageUrl":
          "https://images.unsplash.com/photo-1621084812194-c6db3d873b88",
      "semanticLabel":
          "Sandy beach with gentle waves and palm trees in the distance",
      "unlocked": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedAvatar =
        widget.userData["currentAvatarId"] as String? ?? "avatar_1";
    selectedTheme =
        widget.userData["currentThemeId"] as String? ?? "forest_trail";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Modal Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  'Customize Avatar',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _saveChanges,
                  child: Text(
                    'Save',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Avatar'),
              Tab(text: 'Theme'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvatarTab(context),
                _buildThemeTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarTab(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 0.8,
        ),
        itemCount: avatarOptions.length,
        itemBuilder: (context, index) {
          final avatar = avatarOptions[index];
          final isSelected = selectedAvatar == avatar["id"];
          final isUnlocked = avatar["unlocked"] as bool;

          return GestureDetector(
            onTap: isUnlocked
                ? () => setState(() => selectedAvatar = avatar["id"] as String)
                : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: CustomImageWidget(
                      imageUrl: avatar["imageUrl"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: avatar["semanticLabel"] as String,
                    ),
                  ),
                  if (!isUnlocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'lock',
                              color: Colors.white,
                              size: 8.w,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Unlock at\nLevel 15',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (isSelected && isUnlocked)
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: theme.colorScheme.onPrimary,
                          size: 4.w,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeTab(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: ListView.separated(
        itemCount: themeOptions.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final themeOption = themeOptions[index];
          final isSelected = selectedTheme == themeOption["id"];
          final isUnlocked = themeOption["unlocked"] as bool;

          return GestureDetector(
            onTap: isUnlocked
                ? () =>
                    setState(() => selectedTheme = themeOption["id"] as String)
                : null,
            child: Container(
              height: 15.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: CustomImageWidget(
                      imageUrl: themeOption["imageUrl"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: themeOption["semanticLabel"] as String,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3.w,
                    left: 3.w,
                    right: 3.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          themeOption["name"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isUnlocked)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'lock',
                                  color: Colors.white,
                                  size: 3.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Level 20',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected && isUnlocked)
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: theme.colorScheme.onPrimary,
                          size: 4.w,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveChanges() {
    final selectedAvatarData = avatarOptions.firstWhere(
      (avatar) => avatar["id"] == selectedAvatar,
    );
    final selectedThemeData = themeOptions.firstWhere(
      (theme) => theme["id"] == selectedTheme,
    );

    final updatedData = {
      ...widget.userData,
      "avatar": selectedAvatarData["imageUrl"],
      "avatarSemanticLabel": selectedAvatarData["semanticLabel"],
      "currentAvatarId": selectedAvatar,
      "currentThemeId": selectedTheme,
      "currentThemeName": selectedThemeData["name"],
    };

    widget.onAvatarUpdate(updatedData);
    Navigator.pop(context);
  }
}
