import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      color: const Color(0xFF298133),
      child: Row(
        children: [
          const SizedBox(width: 40),

          Text(
            'EcoKids',
            style: GoogleFonts.quicksand(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          TextButton(
            onPressed: () {
              context.go('/');
            },
            child: Text(
              'Inicio',
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 30),

          TextButton(
            onPressed: () {
              context.go('/listgame');
            },
            child: Text(
              'Juegos',
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

