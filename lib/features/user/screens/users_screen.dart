import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_app/core/models/user.dart'; // THÊM DÒNG NÀY
import 'package:flutter_social_app/core/widgets/loading_spinner.dart';
import 'package:flutter_social_app/features/user/services/user_service.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;
  bool _refreshing = false;
  bool _loadingMore = false;
  List<User> _users = []; // Sửa kiểu dữ liệu thành List<User>
  int _totalCount = 0;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadUsers();
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

  Future<void> _loadUsers({bool refresh = false}) async {
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
      final response = await UserService().getUsers({'page': _page});
      final List<User> fetchedUsers = (response['users'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson))
          .toList();

      if (refresh) {
        setState(() {
          _users = fetchedUsers;
          _totalCount = response['total_count'] ?? 0;
        });
      } else {
        setState(() {
          _users = [..._users, ...fetchedUsers];
          _totalCount = response['total_count'] ?? 0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: ${e.toString()}')),
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

    await _loadUsers();
  }

  Future<void> _handleDelete(String id) async {
    final currentUser = ref.read(authProvider).user;
    if (currentUser == null || !currentUser.admin!) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await UserService().deleteUser(id);

        if (response.containsKey('flash')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['flash'][1])),
          );
          _loadUsers(refresh: true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete user: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider).user;

    if (_loading && _users.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('All Users'),
        ),
        body: const Center(child: LoadingSpinner()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadUsers(refresh: true),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '👥 All users',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final user = _users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://secure.gravatar.com/avatar/${user.gravatarId}?s=50',
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(user.name),
                        if (user.admin == true)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'admin',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    trailing: currentUser?.admin == true &&
                            currentUser?.id.toString() != user.id
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _handleDelete(user.id),
                          )
                        : null,
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
