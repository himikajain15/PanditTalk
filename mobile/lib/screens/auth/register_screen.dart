// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  String? _error;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });

    final userProv = Provider.of<UserProvider>(context, listen: false);
    final res = await userProv.register(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim());

    setState(() { _isLoading = false; });

    if (res['ok']) {
      // registration successful — navigate to login
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered. Please login.')));
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() { _error = 'Registration failed: ${res['error'] ?? 'Server error'}'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final saffron = AppTheme.saffron;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: saffron, title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Username', prefixIcon: const Icon(Icons.person_outline)),
                      validator: (val) => (val == null || val.isEmpty) ? 'Enter username' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email_outlined)),
                      validator: (val) => (val == null || val.isEmpty) ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                      validator: (val) => (val == null || val.length < 6) ? 'Password min 6 chars' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline)),
                      validator: (val) => val != _passwordController.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 18),
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                    ],
                    _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(backgroundColor: saffron, minimumSize: const Size.fromHeight(48)),
                          child: const Text("Create Account"),
                        ),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text("Back to Login")),
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
