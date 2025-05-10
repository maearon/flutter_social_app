import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_app/core/widgets/loading_spinner.dart';
import 'package:flutter_social_app/features/user/services/user_service.dart';
import 'package:flutter_social_app/features/user/widgets/user_info.dart';
import 'package:flutter_social_app/core/models/user.dart';
import 'package:flutter_social_app/features/user/widgets/user_stats.dart';

class ShowFollowScreen extends ConsumerStatefulWidget {
  final String userId;
  final String type;

  const ShowFollowScreen({
    Key? key,
    required this.userId,
    required this.type,
  }) : super(key: key);

  @override
  ConsumerState<ShowFollowScreen> createState() => _ShowFollowScreenState();
}

class _ShowFollowScreenState extends ConsumerState<ShowFollowScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;
  bool _refreshing = false;
  bool _loadingMore = false;
  List<dynamic> _users = [];
  int _totalCount = 0;
  int _page = 1;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadData();
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
      _loadMoreUsers();
    }
  }

  Future<void> _loadData({bool refresh = false}) async {
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
      final response = widget.type == 'following'
          ? await UserService().getFollowing(widget.userId, _page)
          : await UserService().getFollowers(widget.userId, _page);

      if (refresh) {
        setState(() {
          _users = response.users ?? [];
          _totalCount = response.totalCount;
          _userData = response.user;
        });
      } else {
        setState(() {
          _users = [..._users, ...response.users];
          _totalCount = response.totalCount;
          _userData = response.user;
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ${widget.type}: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _loading = false;
        _refreshing = false;
        _loadingMore = false;
      });
    }
  }

  Future<void> _loadMoreUsers() async {
    if (_loadingMore || _users.length >= _totalCount) return;
    
    setState(() {
      _page++;
    });
    
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _userData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.type == 'following' ? 'Following' : 'Followers'),
        ),
        body: const Center(child: LoadingSpinner()),
      );
    }

    if (_userData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.type == 'following' ? 'Following' : 'Followers'),
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

    // ⬇️ Đây là phần build đã được sửa đúng
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'following' ? 'Following' : 'Followers'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadData(refresh: true),
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
                            UserInfo(
                              user: User.fromMap(_userData!),
                            ),
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
                    Text(
                      '${widget.type == 'following' ? 'Following' : 'Followers'} ($_totalCount)',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_users.isEmpty && !_loading)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'No ${widget.type} yet.',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (_users.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final user = _users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://secure.gravatar.com/avatar/${user['gravatar_id']}?s=50',
                        ),
                      ),
                      title: Text(user['name']),
                      onTap: () => context.go('/users/${user['id']}'),
                    );
                  },
                  childCount: _users.length,
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
