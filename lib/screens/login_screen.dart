import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenbelt_flutter/screens/home_screen.dart';

import '../components/text_field.dart';
import '../components/primary_button.dart';
import '../components/social_icon.dart';

class TelaLoginWidget extends StatefulWidget {
  const TelaLoginWidget({super.key});

  @override
  State<TelaLoginWidget> createState() => _TelaLoginWidgetState();
}

class _TelaLoginWidgetState extends State<TelaLoginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.spa_outlined, color: Color(0xFF6500B2), size: 100),
                const SizedBox(height: 30),
                Text(
                  'Sign In',
                  style: GoogleFonts.montserrat(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hi! Welcome back, you\'ve been missed',
                  style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'email@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: '********',
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => print('Forget Password Tapped'),
                    child: Text(
                      'Forget Password?',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600, 
                        color: const Color(0xFF6500B2),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  text: 'Sign In',
                  onPressed: () {
                    print('Email: ${_emailController.text}');
                    print('Senha: ${_passwordController.text}');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 40),
                const SizedBox(width: 300, child: Divider(thickness: 1.5, color: Colors.black12)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIconButton(iconData: Icons.apple_sharp, onTap: () {}),
                    const SizedBox(width: 20),
                    SocialIconButton(iconData: Icons.apple_sharp, onTap: () {}),
                    const SizedBox(width: 20),
                    SocialIconButton(iconData: Icons.apple_sharp, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => print('Sign Up Tapped'),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600, 
                          color: const Color(0xFF6500B2),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}