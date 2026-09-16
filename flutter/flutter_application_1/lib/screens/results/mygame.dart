
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGame extends StatefulWidget {
  const MyGame({super.key});

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Color de fondo de toda la pantalla
        color: const Color(0xFFfafdf4),

        child: Row(
            children: [
              // Empuja el contenido hacia el centro
              //const Spacer(),

              // TÍTULO
              Text( //no poner const con GoogleFonts
                'Clasificación',
                style: GoogleFonts.quicksand(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF298133),
                ),
              ),

              const SizedBox(width: 520),

              Text( //no poner const con GoogleFonts
                'Mi Partida',
                style: GoogleFonts.quicksand(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF298133),
                ),
              ),

            ],
          ),

          
          
        ),
    );
  }
}

