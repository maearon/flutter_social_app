import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_app/features/account_activation/services/account_activation_service.dart';
import 'package:flutter_social_app/core/widgets/loading_spinner.dart';

class AccountActivationScreen extends ConsumerStatefulWidget {
  final String token;
  final String email;

  const AccountActivationScreen({
    Key? key,
    required this.token,
    required this.email,
  }) : super(key: key);

  @override
  ConsumerState<AccountActivationScreen> createState() => _AccountActivationScreenState();
}

class _AccountActivationScreenState extends ConsumerState<AccountActivationScreen> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _activateAccount();
  }

  Future<void> _activateAccount() async {
    if (widget.token.isEmpty) {
      setState(() {
        _error = 'Invalid activation link';
        _loading = false;
      });
      return;
    }

    if (widget.email.isEmpty) {
      setState(() {
        _error = 'Email parameter is missing';
        _loading = false;
      });
      return;
    }

    try {
      final response = await AccountActivationService().activateAccount(widget.token, widget.email);

      if (response.flash.isNotEmpty && response.flash.length > 1) {
        // Show success message and navigate to login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.flash[1])),
          );
          
          // Delay navigation to allow user to see the success message
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.go('/login');
            }
          });
        }
      } else if (response.error != null) {
        setState(() {
          _error = response.error is List 
              ? response.error[0] 
              : response.error.toString();
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Activation'),
      ),
      body: _loading
          ? const Center(child: LoadingSpinner())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _error != null
                    ? Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Activation Error',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context.go('/account-activation'),
                                child: const Text('Request New Activation Link'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        color: Colors.green.shade50,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Account Activated Successfully',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your account has been activated. You will be redirected to the login page shortly.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
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
