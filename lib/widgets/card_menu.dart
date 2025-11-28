import 'package:flutter/material.dart';

class CardMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page;

  const CardMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
