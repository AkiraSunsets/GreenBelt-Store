import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/text_field.dart';
import '../components/primary_button.dart';
import '../components/social_icon.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Remove espaços extras
    final nome = _nameController.text.trim();
    final email = _emailController.text.trim();
    final senha = _passwordController.text;

    setState(() => _isLoading = true);

    final erro = await AuthService.cadastrar(
      nome: nome,
      email: email,
      senha: senha,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (erro != null) {
      // Mostra o erro em um SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro, style: GoogleFonts.montserrat()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Cadastro OK → faz login automático e vai para HomeScreen
    await AuthService.salvarSessao(email.toLowerCase(), nome: nome);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
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
                const Icon(Icons.spa_outlined, color: Color(0xFF881F72), size: 100),
                const SizedBox(height: 30),
                Text(
                  'Criar Conta',
                  style: GoogleFonts.montserrat(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Preencha suas informações ou cadastre-se\ncom sua rede social',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _nameController,
                  label: 'Nome',
                  hintText: 'Ex: Seu Nome Completo',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  hintText: 'seu@email.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  hintText: '********',
                  isPassword: true,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mínimo de 6 caracteres',
                    style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF881F72))
                    : PrimaryButton(text: 'CADASTRAR', onPressed: _handleSignUp),
                const SizedBox(height: 40),
                const SizedBox(width: 300, child: Divider(thickness: 1.5, color: Colors.black12)),
                const SizedBox(height: 20),
                
                // Ícones sociais corrigidos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIconButton(iconData: Icons.g_mobiledata, onTap: () {}),
                    const SizedBox(width: 20),
                    SocialIconButton(iconData: Icons.apple, onTap: () {}),
                    const SizedBox(width: 20),
                    SocialIconButton(iconData: Icons.facebook, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Link para voltar ao Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui uma conta?',
                      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Entrar',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF881F72),
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