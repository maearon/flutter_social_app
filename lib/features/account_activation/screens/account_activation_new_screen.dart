import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_app/core/models/api_response_message.dart';
import 'package:flutter_social_app/features/account_activation/services/account_activation_service.dart';

class AccountActivationNewScreen extends ConsumerStatefulWidget {
  const AccountActivationNewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountActivationNewScreen> createState() => _AccountActivationNewScreenState();
}

class _AccountActivationNewScreenState extends ConsumerState<AccountActivationNewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  String? _error;
  String? _success;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resendActivationEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
      _success = null;
    });

    try {
      final rawResponse = await AccountActivationService().resendActivationEmail(_emailController.text);
      final response = ApiResponseMessage.fromJson(rawResponse as Map<String, dynamic>);

      setState(() {
        _success = response.success;
        _error = response.error;
        if (_success != null) {
          _emailController.clear();
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resend Activation Email'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Resend Activation Email',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    if (_success != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Text(_success!, style: TextStyle(color: Colors.green.shade900)),
                      ),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Text(_error!, style: TextStyle(color: Colors.red.shade900)),
                      ),
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _resendActivationEmail,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        child: _isSubmitting
                            ? const CircularProgressIndicator()
                            : const Text('Resend Activation Email'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
