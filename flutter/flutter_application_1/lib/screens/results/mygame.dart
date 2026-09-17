import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

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
            // =========================
            // BARRA DE NAVEGACIÓN
            // =========================
            Container(
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

                  const SizedBox(width: 30),

                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 40),

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
