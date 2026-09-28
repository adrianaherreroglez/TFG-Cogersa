import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ListGame extends StatefulWidget {
  const ListGame({super.key});

  @override
  State<ListGame> createState() => _ListGameState();
}

class _ListGameState extends State<ListGame> {
  bool ratonReciclajeDrag = false;
  bool ratonReciclajeFill = false;
  bool ratonPuntoLimpioDrag = false;
  bool ratonPuntoLimpioFill = false;

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
                            // RECICLAJE vDrag & Drop
                            MouseRegion(
                              cursor: SystemMouseCursors.click,

                              onEnter: (_) {
                                setState(() {
                                  ratonReciclajeDrag = true;
                                });
                              },

                              onExit: (_) {
                                setState(() {
                                  ratonReciclajeDrag = false;
                                });
                              },

                              child: GestureDetector(
                                onTap: () {
                                  context.go('/first');
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),

                                  transform: Matrix4.translationValues(
                                    0,
                                    ratonReciclajeDrag ? -10 : 0,
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

                                    boxShadow: ratonReciclajeDrag
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

                                      // const Spacer()

                                      const SizedBox(height: 20),

                                      Text(
                                        'Drag & Drop',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF298133),
                                        ),
                                      ),


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

                            

                            // RECICLAJE vFill in the Gaps
                            MouseRegion(
                              cursor: SystemMouseCursors.click,

                              onEnter: (_) {
                                setState(() {
                                  ratonReciclajeFill = true;
                                });
                              },

                              onExit: (_) {
                                setState(() {
                                  ratonReciclajeFill = false;
                                });
                              },

                              child: GestureDetector(
                                onTap: () {
                                  context.go('/fillGaps/first');
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),

                                  transform: Matrix4.translationValues(
                                    0,
                                    ratonReciclajeFill ? -10 : 0,
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

                                    boxShadow: ratonReciclajeFill
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

                                      // const Spacer()

                                      const SizedBox(height: 20),

                                      Text(
                                        'Fill in the Gaps',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF298133),
                                        ),
                                      ),


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


                            // PUNTO LIMPIO vDrag and Drop
                            MouseRegion(
                              cursor: SystemMouseCursors.click,

                              onEnter: (_) {
                                setState(() {
                                  ratonPuntoLimpioDrag = true;
                                });
                              },

                              onExit: (_) {
                                setState(() {
                                  ratonPuntoLimpioDrag = false;
                                });
                              },

                              child: GestureDetector(
                                onTap: () {
                                  context.go('/puntolimpio/firstlevel');
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),

                                  transform: Matrix4.translationValues(
                                    0,
                                    ratonPuntoLimpioDrag ? -10 : 0,
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

                                    boxShadow: ratonPuntoLimpioDrag
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
                                        'assets/icons/app/punto-limpio.png',
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.contain,
                                      ),

                                     // const Spacer(),

                                     const SizedBox(height: 20),

                                      Text(
                                        'Drag & Drop',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF298133),
                                        ),
                                      ),

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


                            // PUNTO LIMPIO vFill in the Gaps
                            MouseRegion(
                              cursor: SystemMouseCursors.click,

                              onEnter: (_) {
                                setState(() {
                                  ratonPuntoLimpioFill = true;
                                });
                              },

                              onExit: (_) {
                                setState(() {
                                  ratonPuntoLimpioFill = false;
                                });
                              },

                              child: GestureDetector(
                                onTap: () {
                                  context.go('/puntolimpio/firstlevel');
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),

                                  transform: Matrix4.translationValues(
                                    0,
                                    ratonPuntoLimpioFill ? -10 : 0,
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

                                    boxShadow: ratonPuntoLimpioFill
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
                                        'assets/icons/app/punto-limpio.png',
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.contain,
                                      ),

                                     // const Spacer(),

                                     const SizedBox(height: 20),

                                      Text(
                                        'Fill in the Gaps',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF298133),
                                        ),
                                      ),

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
