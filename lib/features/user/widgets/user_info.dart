import 'package:flutter/material.dart';
import 'package:flutter_social_app/core/models/user.dart';
import 'package:flutter_social_app/core/utils/gravatar_util.dart';
import 'package:go_router/go_router.dart';

class UserInfo extends StatelessWidget {
  final User user;
  final int? micropostCount;
  final bool showProfileLink;
  
  const UserInfo({
    Key? key,
    required this.user,
    this.micropostCount,
    this.showProfileLink = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                GravatarUtil.getGravatarUrl(user.email, size: 60),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (micropostCount != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Microposts: $micropostCount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (showProfileLink)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextButton(
              onPressed: () => context.go('/users/${user.id}'),
              child: const Text('View my profile'),
            ),
          ),
      ],
    );
  }
}
