import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../service/PrimerNivel.dart';
import '../service/game_service.dart';
import '../../../widgets/nav_bar.dart';

class FirstFillPage extends StatefulWidget {
  const FirstFillPage({super.key});

  @override
  State<FirstFillPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstFillPage> {
  final GameService gameService = GameService();
  final PrimerNivel primerNivel = PrimerNivel();

  late List<Map<String, String>> objetos;

  int indiceObjetoActual = 0;
  int puntos = 0;
  int intentos = 0;

  final Map<int, String> respuestasCorrectas = {};

  String? respuestaIncorrecta;
  bool respuestaCorrectaMostrada = false;
  int puntosGanadosActuales = 0;

  final Color themeGreen = const Color(0xFF298133);
  final Color lightGreen = const Color(0xFFE8F5E9);
  final Color secondaryGreen = const Color(0xFFD8EDD5);
  final Color secondaryText = const Color(0xFF5D7A61);

  @override
  void initState() {
    super.initState();

    objetos = gameService.getObjetosPrimerNivel();
    objetos.shuffle(Random());
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    if (respuestaCorrectaMostrada) {
      return;
    }

    intentos++;

    final String contenedorCorrecto = objetoActual['contenedor']!;

    if (contenedor == contenedorCorrecto) {
      final int puntosRespuesta = primerNivel.sumarPuntosRespuestaCorrecta();

      puntos += puntosRespuesta;

      setState(() {
        respuestasCorrectas[indiceObjetoActual] = contenedor;
        respuestaIncorrecta = null;
        respuestaCorrectaMostrada = true;
        puntosGanadosActuales = puntosRespuesta;
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;

        final int siguienteIndice = indiceObjetoActual + 1;

        if (siguienteIndice >= objetos.length) {
          context.go('/fillGaps/second', extra: puntos);
          return;
        }

        setState(() {
          indiceObjetoActual = siguienteIndice;
          intentos = 0;
          respuestaIncorrecta = null;
          respuestaCorrectaMostrada = false;
          puntosGanadosActuales = 0;
        });
      });
    } else {
      setState(() {
        respuestaIncorrecta = contenedor;
        puntos -= primerNivel.restarPuntosRespuestaIncorrecta();
        respuestaCorrectaMostrada = false;
        puntosGanadosActuales = 0;
      });
    }
  }

  // ============================================================
  // TARJETA DEL OBJETO Y FRASE ACTUAL
  // ============================================================

  Widget construirTarjetaFrase() {
    final String nombre = objetoActual['nombre']!;
    final String contenedorCorrecto = objetoActual['contenedor']!;

    final bool completada = respuestaCorrectaMostrada;

    final Color colorContenedor = gameService.colorContenedor(
      contenedorCorrecto,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(indiceObjetoActual),
        width: double.infinity,
        height: 190,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: completada
                ? colorContenedor.withValues(alpha: 0.55)
                : themeGreen.withValues(alpha: 0.20),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // ========================================================
            // IMAGEN DEL OBJETO
            // ========================================================

            Container(
              width: 125,
              height: 125,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeGreen.withValues(alpha: 0.12)),
              ),
              child: Image.asset(objetoActual['imagen']!, fit: BoxFit.contain),
            ),

            const SizedBox(width: 28),

            // ========================================================
            // FRASE
            // ========================================================
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿DÓNDE VA?',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: secondaryText,
                      letterSpacing: 0.6,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        nombre,
                        style: GoogleFonts.quicksand(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: themeGreen,
                        ),
                      ),

                      Text(
                        ' va en el contenedor ',
                        style: GoogleFonts.quicksand(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4F5951),
                        ),
                      ),

                      // ==================================================
                      // HUECO
                      // ==================================================
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 85,
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: completada
                              ? colorContenedor.withValues(alpha: 0.10)
                              : const Color(0xFFF8FAF7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: completada
                                ? colorContenedor
                                : themeGreen.withValues(alpha: 0.55),
                            width: 2,
                          ),
                        ),
                        child: completada
                            ? Padding(
                                padding: const EdgeInsets.all(5),
                                child: Image.asset(
                                  gameService.imagenContenedor(
                                    contenedorCorrecto,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Center(
                                child: Text(
                                  '...',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: themeGreen,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ==================================================
                  // MENSAJE DE ESTADO
                  // ==================================================
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: respuestaIncorrecta != null
                        ? Row(
                            key: const ValueKey('error'),
                            children: [
                              const Icon(
                                Icons.close_rounded,
                                color: Color(0xFFE53935),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Ese no es el contenedor correcto',
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFE53935),
                                ),
                              ),
                            ],
                          )
                        : completada
                        ? Row(
                            key: const ValueKey('correcto'),
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Color(0xFF298133),
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                '+$puntosGanadosActuales puntos',
                                style: GoogleFonts.quicksand(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: themeGreen,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Selecciona el contenedor correcto',
                            key: const ValueKey('ayuda'),
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: secondaryText,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONTENEDOR
  // ============================================================

  Widget construirContenedor(String contenedor) {
    final bool esRespuestaIncorrecta = respuestaIncorrecta == contenedor;

    final bool esRespuestaCorrecta =
        respuestaCorrectaMostrada && objetoActual['contenedor'] == contenedor;

    final Color color = gameService.colorContenedor(contenedor);

    return GestureDetector(
      onTap: () {
        if (!respuestaCorrectaMostrada) {
          comprobarRespuesta(contenedor);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 190,
        height: 165,
        decoration: BoxDecoration(
          color: esRespuestaIncorrecta
              ? const Color(0xFFFFEBEE)
              : esRespuestaCorrecta
              ? color.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: esRespuestaIncorrecta
                ? const Color(0xFFE53935)
                : esRespuestaCorrecta
                ? color
                : color.withValues(alpha: 0.40),
            width: esRespuestaCorrecta ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: esRespuestaIncorrecta
                  ? Colors.red.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.045),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  gameService.imagenContenedor(contenedor),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              gameService.nombreContenedor(contenedor).toUpperCase(),
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: esRespuestaIncorrecta
                    ? const Color(0xFFE53935)
                    : esRespuestaCorrecta
                    ? color
                    : secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // PROGRESO

  // Widget construirIndicadorProgreso() {
  //   final int total = objetos.length;
  //   final int completados = respuestasCorrectas.length;

  //   return Row(
  //     children: [
  //       Text(
  //         'Progreso',
  //         style: GoogleFonts.quicksand(
  //           fontSize: 14,
  //           fontWeight: FontWeight.bold,
  //           color: secondaryText,
  //         ),
  //       ),

  //       const SizedBox(width: 8),

  //       Text(
  //         '$completados/$total',
  //         style: GoogleFonts.quicksand(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w800,
  //           color: themeGreen,
  //         ),
  //       ),

  //       const SizedBox(width: 12),

  //       SizedBox(
  //         width: 170,
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(10),
  //           child: LinearProgressIndicator(
  //             value: total == 0 ? 0 : completados / total,
  //             minHeight: 7,
  //             backgroundColor: const Color(0xFFDDE8DA),
  //             valueColor: AlwaysStoppedAnimation<Color>(themeGreen),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(55, 25, 55, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CABECERA
                    SizedBox(
                      height: 72,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // NIVEL 1 A LA IZQUIERDA
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F5EE),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.flag_rounded,
                                    color: themeGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'NIVEL 1',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: themeGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          // TÍTULO + SUBTÍTULO 
                          
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '¡RELLENA LOS HUECOS!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontSize: 29,
                                  fontWeight: FontWeight.w800,
                                  color: themeGreen,
                                  height: 1,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                'Completa cada frase eligiendo el contenedor correcto',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),

 
                          // PUNTOS 
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE2E7E0),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFB300),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$puntos puntos',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // PROGRESO
                    //Center(child: construirIndicadorProgreso()),

                    const SizedBox(height: 20),

  
                    Expanded(
                      child: Column(
                        children: [
                          // TARJETA DEL OBJETO
                          construirTarjetaFrase(),

                          const SizedBox(height: 24),

          
                          // CONTENEDORES
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    construirContenedor('amarillo'),

                                    const SizedBox(width: 25),

                                    construirContenedor('azul'),

                                    const SizedBox(width: 25),

                                    construirContenedor('verde'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
