import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Importe os componentes que criamos anteriormente
import '../components/text_field.dart';
import '../components/primary_button.dart';
import '../components/social_icon.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para os campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Ícone do Topo ---
                const Icon(
                  Icons.spa_outlined,
                  color: Color(0xFF881F72),
                  size: 100,
                ),

                const SizedBox(height: 30),

                // --- Título e Subtítulo ---
                Text(
                  'Create Account',
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Fill your information or register with your social account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 40),

                // --- Inputs usando nosso Componente ---
                CustomTextField(
                  controller: _nameController,
                  label: 'Name',
                  hintText: 'Ex: Akira Sunsets',
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 40),

                // --- Botão de Cadastro ---
                PrimaryButton(
                  text: 'Sign Up',
                  onPressed: () {
                    print('Name: ${_nameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');

                    // Aqui entrará a lógica de salvar no banco/API futuramente
                  },
                ),

                const SizedBox(height: 40),

                // --- Divisor ---
                const SizedBox(
                  width: 300,
                  child: Divider(thickness: 1.5, color: Colors.black12),
                ),

                const SizedBox(height: 20),

                // --- Redes Sociais usando nosso Componente ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIconButton(
                      iconData: Icons.apple_sharp,
                      onTap: () => print('Apple Login'),
                    ),
                    const SizedBox(width: 20),
                    SocialIconButton(
                      iconData: Icons.apple_sharp,
                      onTap: () => print('Google Login'),
                    ),
                    const SizedBox(width: 20),
                    SocialIconButton(
                      iconData: Icons.apple_sharp,
                      onTap: () => print('Facebook Login'),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // --- Link para Login ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // Como a tela de login já deve estar na pilha de navegação,
                        // usamos o pop para voltar a ela e economizar memória.
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
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
