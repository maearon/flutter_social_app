import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About This App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This is a sample social networking application built with Flutter. It demonstrates various features like user authentication, posting messages, following users, and more.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('User authentication (sign up, login, logout)'),
            _buildFeatureItem('Password reset functionality'),
            _buildFeatureItem('Account activation via email'),
            _buildFeatureItem('User profiles with avatars'),
            _buildFeatureItem('Create and view microposts'),
            _buildFeatureItem('Follow/unfollow other users'),
            _buildFeatureItem('View followers and following lists'),
            _buildFeatureItem('Edit user profile'),
            const SizedBox(height: 24),
            const Text(
              'Technologies Used',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Flutter for cross-platform UI'),
            _buildFeatureItem('Riverpod for state management'),
            _buildFeatureItem('Dio for API communication'),
            _buildFeatureItem('go_router for navigation'),
            _buildFeatureItem('flutter_secure_storage for token storage'),
            const SizedBox(height: 24),
            const Text(
              'Version',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('1.0.0', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
