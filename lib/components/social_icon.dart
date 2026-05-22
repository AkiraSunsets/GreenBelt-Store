import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;

  const SocialIconButton({
    super.key,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          color: Colors.white,
        ),
        child: Icon(
          iconData,
          color: const Color(0xFF6500B2),
          size: 30,
        ),
      ),
    );
  }
}