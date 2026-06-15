import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 200,
        leading: TextButton.icon(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6B7280), size: 20),
          label: const Text(
            'Back to sign in',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 24),
            alignment: Alignment.centerLeft,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildLabel('Name'),
              _buildTextField(
                controller: _nameController,
                hint: 'Jane Doe',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildLabel('Username'),
              _buildTextField(
                controller: _usernameController,
                hint: 'fitness_jane',
                prefixIcon: Icons.alternate_email,
              ),
              const SizedBox(height: 20),
              _buildLabel('Email'),
              _buildTextField(
                controller: _emailController,
                hint: 'you@example.com',
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 20),
              _buildLabel('Password'),
              _buildTextField(
                controller: _passwordController,
                hint: 'Min. 8 characters',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildLabel('Confirm Password'),
              _buildTextField(
                controller: _confirmPasswordController,
                hint: 'Re-enter password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 40),
              Obx(() => _buildPrimaryButton(
                text: controller.isLoading.value ? 'Loading...' : 'Create account',
                onPressed: controller.isLoading.value ? () {} : () async {
                  if (_nameController.text.isEmpty || 
                      _usernameController.text.isEmpty || 
                      _emailController.text.isEmpty || 
                      _passwordController.text.isEmpty || 
                      _confirmPasswordController.text.isEmpty) {
                    Get.snackbar('Error', 'Please fill in all fields',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white);
                    return;
                  }
                  if (_passwordController.text != _confirmPasswordController.text) {
                    Get.snackbar('Error', 'Passwords do not match',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white);
                    return;
                  }
                  await controller.registerUser(_nameController.text, _usernameController.text, _emailController.text, _passwordController.text, _confirmPasswordController.text);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF9CA3AF), size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF111827), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111827),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
