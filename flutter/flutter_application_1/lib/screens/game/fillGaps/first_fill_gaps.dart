import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/nav_bar.dart';

class FirstFillPage extends StatefulWidget {
  const FirstFillPage({super.key});

  @override
  State<FirstFillPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstFillPage> {
  final List<Map<String, String>> objetos = [
    {
      'nombre': 'La botella de plástico',
      'imagen': 'assets/icons/objetos/amarillo/botella-de-plastico.png',
      'contenedor': 'amarillo',
    },
    {
      'nombre': 'El avión de papel',
      'imagen': 'assets/icons/objetos/azul/avion-de-papel.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'La botella de vidrio',
      'imagen': 'assets/icons/objetos/verde/botella-de-vidrio.png',
      'contenedor': 'verde',
    },
    {
      'nombre': 'El papel de regalo',
      'imagen': 'assets/icons/objetos/azul/papel-de-regalo.png',
      'contenedor': 'azul',
    },
  ];

  late List<Map<String, String>> objetosMezclados;

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

    objetosMezclados = List.from(objetos);
    objetosMezclados.shuffle(Random());
  }

  Map<String, String> get objetoActual {
    return objetosMezclados[indiceObjetoActual];
  }

  String imagenContenedor(String contenedor) {
    switch (contenedor) {
      case 'amarillo':
        return 'assets/icons/contenedores/basura-amarilla.png';
      case 'azul':
        return 'assets/icons/contenedores/basura-azul.png';
      case 'verde':
        return 'assets/icons/contenedores/basura-verde.png';
      default:
        return '';
    }
  }

  String nombreContenedor(String contenedor) {
    switch (contenedor) {
      case 'amarillo':
        return 'amarillo';
      case 'azul':
        return 'azul';
      case 'verde':
        return 'verde';
      default:
        return contenedor;
    }
  }

  Color colorContenedor(String contenedor) {
    switch (contenedor) {
      case 'amarillo':
        return const Color(0xFFFFD740);
      case 'azul':
        return const Color(0xFF42A5F5);
      case 'verde':
        return const Color(0xFF66BB6A);
      default:
        return themeGreen;
    }
  }

  void comprobarRespuesta(String contenedor) {
    intentos++;

    final contenedorCorrecto = objetoActual['contenedor'];

    if (contenedor == contenedorCorrecto) {
      int puntosGanados;

      if (intentos == 1) {
        puntosGanados = 30;
      } else if (intentos == 2) {
        puntosGanados = 20;
      } else {
        puntosGanados = 10;
      }

      setState(() {
        puntos += puntosGanados;
        puntosGanadosActuales = puntosGanados;
        respuestasCorrectas[indiceObjetoActual] = contenedor;

        // Quitamos cualquier error anterior.
        respuestaIncorrecta = null;

        respuestaCorrectaMostrada = true;
      });

      Future.delayed(
        const Duration(milliseconds: 1000),
        () {
          if (!mounted) return;

          final siguienteIndice = indiceObjetoActual + 1;

          if (siguienteIndice >= objetosMezclados.length) {
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
        // Solo guardamos qué contenedor se ha pulsado mal.
        // Ese contenedor se pondrá rojo.
        respuestaIncorrecta = contenedor;

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

    final String? contenedorSeleccionado =
        respuestasCorrectas[indice];

    final Color colorSeleccionado = completada
        ? colorContenedor(contenedorSeleccionado!)
        : const Color(0xFFE0E0E0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: completada
            ? const Color(0xFFF1F9EF)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: completada
              ? themeGreen
              : const Color(0xFFDDE6DC),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              objeto['imagen']!,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  objeto['nombre']!,
                  style: GoogleFonts.quicksand(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: themeGreen,
                  ),
                ),

                Text(
                  ' va en el contenedor ',
                  style: GoogleFonts.quicksand(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 76,
                  height: 58,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: completada
                        ? colorSeleccionado.withValues(
                            alpha: 0.14,
                          )
                        : const Color(0xFFF5F7F4),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: completada
                          ? colorSeleccionado
                          : const Color(0xFFB8C2B8),
                      width: 2,
                    ),
                  ),
                  child: completada
                      ? Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            imagenContenedor(
                              contenedorSeleccionado!,
                            ),
                            fit: BoxFit.contain,
                          ),
                        )
                      : Center(
                          child: Text(
                            '?',
                            style: GoogleFonts.quicksand(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF8A978A),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
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
                      size: 22,
                    ),
                  )
                : Container(
                    key: const ValueKey('pendiente'),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.question_mark_rounded,
                      color: secondaryText,
                      size: 18,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget construirContenedor(String contenedor) {
    final bool esRespuestaIncorrecta =
        respuestaIncorrecta == contenedor;

    final Color color = colorContenedor(contenedor);

    return GestureDetector(
      onTap: () {
        if (!respuestaCorrectaMostrada) {
          comprobarRespuesta(contenedor);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 155,
        height: 155,
        decoration: BoxDecoration(
          color: esRespuestaIncorrecta
              ? const Color(0xFFFFEBEE)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: esRespuestaIncorrecta
                ? const Color(0xFFE53935)
                : color.withValues(alpha: 0.55),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: esRespuestaIncorrecta
                  ? Colors.red.withValues(alpha: 0.15)
                  : color.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
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
                color: esRespuestaIncorrecta
                    ? const Color(0xFFFFCDD2)
                    : color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  imagenContenedor(contenedor),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              nombreContenedor(contenedor).toUpperCase(),
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: esRespuestaIncorrecta
                    ? const Color(0xFFE53935)
                    : themeGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirIndicadorProgreso() {
    final int total = objetosMezclados.length;
    final int completados = respuestasCorrectas.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: total == 0
                  ? 0
                  : completados / total,
              minHeight: 7,
              backgroundColor: const Color(0xFFDDE8DA),
              valueColor:
                  AlwaysStoppedAnimation<Color>(themeGreen),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  40,
                  20,
                  40,
                  25,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // COLUMNA IZQUIERDA
                    Expanded(
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
                                  color: secondaryGreen,
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.flag_rounded,
                                      color: themeGreen,
                                      size: 21,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      'NIVEL 1',
                                      style:
                                          GoogleFonts.quicksand(
                                        fontSize: 16,
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
                                      BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.06),
                                      blurRadius: 8,
                                      offset:
                                          const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Color(0xFFFFB300),
                                      size: 23,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$puntos puntos',
                                      style:
                                          GoogleFonts.quicksand(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Text(
                            '¡RELLENA LOS HUECOS!',
                            style: GoogleFonts.quicksand(
                              fontSize: 31,
                              fontWeight: FontWeight.w800,
                              color: themeGreen,
                              height: 1,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            'Completa cada frase eligiendo el contenedor correcto',
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: secondaryText,
                            ),
                          ),

                          const SizedBox(height: 12),

                          construirIndicadorProgreso(),

                          const SizedBox(height: 15),

                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: objetosMezclados.length,
                              itemBuilder: (context, index) {
                                return construirFrase(
                                  index,
                                  objetosMezclados[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 40),

                    // COLUMNA DERECHA
                    SizedBox(
                      width: 190,
                      child: Scrollbar(
                        thumbVisibility: true,
                        radius: const Radius.circular(10),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            right: 8,
                            bottom: 10,
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
                                  color: lightGreen,
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                                child: Text(
                                  'CONTENEDORES',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: themeGreen,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              construirContenedor('amarillo'),

                              const SizedBox(height: 12),

                              construirContenedor('azul'),

                              const SizedBox(height: 12),

                              construirContenedor('verde'),

                              const SizedBox(height: 10),
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