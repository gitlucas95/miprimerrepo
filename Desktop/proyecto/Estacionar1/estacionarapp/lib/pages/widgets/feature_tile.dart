import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF1AA34A)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
