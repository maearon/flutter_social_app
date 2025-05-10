import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_app/core/widgets/loading_spinner.dart';
import 'package:flutter_social_app/features/user/services/user_service.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';

class UserEditScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserEditScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends ConsumerState<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  
  bool _loading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _userData;
  String? _gravatar;
  String? _generalError;
  Map<String, List<String>>? _updateErrors;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = ref.read(authProvider).user;
      if (currentUser == null || currentUser.id.toString() != widget.userId) {
        context.go('/');
        return;
      }

      final response = await UserService().editUser(widget.userId);

      setState(() {
        _userData = response['user'];
        _gravatar = response['gravatar'];
        
        _nameController.text = response['user']['name'] ?? '';
        _emailController.text = response['user']['email'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: ${e.toString()}')),
      );
      context.go('/');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _generalError = null;
      _updateErrors = null;
    });

    try {
      final params = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password_confirmation': _passwordConfirmationController.text,
      };

      final response = await UserService().updateUser(widget.userId, {'user': params});

      if (response.containsKey('flash_success')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['flash_success'][1])),
        );
        context.go('/users/${widget.userId}');
      } else if (response.containsKey('error')) {
        setState(() {
          _generalError = response['error'] is List 
              ? response['error'][0] 
              : response['error'].toString();
        });
      }
    } catch (e) {
      if (e is Map && e.containsKey('errors')) {
        setState(() {
          _updateErrors = Map<String, List<String>>.from(e['errors']);
        });
      } else if (e is Map && e.containsKey('error')) {
        setState(() {
          _generalError = e['error'] is List 
              ? e['error'][0] 
              : e['error'].toString();
        });
      } else {
        setState(() {
          _generalError = 'An error occurred while updating your profile. Please try again.';
        });
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: const Center(child: LoadingSpinner()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Update your profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  if (_generalError != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        _generalError!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                    
                  if (_updateErrors != null && _updateErrors!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _updateErrors!.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entry.value.map((error) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  '${entry.key.substring(0, 1).toUpperCase()}${entry.key.substring(1)} $error',
                                  style: TextStyle(color: Colors.red.shade900),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  
                  if (_gravatar != null)
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://secure.gravatar.com/avatar/$_gravatar?s=80',
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      helperText: 'Leave blank if you don\'t want to change it',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != null && value.isNotEmpty && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _passwordConfirmationController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
                        return 'Passwords must match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _updateUser,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
