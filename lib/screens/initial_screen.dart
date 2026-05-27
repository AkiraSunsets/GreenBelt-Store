import 'package:flutter/material.dart';
import 'package:greenbelt_flutter/screens/home_screen.dart';
import 'package:greenbelt_flutter/screens/onboarding_screen.dart';
import 'package:greenbelt_flutter/services/auth_service.dart';
import 'package:greenbelt_flutter/models/app_state.dart';

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    final logado = await AuthService.isLogado();
    if (!logado || !mounted) return;

    final nome = await AuthService.getNome();
    final email = await AuthService.getEmail();

    if (!mounted) return;

    AppStateProvider.of(context).setUsuario(nome: nome, email: email);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.spa_outlined, color: Color(0xFF881F72), size: 120),
              const SizedBox(height: 20),
              const Text(
                'Greenbelt Store',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TesteSplashScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF881F72),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text(
                    'Iniciar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}