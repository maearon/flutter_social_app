import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_app/core/models/micropost.dart';
import 'package:flutter_social_app/core/widgets/loading_spinner.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_social_app/features/micropost/services/micropost_service.dart';
import 'package:flutter_social_app/features/micropost/widgets/micropost_form.dart';
import 'package:flutter_social_app/features/micropost/widgets/micropost_item.dart';
import 'package:flutter_social_app/features/user/widgets/user_info.dart';
import 'package:flutter_social_app/features/user/widgets/user_stats.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final MicropostService _micropostService = MicropostService();
  bool _loading = true;
  bool _refreshing = false;
  int _page = 1;
  List<Micropost> _feedItems = [];
  int _totalCount = 0;
  int _followingCount = 0;
  int _followersCount = 0;
  int _micropostCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed({bool refresh = false}) async {
    final authState = ref.read(authProvider);
    if (!authState.isLoggedIn) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      final currentPage = refresh ? 1 : _page;
      final response = await _micropostService.getMicroposts(page: currentPage);

      setState(() {
        _feedItems = refresh
            ? (response.feedItems.map((item) => Micropost.fromJson(item)).toList())
            : [..._feedItems, ...response.feedItems.map((item) => Micropost.fromJson(item)).toList()];
        _totalCount = response.totalCount;
        _followingCount = response.following;
        _followersCount = response.followers;
        _micropostCount = response.micropost;

        if (refresh) {
          _page = 1;
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load feed'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _loading = false;
        _refreshing = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _refreshing = true;
    });
    await _loadFeed(refresh: true);
  }

  void _handleLoadMore() {
    if (_feedItems.length < _totalCount) {
      setState(() {
        _page++;
      });
      _loadFeed();
    }
  }

  void _handleMicropostDeleted() {
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.isLoggedIn;
    final user = authState.user;

    if (_loading) {
      return const Scaffold(
        body: LoadingSpinner(fullPage: true),
      );
    }

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the Sample App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'This is the home page for the Flutter Tutorial sample application.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/signup'),
                  child: const Text('Sign up now!'),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/flutter_logo.png',
                  width: 180,
                  height: 38,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _feedItems.length + 1, // +1 for the header
          itemBuilder: (context, index) {
            if (index == 0) {
              // Header
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: user != null
                          ? UserInfo(
                              user: user,
                              micropostCount: _micropostCount,
                              showProfileLink: true,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: UserStats(
                        userId: user?.id ?? '',
                        following: _followingCount,
                        followers: _followersCount,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: MicropostForm(
                        onPostCreated: _handleRefresh,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Micropost Feed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_feedItems.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No microposts yet.',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            final micropostIndex = index - 1;
            final micropost = _feedItems[micropostIndex];

            // Load more when reaching the end
            if (micropostIndex == _feedItems.length - 1 && _feedItems.length < _totalCount) {
              _handleLoadMore();
            }

            return MicropostItem(
              micropost: micropost,
              onDelete: _handleMicropostDeleted,
            );
          },
        ),
      ),
    );
  }
}
