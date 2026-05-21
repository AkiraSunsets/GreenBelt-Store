import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:AvaliacaoVini/Components/card-project.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mensagemController = TextEditingController();
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.85,
  );

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _mensagemController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _abrirLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      throw Exception('Não foi possível abrir o link: $url');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // HEADER
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF0B1023),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Color(0xFF676767),
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KA',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.menu, color: Colors.white, size: 40),
                ],
              ),
            ),
          ),

          const SizedBox(height: 60),

          // FOTO - com responsividade :D
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              constraints: const BoxConstraints(
                maxWidth: 320,
                maxHeight: 320,
                minWidth: 150,
                minHeight: 150,
              ),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    color: Color(0xFF873693),
                    offset: Offset(2, 2),
                  ),
                ],
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF873693), width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://akira-sunsets-portfolio.vercel.app/assets/img/foto.jpg',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // TEXTOS
          Column(
            children: [
              const Text(
                "Hello I'm",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              GradientText(
                "Ketlyn Araújo",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                colors: const [Color(0xFFBF0C6D), Color(0xFF3A2DFF)],
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Text(
            "Web Developer | Frontend - UX/UI",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 30),

          //Section button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDA0067), Color(0xFF6919AB)],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),

                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "See More",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFDA0067),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Download CV",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 15),
                      const FaIcon(
                        FontAwesomeIcons.download,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          //titulo about me
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "About ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                    GradientText(
                      "Me",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: const [Color(0xFFBF0C6D), Color(0xFF3A2DFF)],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          //about me
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(),
                  child: Text(
                    "Sou a Ketlyn Araújo, estudante de Ciência da Computação e apaixonada por construir pontes entre o código e o design. Atualmente, atuo como Aprendiz em Soluções Digitais na Bosch Brasil, onde mergulho diariamente no universo corporativo para transformar problemas complexos em interfaces funcionais e intuitivas.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14162A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12, width: 0.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.tools,
                      color: Color(0xFF4B39EF),
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "IoT Inovation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Soluções inteligentes com dispositivos conectados.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14162A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12, width: 0.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.lightbulb,
                      color: Color(0xFF4B39EF),
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Problem Solver",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Soluções Simples para problemas complexos.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14162A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12, width: 0.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.terminal,
                      color: Color(0xFF4B39EF),
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Frontend Developer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "React, Flutter e interfaces modernas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14162A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12, width: 0.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.tools,
                      color: Color(0xFF4B39EF),
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "IoT Innovation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Soluções inteligentes com dispositivos conectados.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 80),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Soft",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),

                    const SizedBox(width: 10),

                    GradientText(
                      "Skills",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: const [Color(0xFFBF0C6D), Color(0xFF3A2DFF)],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Habilidades interpessoais desenvolvidas no ambiente corporativo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Communication",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.85,
                          minHeight: 9,
                          backgroundColor: const Color(0xFF14162A),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4B39EF),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),
                    const Text(
                      "85%",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          //soft skills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Teamwork",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.85,
                          minHeight: 9,
                          backgroundColor: const Color(0xFF14162A),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFAB16E5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),
                    const Text(
                      "85%",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          //soft skills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Critical Thinking",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.85,
                          minHeight: 9,
                          backgroundColor: const Color(0xFF14162A),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF0E8EC3),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),
                    const Text(
                      "85%",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          //soft skills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Organization",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.9,
                          minHeight: 9,
                          backgroundColor: const Color(0xFF14162A),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFDF118B),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),
                    const Text(
                      "90%",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          //soft skills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Technical",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),

                    const SizedBox(width: 10),

                    GradientText(
                      "Skills",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: const [Color(0xFFBF0C6D), Color(0xFF3A2DFF)],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tecnologias que tenho me aprimorado recentemente.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
              ],
            ),
          ),

          //soft skills
          const SizedBox(height: 30),

          //tech skills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  // HTML
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.html5,
                          color: Color(0xFFE34F26),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "HTML",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CSS
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.css3Alt,
                          color: Color(0xFF1572B6),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "CSS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // JS
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.js,
                          color: Color(0xFFF7DF1E),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "JS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // React
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.react,
                          color: Color(0xFF61DAFB),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "React",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tailwind
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.wind,
                          color: Color(0xFF06B6D4),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Tailwind",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Python
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.python,
                          color: Color(0xFF3776AB),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Python",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Django
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.code,
                          color: Color(0xFF092E20),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Django",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Java
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.java,
                          color: Color(0xFF007396),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Java",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // MySQL
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.database,
                          color: Color(0xFF4479A1),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "MySQL",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arduino
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.developer_board,
                          color: Color(0xFF00979D),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Arduino",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Git
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gitAlt,
                          color: Color(0xFFF05032),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Git",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Figma
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14162A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.figma,
                          color: Color(0xFFF24E1E),
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Figma",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 50),

          //titulo projects
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "My ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                    GradientText(
                      "Projects",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: const [Color(0xFFBF0C6D), Color(0xFF3A2DFF)],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Alguns projetos realizados por mim",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double dynamicHeight = constraints.maxWidth < 350 ? 460 : 440;
                  return SizedBox(
                    height: dynamicHeight,
                    child: PageView(
                      controller: _pageController,
                      clipBehavior: Clip.none,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        //projeto 1 - PN Technical
                        const CardProjeto(
                          titulo: 'PN Technical Analysis',
                          subtitulo: 'Frontend Developer | UX/UI',
                          descricao:
                              'Plataforma que analisa dados técnicos e sugere alternativas sustentáveis corporativas.',
                          imagemUrl:
                              'https://akira-sunsets-portfolio.vercel.app/assets/img/pn.svg',
                          tags: [
                            '#React',
                            '#TailwindCSS',
                            '#Django',
                            '#Sqlite',
                            '#Figma',
                          ],
                          participantes: '3',
                        ),

                        //projeto 2 - let movie
                        const CardProjeto(
                          titulo: 'LetMovie',
                          subtitulo: 'Fullstack Developer | UX/UI',
                          descricao:
                              'Plataforma web de catálogo de filmes com painel administrativo e foco na usabilidade.',
                          imagemUrl:
                              'https://akira-sunsets-portfolio.vercel.app/assets/img/letmovie.svg',
                          tags: [
                            '#React',
                            '#MySQL',
                            '#Python',
                            '#Figma',
                            '#Krita',
                          ],
                          link: 'https://github.com/AkiraSunsets/LetMovie',
                          participantes: '1',
                        ),

                        //projeto 3 - tt
                        const CardProjeto(
                          titulo: 'Tool & Tech',
                          subtitulo: 'Fullstack Developer | UX/UI',
                          descricao:
                              'Sistema de monitoramento de sensores (luminosidade, umidade, temp) em tempo real.',
                          imagemUrl:
                              'https://akira-sunsets-portfolio.vercel.app/assets/img/tt.svg',
                          tags: [
                            '#React',
                            '#Django',
                            '#Sqlite',
                            '#Bootstrap',
                            '#Figma',
                          ],
                          link: 'https://github.com/AkiraSunsets/Tool-and-Tech',
                          participantes: '1',
                        ),

                        //projeto 4 - cora
                        const CardProjeto(
                          titulo: 'CORA',
                          subtitulo: 'Frontend Developer | UX/UI',
                          descricao:
                              'Solução para gestão de tickets de cartão corporativo. Premiada pelo Voto Popular no Hackathon Bosch.',
                          imagemUrl:
                              'https://akira-sunsets-portfolio.vercel.app/assets/img/cora.svg',
                          tags: [
                            '#React',
                            '#FastAPI',
                            '#Pandas',
                            '#Selenium',
                            '#Sqlite',
                          ],
                          participantes: '4',
                        ),

                        //projeto 5 - magic shop
                        const CardProjeto(
                          titulo: 'Magic Shop',
                          subtitulo: 'Frontend Developer | UX/UI',
                          descricao:
                              'Simulação de e-commerce para venda de pelúcias com navegação intuitiva.',
                          imagemUrl:
                              'https://akira-sunsets-portfolio.vercel.app/assets/img/magicshop.svg',
                          tags: ['#HTML', '#CSS', '#Bootstrap', '#Figma'],
                          link:
                              'https://github.com/AkiraSunsets/Magic-Shop-Lima',
                          participantes: '1',
                        ),

                        //projeto 6 - chacaras
                        const CardProjeto(
                          titulo: 'Espaço para Eventos',
                          subtitulo: 'Frontend Developer | UX/UI',
                          descricao:
                              'Portfólio digital para divulgação de chácaras, reunindo informações e contato.',
                          imagemUrl:
                              'https://akira-sunsets-portfolio.vercel.app/assets/img/chacaras.jpg',
                          tags: [
                            '#HTML',
                            '#CSS',
                            '#Javascript',
                            '#Node.js',
                            '#Figma',
                          ],
                          link:
                              'https://ketlynlnaraujo.wixsite.com/espacoparachacaras',
                          participantes: '2',
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Indicador de Páginas
              SmoothPageIndicator(
                controller: _pageController,
                count: 6,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color(0xFFBF0C6D),
                  dotColor: Color(0xFF14162A),
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 8,
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Experiences',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF14162A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDA0067), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.work_outline,
                    color: Color(0xffda0067),
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aprendiz de Soluções Digitais',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Bosch Brazil',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Jan/2025 - Atual',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF14162A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDA0067), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.work_outline,
                    color: Color(0xffda0067),
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aprendiz Administrativo',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'LSL - Honda',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Abr/2024 - Dez/2024',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF14162A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDA0067), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.work_outline,
                    color: Color(0xffda0067),
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estágiario em Suporte Técnico',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ciclo Básico I - UNICAMP',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Mai/2023 - Dez/2023',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          Divider(thickness: 0.2, color: Colors.grey),

          const SizedBox(height: 30),

          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Education',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF14162A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDA0067), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.graduationCap,
                    color: Color(0xffda0067),
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bacharel em Ciências da Computação',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'FAM - Faculdade das Américas',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Fev/2025 - Dez/2028',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF14162A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDA0067), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.graduationCap,
                    color: Color(0xffda0067),
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Técnico em Desenvolvimento de Sistemas',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'SENAI - Roberto Mange',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Jan/2025 - Jul/2026',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF14162A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDA0067), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.graduationCap,
                    color: Color(0xffda0067),
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ensino Médio Técnico em Informática',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'E.M. Dr. Leandro Franceschini',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Fev/2020 - Dez/2023',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Get In ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                    GradientText(
                      "Touch",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: const [Color(0xFFBF0C6D), Color(0xFF3A2DFF)],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Seja para um projeto ou apenas para dar um 'oi', minha caixa de entrada está sempre aberta!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // seção: email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xffeca0c7),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xffff1493),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.email_outlined,
                        color: Color(0xffff1493),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Color(0xffff1493),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ketlynlorraynendearaujo@gmail.com',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // location
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xffeca0c7),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xffff1493),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.pin_drop_outlined,
                        color: Color(0xffff1493),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Location',
                            style: TextStyle(
                              color: Color(0xffff1493),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'São Paulo - Brazil',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // whats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffeca0c7),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xffff1493),
                          width: 1,
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Color(0xffff1493),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Whatsapp',
                            style: TextStyle(
                              color: Color(0xffff1493),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '(19) 99751-2002',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _nomeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Digite seu nome',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0x16ffffff),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seu melhor e-mail:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Digite seu email',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0x16ffffff),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sua mensagem...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _mensagemController,
                        maxLines: 4,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Deixe sua mensagem...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0x16ffffff),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      String usuario = _nomeController.text;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            usuario.isEmpty
                                ? 'Por favor, digite seu nome antes de enviar!'
                                : 'Obrigado, $usuario! Mensagem enviada com sucesso.',
                          ),
                          backgroundColor: const Color(0xFFBF0C6D),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFBF0C6D), Color(0xFF3A2DFF)],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enviar Mensagem',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.send, color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0B1023),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: Color(0x33FFFFFF),
                        offset: Offset(0, 2),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      const Text(
                        'Designed and built by Ketlyn Araújo.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _abrirLink(
                              'https://www.linkedin.com/in/ketlyn-lorrayne-niza-de-araujo/',
                            ),
                            icon: const FaIcon(
                              FontAwesomeIcons.linkedin,
                              color: Color(0xFFFF1493),
                              size: 40,
                            ),
                          ),

                          const SizedBox(width: 20),

                          IconButton(
                            onPressed: () =>
                                _abrirLink('https://github.com/AkiraSunsets'),
                            icon: const FaIcon(
                              FontAwesomeIcons.github,
                              color: Color(0xFFFF1493),
                              size: 40,
                            ),
                          ),

                          const SizedBox(width: 20),

                          IconButton(
                            onPressed: () =>
                                _abrirLink('https://github.com/AkiraSunsets'),
                            icon: const FaIcon(
                              FontAwesomeIcons.instagram,
                              color: Color(0xFFFF1493),
                              size: 40,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}