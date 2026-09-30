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

  final ScrollController contenedoresScrollController =
      ScrollController();

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

  @override
  void dispose() {
    contenedoresScrollController.dispose();
    super.dispose();
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    if (respuestaCorrectaMostrada) {
      return;
    }

    intentos++;

    final contenedorCorrecto = objetoActual['contenedor'];

    if (contenedor == contenedorCorrecto) {
      puntos = puntos + primerNivel.sumarPuntosRespuestaCorrecta();


      setState(() {
        respuestasCorrectas[indiceObjetoActual] = contenedor;

        respuestaIncorrecta = null;
        respuestaCorrectaMostrada = true;
      });

      Future.delayed(
        const Duration(milliseconds: 1000),
        () {
          if (!mounted) return;

          final siguienteIndice = indiceObjetoActual + 1;

          if (siguienteIndice >= objetos.length) {
            context.go(
              '/fillGaps/second',
              extra: puntos,
            );
            return;
          }

          setState(() {
            indiceObjetoActual = siguienteIndice;
            intentos = 0;
            respuestaIncorrecta = null;
            respuestaCorrectaMostrada = false;
            puntosGanadosActuales = 0;
          });
        },
      );
    } else {
      setState(() {
        respuestaIncorrecta = contenedor;
        puntos = puntos - primerNivel.restarPuntosRespuestaIncorrecta();
        respuestaCorrectaMostrada = false;
      });
    }
  }

  Widget construirFrase(
    int indice,
    Map<String, String> objeto,
  ) {
    final bool completada =
        respuestasCorrectas.containsKey(indice);

    final bool esActual =
        indice == indiceObjetoActual && !completada;

    final bool estaBloqueada =
        indice > indiceObjetoActual;

    final String? contenedorSeleccionado =
        respuestasCorrectas[indice];

    final Color colorSeleccionado = completada
        ? gameService.colorContenedor(
            contenedorSeleccionado!,
          )
        : const Color(0xFFE0E0E0);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: estaBloqueada ? 0.65 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: esActual
              ? const Color(0xFFF4FAF1)
              : completada
                  ? const Color(0xFFF8FBF6)
                  : const Color(0xFFF5F6F3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: esActual
                ? themeGreen.withValues(alpha: 0.65)
                : completada
                    ? const Color(0xFFC5D8C1)
                    : const Color(0xFFE1E5DF),
            width: esActual ? 2 : 1.5,
          ),
          boxShadow: [
            if (esActual)
              BoxShadow(
                color: themeGreen.withValues(alpha: 0.10),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          children: [
            // IMAGEN DEL OBJETO
            Container(
              width: 76,
              height: 76,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: esActual
                    ? Colors.white
                    : completada
                        ? lightGreen
                        : const Color(0xFFEDEFEA),
                borderRadius: BorderRadius.circular(17),
                border: esActual
                    ? Border.all(
                        color:
                            themeGreen.withValues(alpha: 0.25),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Image.asset(
                objeto['imagen']!,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 17),

            // FRASE
            Expanded(
              child: Wrap(
                crossAxisAlignment:
                    WrapCrossAlignment.center,
                children: [
                  Text(
                    objeto['nombre']!,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: esActual || completada
                          ? themeGreen
                          : const Color(0xFF899389),
                    ),
                  ),

                  Text(
                    ' va en el contenedor ',
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: esActual || completada
                          ? const Color(0xFF4F5951)
                          : const Color(0xFF9BA39B),
                    ),
                  ),

                  // HUECO
                  AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 250),
                    width: 76,
                    height: 58,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: completada
                          ? colorSeleccionado.withValues(
                              alpha: 0.10,
                            )
                          : esActual
                              ? Colors.white
                              : const Color(0xFFEFF1EE),
                      borderRadius:
                          BorderRadius.circular(14),
                      border: Border.all(
                        color: completada
                            ? colorSeleccionado
                            : esActual
                                ? themeGreen.withValues(
                                    alpha: 0.55,
                                  )
                                : const Color(0xFFD0D5D0),
                        width: esActual ? 2 : 1.5,
                      ),
                    ),
                    child: completada
                        ? Padding(
                            padding:
                                const EdgeInsets.all(5),
                            child: Image.asset(
                              gameService.imagenContenedor(
                                contenedorSeleccionado!,
                              ),
                              fit: BoxFit.contain,
                            ),
                          )
                        : Center(
                            child: Text(
                              '?',
                              style:
                                  GoogleFonts.quicksand(
                                fontSize: esActual
                                    ? 27
                                    : 23,
                                fontWeight:
                                    FontWeight.w800,
                                color: esActual
                                    ? themeGreen
                                    : const Color(
                                        0xFF9AA39A,
                                      ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ESTADO
            AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 250),
              child: completada
                  ? Container(
                      key: const ValueKey('correcto'),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: lightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: themeGreen,
                        size: 21,
                      ),
                    )
                  : esActual
                      ? Container(
                          key: const ValueKey('actual'),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: themeGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                        )
                      : Container(
                          key: const ValueKey('pendiente'),
                          width: 32,
                          height: 32,
                          decoration:
                              const BoxDecoration(
                            color: Color(0xFFE8EBE7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFF9AA39A),
                            size: 17,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirContenedor(String contenedor) {
    final bool esRespuestaIncorrecta =
        respuestaIncorrecta == contenedor;

    final Color color =
        gameService.colorContenedor(contenedor);

    return GestureDetector(
      onTap: () {
        if (!respuestaCorrectaMostrada) {
          comprobarRespuesta(contenedor);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 175,
        height: 175,
        decoration: BoxDecoration(
          color: esRespuestaIncorrecta
              ? const Color(0xFFFFEBEE)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: esRespuestaIncorrecta
                ? const Color(0xFFE53935)
                : color.withValues(alpha: 0.40),
            width: 2,
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
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Image.asset(
                  gameService.imagenContenedor(
                    contenedor,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              gameService
                  .nombreContenedor(contenedor)
                  .toUpperCase(),
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: esRespuestaIncorrecta
                    ? const Color(0xFFE53935)
                    : const Color(0xFF5D7A61),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirIndicadorProgreso() {
    final int total = objetos.length;
    final int completados = respuestasCorrectas.length;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Progreso',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: secondaryText,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$completados/$total',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: themeGreen,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        SizedBox(
          width: 150,
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: total == 0
                  ? 0
                  : completados / total,
              minHeight: 7,
              backgroundColor:
                  const Color(0xFFDDE8DA),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                themeGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8F6),
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  45,
                  25,
                  45,
                  30,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // COLUMNA IZQUIERDA (frases)
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 17,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFF0F5EE,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.flag_rounded,
                                      color: themeGreen,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      'NIVEL 1',
                                      style:
                                          GoogleFonts.quicksand(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: themeGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFE2E7E0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color:
                                          Color(0xFFFFB300),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$puntos puntos',
                                      style:
                                          GoogleFonts.quicksand(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w800,
                                        color:
                                            secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Text(
                            '¡RELLENA LOS HUECOS!',
                            style: GoogleFonts.quicksand(
                              fontSize: 31,
                              fontWeight: FontWeight.w800,
                              color: themeGreen,
                              height: 1,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Completa cada frase eligiendo el contenedor correcto',
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w500,
                              color: secondaryText,
                            ),
                          ),

                          const SizedBox(height: 13),

                          construirIndicadorProgreso(),

                          const SizedBox(height: 20),

                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: objetos.length,
                              itemBuilder:
                                  (context, index) {
                                return construirFrase(
                                  index,
                                  objetos[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SEPARACIÓN CENTRAL
                    const SizedBox(width: 55),

                    Container(
                      width: 1,
                      margin:
                          const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      color:
                          const Color(0xFFE2E7E0),
                    ),

                    const SizedBox(width: 40),


                    // COLUMNA DERECHA (contenedores)
                    SizedBox(
                      width: 210,
                      child: Scrollbar(
                        controller:
                            contenedoresScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        radius:
                            const Radius.circular(10),
                        child: SingleChildScrollView(
                          controller:
                              contenedoresScrollController,
                          padding:
                              const EdgeInsets.only(
                            right: 10,
                            bottom: 15,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFF0F5EE,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),
                                child: Text(
                                  'CONTENEDORES',
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w800,
                                    color: secondaryText,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 22),

                              construirContenedor(
                                'amarillo',
                              ),

                              const SizedBox(height: 18),

                              construirContenedor(
                                'azul',
                              ),

                              const SizedBox(height: 18),

                              construirContenedor(
                                'verde',
                              ),

                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
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