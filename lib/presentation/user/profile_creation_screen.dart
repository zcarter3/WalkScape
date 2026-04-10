import 'package:flutter/material.dart';

class ProfileCreationScreen extends StatelessWidget {
	const ProfileCreationScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Create Profile'),
				leading: IconButton(
					icon: const Icon(Icons.arrow_back),
					onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
				),
			),
			body: const Center(
				child: Text('Profile creation coming soon!'),
			),
		);
	}
}