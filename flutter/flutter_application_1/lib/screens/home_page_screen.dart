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
    final themeGreen = const Color(0xFF298133);
    final lightGreen = const Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                // Icono
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.eco_rounded,
                    size: 75,
                    color: themeGreen,
                  ),
                ),

                const SizedBox(height: 28),

                // TÍTULO
                Text(
                  'EcoKids',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    color: themeGreen,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 12),

                // SUBTÍTULO
                Text(
                  'Aprendiendo a reciclar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: themeGreen,
                  ),
                ),

                const SizedBox(height: 8),

                // DESCRIPCIÓN
                Text(
                  '¡Cuidar el planeta puede ser divertido!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 40),

                // BOTÓN
                SizedBox(
                  width: 140,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/login');
                    },

                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    child: Text(
                      '¡Empezar!',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

