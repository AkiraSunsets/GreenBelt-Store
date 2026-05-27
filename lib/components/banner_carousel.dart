import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'banner_card.dart'; 

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: const [
                BannerCard(assetPath: 'assets/images/1.jpg'),
                BannerCard(assetPath: 'assets/images/2.jpg'),
                BannerCard(assetPath: 'assets/images/3.jpg'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const SlideEffect(
              dotWidth: 8,
              dotHeight: 8,
              dotColor: Color(0xFFEBEBEB),
              activeDotColor: Color(0xFF881F72),
            ),
          ),
        ],
      ),
    );
  }
}