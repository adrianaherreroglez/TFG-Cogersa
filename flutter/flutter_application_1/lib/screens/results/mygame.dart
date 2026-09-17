import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGame extends StatefulWidget {
  final int puntosPrevios;

  const MyGame({super.key, required this.puntosPrevios});

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFfafdf4),

        child: Column(
          children: [
            const SizedBox(height: 40),

            // TÍTULOS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Clasificación',
                  style: GoogleFonts.quicksand(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF298133),
                  ),
                ),

                const SizedBox(width: 200),

                Text(
                  'Mi Partida',
                  style: GoogleFonts.quicksand(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF298133),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // PUNTOS
            Padding(
              padding: const EdgeInsets.only(left: 500),
              child: Text(
                'Puntos: ${widget.puntosPrevios}',
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 244, 64, 9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
