import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserStats extends StatelessWidget {
  final String userId;
  final int following;
  final int followers;
  
  const UserStats({
    Key? key,
    required this.userId,
    required this.following,
    required this.followers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          context,
          'Following',
          following.toString(),
          () => context.go('/users/$userId/following'),
        ),
        _buildStatItem(
          context,
          'Followers',
          followers.toString(),
          () => context.go('/users/$userId/followers'),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String count,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
