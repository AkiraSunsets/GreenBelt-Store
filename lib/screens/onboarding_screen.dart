import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;
import 'package:greenbelt_flutter/screens/start_screen.dart';

class TesteSplashScreen extends StatefulWidget {
  const TesteSplashScreen({super.key});

  @override
  State<TesteSplashScreen> createState() => _TesteSplashScreenState();
}

class _TesteSplashScreenState extends State<TesteSplashScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> splashData = [
    {
      "image": "https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?auto=format&fit=crop&w=1080&q=80",
      "title1": "Seamless",
      "title2": "Flower",
      "subtitle": "Shopping Experience",
    },
    {
      "image": "https://images.unsplash.com/photo-1615280825886-fa817c0a06cc?auto=format&fit=crop&w=1080&q=80",
      "title1": "Craft",
      "title2": "Your Ultimate",
      "subtitle": "Floral Collection",
    },
    {
      "image": "https://images.unsplash.com/photo-1468327768560-75b778cbb551?auto=format&fit=crop&w=1080&q=80",
      "title1": "From Cart to Door",
      "title2": "",
      "subtitle": "Swift & Delivery Flower",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pegando as dimensões da tela para ser responsivo
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: splashData.length,
            itemBuilder: (context, index) {
              final item = splashData[index];

              // Usamos SingleChildScrollView para evitar overflow em telas pequenas
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.5, // Imagem ocupa 50% da altura da tela
                      child: Image.network(
                        item["image"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item["title1"]!,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF881F72),
                            fontSize: size.width * 0.065, // Fonte relativa à largura
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item["title2"]!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            item["title2"]!,
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: size.width * 0.065,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: size.height * 0.015),

                    Text(
                      item["subtitle"]!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: size.width * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam volutpat eu turpis sit amet.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: size.width * 0.04,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    // Botão responsivo usando largura relativa
                    SizedBox(
                      width: size.width * 0.8,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (index < splashData.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const StartScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF881F72),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          index == splashData.length - 1 ? 'Começar' : 'Próximo',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    // Espaçamento extra dinâmico para garantir que não corte no rodapé
                    SizedBox(height: bottomPadding + 80),
                  ],
                ),
              );
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding + 20),
              child: smooth_page_indicator.SmoothPageIndicator(
                controller: _pageController,
                count: splashData.length,
                effect: const smooth_page_indicator.SlideEffect(
                  spacing: 8,
                  radius: 10,
                  dotWidth: 18,
                  dotHeight: 8,
                  dotColor: Color(0xFFD9D9D9),
                  activeDotColor: Color(0xFF881F72),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}