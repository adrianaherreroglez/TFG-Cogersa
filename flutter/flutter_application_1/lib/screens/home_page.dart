import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Color de fondo de toda la pantalla
        color: const Color(0xFFfafdf4),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // Empuja el contenido hacia el centro
              const Spacer(),

              // TÍTULO
              Text( //no poner const con GoogleFonts
                'EcoKids',
                style: GoogleFonts.quicksand(
                  fontSize: 122,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF298133),
                ),
              ),

              const SizedBox(height: 10),

              // SUBTÍTULO
              Text(
                'Aprendiendo a reciclar',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(fontSize: 28, color: Color(0xFF298133)),
              ),

              // Empuja el botón hacia abajo
              const Spacer(),

              // BOTÓN
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/first');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF644633),
                    foregroundColor: Colors.white,
                    fixedSize: const Size(120, 45),
                  ),

                  child: const Text('Iniciar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
