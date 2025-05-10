import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_app/core/widgets/loading_spinner.dart';
import 'package:flutter_social_app/features/user/services/user_service.dart';
import 'package:flutter_social_app/features/user/widgets/user_info.dart';
import 'package:flutter_social_app/features/user/widgets/user_stats.dart';
import 'package:flutter_social_app/features/user/widgets/follow_button.dart';
import 'package:flutter_social_app/features/micropost/widgets/micropost_item.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_social_app/core/models/user_request.dart'; // thêm nếu có

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;
  bool _refreshing = false;
  bool _loadingMore = false;
  Map<String, dynamic>? _userData;
  List<dynamic> _microposts = [];
  int _totalCount = 0;
  int _page = 1;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreMicroposts();
    }
  }

  Future<void> _loadUserData({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _refreshing = true;
        _page = 1;
      });
    } else if (!_loading) {
      setState(() {
        _loadingMore = true;
      });
    }

    try {
      final currentUser = ref.read(authProvider).user;
      if (currentUser == null) return;

      // 🔧 Sửa đoạn này: truyền custom type thay vì Map
      final request = UserRequest(page: _page);
      final response = await UserService().getUser(
        widget.userId,
        UserRequest(page: _page), // ✅ truyền đúng kiểu
      );

      if (refresh) {
        setState(() {
          _userData = response['user'];
          _microposts = response['microposts'] ?? [];
          _totalCount = response['total_count'] ?? 0;
          _isFollowing = response['user']['current_user_following_user'] ?? false;
        });
      } else {
        setState(() {
          _userData = response['user'];
          _microposts = [..._microposts, ...(response['microposts'] ?? [])];
          _totalCount = response['total_count'] ?? 0;
          _isFollowing = response['user']['current_user_following_user'] ?? false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _loading = false;
        _refreshing = false;
        _loadingMore = false;
      });
    }
  }

  Future<void> _loadMoreMicroposts() async {
    if (_loadingMore || _microposts.length >= _totalCount) return;
    
    setState(() {
      _page++;
    });
    
    await _loadUserData();
  }

  void _handleFollowChange(bool following) {
    setState(() {
      _isFollowing = following;
      if (_userData != null) {
        _userData!['followers'] = following 
            ? (_userData!['followers'] + 1) 
            : (_userData!['followers'] - 1);
      }
    });
  }

  void _handleMicropostDeleted() {
    _loadUserData(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider).user;

    if (_loading && _userData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: const Center(child: LoadingSpinner()),
      );
    }

    if (_userData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'User not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_userData!['name']),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadUserData(refresh: true),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            UserInfo(user: _userData!),
                            const SizedBox(height: 16),
                            UserStats(
                              userId: _userData!['id'].toString(),
                              following: _userData!['following'],
                              followers: _userData!['followers'],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (currentUser != null && currentUser.id.toString() != widget.userId)
                      Center(
                        child: FollowButton(
                          userId: widget.userId,
                          isFollowing: _isFollowing,
                          onFollowChange: _handleFollowChange,
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    Text(
                      'Microposts ($_totalCount)',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    if (_microposts.isEmpty && !_loading)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'No microposts yet.',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            if (_microposts.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return MicropostItem(
                      micropost: _microposts[index],
                      onDelete: _handleMicropostDeleted,
                    );
                  },
                  childCount: _microposts.length,
                ),
              ),
              
            if (_loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
