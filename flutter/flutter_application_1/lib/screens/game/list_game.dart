import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ListGame extends StatefulWidget {
  const ListGame({super.key});

  @override
  State<ListGame> createState() => _ListGameState();
}

class _ListGameState extends State<ListGame> {
  bool ratonReciclaje = false;
  bool ratonPuntoLimpio = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFfafdf4),

        child: Column(
          children: [
            // =====================================================
            // BARRA DE NAVEGACIÓN
            // =====================================================
            Container(
              width: double.infinity,
              height: 80,
              color: const Color(0xFF298133),

              child: Row(
                children: [
                  const SizedBox(width: 40),

                  // LOGO
                  Text(
                    'EcoKids',
                    style: GoogleFonts.quicksand(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  // INICIO
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

                  // JUEGOS
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

            // =====================================================
            // CONTENIDO
            // =====================================================
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 50,
                      top: 40,
                      right: 50,
                      bottom: 40,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =================================================
                        // TÍTULO
                        // =================================================
                        Text(
                          '¿A QUÉ CONTENEDOR TIRARÍAS...?',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.quicksand(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF298133),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // JUEGOS
                        Wrap(
                          spacing: 40,
                          runSpacing: 30,
                          children: [
                            // RECICLAJE
                            MouseRegion(
                              cursor: SystemMouseCursors.click,

                              onEnter: (_) {
                                setState(() {
                                  ratonReciclaje = true;
                                });
                              },

                              onExit: (_) {
                                setState(() {
                                  ratonReciclaje = false;
                                });
                              },

                              child: GestureDetector(
                                onTap: () {
                                  context.go('/first');
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),

                                  transform: Matrix4.translationValues(
                                    0,
                                    ratonReciclaje ? -10 : 0,
                                    0,
                                  ),

                                  width: 180,
                                  height: 220,

                                  decoration: BoxDecoration(
                                    color: const Color(0xFFd8edd5),

                                    border: Border.all(
                                      color: const Color(0xFF298133),
                                      width: 3,
                                    ),

                                    borderRadius: BorderRadius.circular(20),

                                    boxShadow: ratonReciclaje
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 12,
                                              offset: Offset(0, 6),
                                            ),
                                          ]
                                        : [],
                                  ),

                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15),

                                      // IMAGEN
                                      Image.asset(
                                        'assets/icons/app/reciclaje.png',
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.contain,
                                      ),

                                      const Spacer(),

                                      // NOMBRE
                                      Text(
                                        'RECICLAJE',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF298133),
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                            // PUNTO LIMPIO
                            MouseRegion(
                              cursor: SystemMouseCursors.click,

                              onEnter: (_) {
                                setState(() {
                                  ratonPuntoLimpio = true;
                                });
                              },

                              onExit: (_) {
                                setState(() {
                                  ratonPuntoLimpio = false;
                                });
                              },

                              child: GestureDetector(
                                onTap: () {
                                  context.go('/puntolimpio/firstlevel');
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),

                                  transform: Matrix4.translationValues(
                                    0,
                                    ratonPuntoLimpio ? -10 : 0,
                                    0,
                                  ),

                                  width: 180,
                                  height: 220,

                                  decoration: BoxDecoration(
                                    color: const Color(0xFFd8edd5),

                                    border: Border.all(
                                      color: const Color(0xFF298133),
                                      width: 3,
                                    ),

                                    borderRadius: BorderRadius.circular(20),

                                    boxShadow: ratonPuntoLimpio
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 12,
                                              offset: Offset(0, 6),
                                            ),
                                          ]
                                        : [],
                                  ),

                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15),

                                      // IMAGEN
                                      

                                      const Spacer(),

                                      // NOMBRE
                                      Text(
                                        'PUNTO LIMPIO',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF298133),
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}