import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  final String assetPath;

  const BannerCard({
    super.key,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}