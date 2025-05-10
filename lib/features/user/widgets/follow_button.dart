import 'package:flutter/material.dart';
import 'package:flutter_social_app/features/relationship/services/relationship_service.dart';

class FollowButton extends StatefulWidget {
  final String userId;
  final bool isFollowing;
  final Function(bool) onFollowChange;
  
  const FollowButton({
    Key? key,
    required this.userId,
    required this.isFollowing,
    required this.onFollowChange,
  }) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool _isFollowing;
  bool _isLoading = false;
  final RelationshipService _relationshipService = RelationshipService();

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  void didUpdateWidget(FollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFollowing != widget.isFollowing) {
      _isFollowing = widget.isFollowing;
    }
  }

  Future<void> _toggleFollow() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFollowing) {
        await _relationshipService.unfollowUser(widget.userId);
        _isFollowing = false;
      } else {
        await _relationshipService.followUser(widget.userId);
        _isFollowing = true;
      }
      widget.onFollowChange(_isFollowing);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to ${_isFollowing ? 'unfollow' : 'follow'} user'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _toggleFollow,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFollowing ? Colors.grey : Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(_isFollowing ? 'Unfollow' : 'Follow'),
    );
  }
}
