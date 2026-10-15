import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/nav_bar.dart';

class MyGame extends StatefulWidget {
  const MyGame({super.key, required this.datosPartida});

  @override
  State<MyGame> createState() => _MyGameState();

  final DatosPartida datosPartida;
}

class _MyGameState extends State<MyGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),

      body: Column(
        children: [
          // BARRA DE NAVEGACIÓN
          const NavBar(),

          // CONTENIDO
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 35),
              child: Column(
                children: [
                  Text(
                    'Mi espacio de juego',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF298133),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Consulta tus puntos y tu posición en EcoKids',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF644633),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // TARJETAS
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isSmallScreen = constraints.maxWidth < 950;

                      if (isSmallScreen) {
                        return Column(
                          children: [
                            _buildMyGameCard(),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildMyGameCard()),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MI PARTIDA
  Widget _buildMyGameCard() {
    return Container(
      constraints: const BoxConstraints(minHeight: 390),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD8EDD5), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ICONO
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFD8EDD5),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              size: 42,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Mi partida',
            style: GoogleFonts.quicksand(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Tu progreso en EcoKids',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF644633),
            ),
          ),

          const SizedBox(height: 30),

          // PUNTOS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FAEF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'PUNTOS',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF644633),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${widget.datosPartida.puntos}',
                  style: GoogleFonts.quicksand(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF298133),
                  ),
                ),

                Text(
                  'puntos conseguidos',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF644633),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // TIEMPO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FAEF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'TIEMPO',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF644633),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${widget.datosPartida.cronometro.elapsed.inSeconds}',
                  style: GoogleFonts.quicksand(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF298133),
                  ),
                ),

                Text(
                  'segundos',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF644633),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          //INTENTOS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FAEF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'INTENTOS',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF644633),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${widget.datosPartida.intentos}',
                  style: GoogleFonts.quicksand(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF298133),
                  ),
                ),

                Text(
                  'intentos',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF644633),
                  ),
                ),
              ],
            ),
          ),

  
        ],
      ),
    );
  }
}
