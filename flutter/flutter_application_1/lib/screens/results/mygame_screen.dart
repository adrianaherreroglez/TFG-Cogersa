import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/nav_bar.dart' ;

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
            // BARRA DE NAVEGACIÓN
            const NavBar(),

            const SizedBox(height: 30),

            // TÍTULOS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CLASIFICACIÓN
                Column(
                  children: [
                    Text(
                      'Clasificación',
                      style: GoogleFonts.quicksand(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF298133),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Cuadrado de clasificación
                    Container(
                      width: 500,
                      height: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xFFd8edd5),
                        border: Border.all(
                          color: const Color(0xFF298133),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                    ),
                  ],
                ),

                const SizedBox(width: 200),

                // Mi partida
                Column(
                  children: [
                    Text(
                      'Mi Partida',
                      style: GoogleFonts.quicksand(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF298133),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Cuadrado debajo de mi partida
                    Container(
                      width: 500,
                      height: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xFFd8edd5),
                        border: Border.all(
                          color: const Color(0xFF298133),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      // Puntos dentro del cuadrado
                      child: Text(
                        'Puntos: ${widget.puntosPrevios}',
                        style: GoogleFonts.quicksand(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF644633),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
