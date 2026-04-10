import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/firebase_user_service.dart';

class ProfileCreationScreen extends StatefulWidget {
	const ProfileCreationScreen({super.key});

	@override
	State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
	final _formKey = GlobalKey<FormState>();
	final _usernameController = TextEditingController();
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();
	bool _isLoading = false;
	String? _errorMessage;
	String _selectedAvatar = 'https://images.unsplash.com/photo-1705408115513-3ff15ef55a8d';
	final List<Map<String, String>> _avatarOptions = [
		{
			'id': 'avatar_1',
			'image': 'https://images.unsplash.com/photo-1705408115513-3ff15ef55a8d',
			'name': 'Adventure Seeker'
		},
		{
			'id': 'avatar_2',
			'image': 'https://images.unsplash.com/photo-1587401095394-725003c9bea1',
			'name': 'Fitness Warrior'
		},
		{
			'id': 'avatar_3',
			'image': 'https://images.unsplash.com/photo-1576921874520-1c3fa53f2674',
			'name': 'Trail Runner'
		},
		{
			'id': 'avatar_4',
			'image': 'https://images.unsplash.com/photo-1680310381169-5ccb4b532517',
			'name': 'Step Master'
		},
		{
			'id': 'avatar_5',
			'image': 'https://images.unsplash.com/photo-1696453685422-34d5c0ddd4c3',
			'name': 'Mountain Walker'
		},
		{
			'id': 'avatar_6',
			'image': 'https://images.unsplash.com/photo-1687699875541-f073e9086676',
			'name': 'Park Explorer'
		},
	];

	Future<void> _createProfile() async {
				if (!_formKey.currentState!.validate()) return;
				setState(() {
					_isLoading = true;
					_errorMessage = null;
				});
				final username = _usernameController.text.trim();
				final email = _emailController.text.trim();
				final password = _passwordController.text;
				final service = FirebaseUserService();
				final existing = await service.getUser(username);
				if (existing != null) {
					setState(() {
						_isLoading = false;
						_errorMessage = 'Username already exists.';
					});
					return;
				}
				await service.createUser(username, email, password);
				final prefs = await SharedPreferences.getInstance();
				await prefs.setBool('profile_created', true);
				await prefs.setString('user_username', username);
				setState(() => _isLoading = false);
				Navigator.pushReplacementNamed(context, '/home-dashboard');
			}

	@override
	void dispose() {
		_usernameController.dispose();
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

			@override
			Widget build(BuildContext context) {
				final theme = Theme.of(context);
				return Scaffold(
					appBar: AppBar(
						title: const Text('Create Profile'),
						leading: IconButton(
							icon: const Icon(Icons.arrow_back),
							onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
						),
					),
					body: SafeArea(
						child: SingleChildScrollView(
							padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
							child: Form(
								key: _formKey,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										SizedBox(height: 2.h),
										Text(
											'Create Your WalkScape Profile',
											style: theme.textTheme.headlineSmall?.copyWith(
												color: theme.colorScheme.primary,
												fontWeight: FontWeight.bold,
											),
											textAlign: TextAlign.center,
										),
										SizedBox(height: 1.5.h),
										Text(
											'Pick an avatar, choose a username, and join the adventure!',
											style: theme.textTheme.bodyMedium,
											textAlign: TextAlign.center,
										),
										SizedBox(height: 3.h),
										Text('Choose Your Avatar', style: theme.textTheme.titleMedium),
										SizedBox(height: 2.h),
										SizedBox(
											height: 22.w,
											child: ListView.separated(
												scrollDirection: Axis.horizontal,
												itemCount: _avatarOptions.length,
												separatorBuilder: (_, __) => SizedBox(width: 3.w),
												itemBuilder: (context, index) {
													final avatar = _avatarOptions[index];
													final isSelected = _selectedAvatar == avatar['image'];
													return GestureDetector(
														onTap: () {
															setState(() => _selectedAvatar = avatar['image']!);
														},
														child: Column(
															children: [
																Container(
																	width: 18.w,
																	height: 18.w,
																	decoration: BoxDecoration(
																		shape: BoxShape.circle,
																		border: Border.all(
																			color: isSelected ? theme.colorScheme.primary : Colors.transparent,
																			width: 4,
																		),
																		boxShadow: [
																			if (isSelected)
																				BoxShadow(
																					color: theme.colorScheme.primary.withValues(alpha: 0.2),
																					blurRadius: 12,
																					spreadRadius: 2,
																				),
																		],
																	),
																	child: ClipOval(
																		child: Image.network(
																			avatar['image']!,
																			width: 18.w,
																			height: 18.w,
																			fit: BoxFit.cover,
																		),
																	),
																),
																SizedBox(height: 0.5.h),
																Text(
																	avatar['name']!,
																	style: theme.textTheme.bodySmall?.copyWith(
																		color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
																		fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
																	),
																),
															],
														),
													);
												},
											),
										),
										SizedBox(height: 4.h),
										TextFormField(
											controller: _usernameController,
											decoration: const InputDecoration(
												labelText: 'Username',
												prefixIcon: Icon(Icons.person),
											),
											validator: (value) {
												if (value == null || value.trim().isEmpty) {
													return 'Please enter a username';
												}
												if (value.trim().length < 3) {
													return 'Username must be at least 3 characters';
												}
												if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
													return 'Username can only contain letters, numbers, and underscores';
												}
												return null;
											},
										),
										SizedBox(height: 2.h),
										TextFormField(
											controller: _emailController,
											keyboardType: TextInputType.emailAddress,
											decoration: const InputDecoration(
												labelText: 'Email (optional)',
												prefixIcon: Icon(Icons.email),
											),
											validator: (value) {
												if (value != null && value.isNotEmpty) {
													if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(value)) {
														return 'Please enter a valid email address';
													}
												}
												return null;
											},
										),
										SizedBox(height: 2.h),
										TextFormField(
											controller: _passwordController,
											obscureText: true,
											decoration: const InputDecoration(
												labelText: 'Password',
												prefixIcon: Icon(Icons.lock),
											),
											validator: (value) {
												if (value == null || value.length < 4) {
													return 'Password must be at least 4 characters';
												}
												return null;
											},
										),
										if (_errorMessage != null) ...[
											SizedBox(height: 1.5.h),
											Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
										],
										SizedBox(height: 4.h),
										SizedBox(
											width: double.infinity,
											height: 6.h,
											child: ElevatedButton(
												onPressed: _isLoading ? null : _createProfile,
												style: ElevatedButton.styleFrom(
													backgroundColor: theme.colorScheme.primary,
													foregroundColor: theme.colorScheme.onPrimary,
													textStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
													elevation: 6,
												),
												child: _isLoading
														? const CircularProgressIndicator()
														: const Text('Create Profile'),
											),
										),
										SizedBox(height: 3.h),
									],
								),
							),
						),
					),
				);
			}
}