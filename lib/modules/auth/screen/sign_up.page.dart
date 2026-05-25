import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jigyasa/modules/auth/screen/login.page.dart';
import 'package:jigyasa/modules/auth/repository/auth.service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _professionController = TextEditingController();

  bool _obscurePwd = true;
  bool _obscureConfirmPwd = true;
  bool _isSubmitting = false;
  bool _agree = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await authService.signup(
        fullName: _fullNameCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        profession: _professionController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account created!')));
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE6E8EE)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF4F8BFF), width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryBlue = Color(0xFF4F8BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (logo + title)
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFE9F0FF),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.lightbulb, color: primaryBlue),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Jigyasa',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Create Account',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Join the community of idea creators',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        const Text('Full Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fullNameCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: _fieldDecoration(
                            hint: 'Enter your name',
                            icon: Icons.person_outline,
                          ),
                          validator: (v) {
                            if ((v ?? '').trim().isEmpty) {
                              return 'Full name is required';
                            }
                            if (v!.trim().length < 2) {
                              return 'Full name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // // Separator + Social buttons
                        // Row(
                        //   children: const [
                        //     Expanded(child: Divider()),
                        //     Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 10),
                        //       child: Text('or'),
                        //     ),
                        //     Expanded(child: Divider()),
                        //   ],
                        // ),
                        // const SizedBox(height: 12),
                        // Row(
                        //   children: [
                        //     // Expanded(
                        //     //   child: OutlinedButton.icon(
                        //     //     onPressed: () {},
                        //     //     icon: const Icon(Icons.code, color: Colors.black87),
                        //     //     label: const Text('GitHub', style: TextStyle(color: Colors.black87)),
                        //     //     style: OutlinedButton.styleFrom(
                        //     //       side: const BorderSide(color: Color(0xFFE5E7EB)),
                        //     //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        //     //       padding: const EdgeInsets.symmetric(vertical: 14),
                        //     //       backgroundColor: const Color(0xFFF5F7FB),
                        //     //     ),
                        //     //   ),
                        //     // ),
                        //     const SizedBox(width: 12),
                        //     Expanded(
                        //       child: OutlinedButton.icon(
                        //         onPressed: () {},
                        //         icon: const Icon(Icons.g_mobiledata, color: Colors.black87),
                        //         label: const Text('Google', style: TextStyle(color: Colors.black87)),
                        //         style: OutlinedButton.styleFrom(
                        //           side: const BorderSide(color: Color(0xFFE5E7EB)),
                        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        //           padding: const EdgeInsets.symmetric(vertical: 14),
                        //           backgroundColor: const Color(0xFFF5F7FB),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 6),

                        // Username (extra)
                        const Text('Username'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _usernameCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: _fieldDecoration(
                            hint: 'Choose a username',
                            icon: Icons.alternate_email,
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Username is required';
                            final valid = RegExp(
                              r'^[a-zA-Z0-9._-]{3,}$',
                            ).hasMatch(value);
                            if (!valid) {
                              return '3+ chars, letters/numbers/._- only';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        const Text('Email'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailCtrl,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _fieldDecoration(
                            hint: 'Enter your email',
                            icon: Icons.mail_outline,
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Email is required';
                            final valid = RegExp(
                              r'^[^@]+@[^@]+\.[^@]+$',
                            ).hasMatch(value);
                            if (!valid) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        const Text('Password'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePwd,
                          textInputAction: TextInputAction.next,
                          decoration: _fieldDecoration(
                            hint: 'Create a password',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePwd
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscurePwd = !_obscurePwd,
                                  ),
                            ),
                          ),
                          validator: (v) {
                            final value = (v ?? '');
                            if (value.isEmpty) return 'Password is required';
                            if (value.length < 6)
                              return 'At least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password
                        const Text('Confirm Password'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordCtrl,
                          obscureText: _obscureConfirmPwd,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onSubmit(),
                          decoration: _fieldDecoration(
                            hint: 'Confirm your password',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPwd
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed:
                                  () => setState(
                                    () =>
                                        _obscureConfirmPwd =
                                            !_obscureConfirmPwd,
                                  ),
                            ),
                          ),
                          validator: (v) {
                            if ((v ?? '').isEmpty)
                              return 'Please confirm your password';
                            if (v != _passwordCtrl.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),

                        // Role (optional)
                        const Text('Profession'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _professionController,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onSubmit(),
                          decoration: _fieldDecoration(
                            hint: 'Product Designer',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPwd
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed:
                                  () => setState(
                                    () =>
                                        _obscureConfirmPwd =
                                            !_obscureConfirmPwd,
                                  ),
                            ),
                          ),
                          validator: (v) {
                            if ((v ?? '').isEmpty) {
                              return 'Please enter your profession';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Terms and Privacy
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agree,
                              onChanged:
                                  (v) => setState(() => _agree = v ?? false),
                              activeColor: const Color(0xFF4F8BFF),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(color: Colors.black87),
                                  children: [
                                    TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms',
                                      style: TextStyle(
                                        color: Color(0xFF4F8BFF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy',
                                      style: TextStyle(
                                        color: Color(0xFF4F8BFF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Submit
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _onSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child:
                                _isSubmitting
                                    ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Footer: login link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.black54,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                TextSpan(
                                  text: 'Sign in',
                                  style: const TextStyle(
                                    color: primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
