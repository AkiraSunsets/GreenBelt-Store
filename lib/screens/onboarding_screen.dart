import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TesteSplashScreen(),
    );
  }
}

class TesteSplashScreen extends StatefulWidget {
  const TesteSplashScreen({super.key});

  @override
  State<TesteSplashScreen> createState() => _TesteSplashScreenState();
}

class _TesteSplashScreenState extends State<TesteSplashScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> splashData = [
    {
      "image":
          "https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?auto=format&fit=crop&w=1080&q=80",
      "title1": "Seamless",
      "title2": "Flower",
      "subtitle": "Shopping Experience",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1615280825886-fa817c0a06cc?auto=format&fit=crop&w=1080&q=80",
      "title1": "Craft",
      "title2": "Your Ultimate",
      "subtitle": "Floral Collection",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1468327768560-75b778cbb551?auto=format&fit=crop&w=1080&q=80",
      "title1": "From Cart to Door",
      "title2": "",
      "subtitle": "Swift & Delivery Flower",
    },
  ];

  @override
  Widget build(BuildContext context) {
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

              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.58,
                    child: Image.network(
                      item["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item["title1"]!,
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF881F72),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (item["title2"]!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          item["title2"]!,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    item["subtitle"]!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam volutpat eu turpis sit amet.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: 300,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (index < splashData.length - 1) {
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
                        index == splashData.length - 1
                            ? 'Começar'
                            : 'Próximo',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 90),
                ],
              );
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
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