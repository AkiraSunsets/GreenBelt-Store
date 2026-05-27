import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:greenbelt_flutter/screens/start_screen.dart';

class TesteSplashScreen extends StatefulWidget {
  const TesteSplashScreen({super.key});

  @override
  State<TesteSplashScreen> createState() => _TesteSplashScreenState();
}

class _TesteSplashScreenState extends State<TesteSplashScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> splashData = [
    {
      "image":
          "https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?auto=format&fit=crop&w=1080&q=80",
      "title1": "Bem-vindo à",
      "title2": "GreenBelt",
      "subtitle": "Sua melhor experiência botânica",
      "body":
          "Encontre as flores perfeitas para alegrar o seu dia ou presentear quem você ama com muita praticidade.",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1615280825886-fa817c0a06cc?auto=format&fit=crop&w=1080&q=80",
      "title1": "Buquês e",
      "title2": "Pelúcias",
      "subtitle": "Para todas as ocasiões",
      "body":
          "Explore nossa coleção montada com carinho para transformar momentos simples em lembranças inesquecíveis.",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1468327768560-75b778cbb551?auto=format&fit=crop&w=1080&q=80",
      "title1": "Entrega",
      "title2": "Rápida",
      "subtitle": "Do carrinho até a sua porta",
      "body":
          "Garantimos que o seu pedido chegue fresco e no prazo exato, pronto para surpreender.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: splashData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = splashData[index];

              return Column(
                children: [
                  Expanded(
                    flex: 55,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(item["image"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 45, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                item["title1"]!,
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xFF881F72),
                                  fontSize:
                                      28, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item["title2"]!.isNotEmpty)
                                Text(
                                  item["title2"]!,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item["body"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    smooth_page_indicator.SmoothPageIndicator(
                      controller: _pageController,
                      count: splashData.length,
                      effect: const smooth_page_indicator.SlideEffect(
                        spacing: 8,
                        radius: 10,
                        dotWidth: 18,
                        dotHeight: 8,
                        dotColor: Color(0xFFEBEBEB),
                        activeDotColor: Color(0xFF881F72),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentIndex == splashData.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StartScreen(),
                              ),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
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
                          _currentIndex == splashData.length - 1
                              ? 'COMEÇAR'
                              : 'PRÓXIMO',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}