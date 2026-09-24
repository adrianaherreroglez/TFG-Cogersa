import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/nav_bar.dart';

class ThirdFillPage extends StatefulWidget {
  const ThirdFillPage({super.key});

  @override
  State<ThirdFillPage> createState() => _ThirdFillPageState();
}

class _ThirdFillPageState extends State<ThirdFillPage> {
   // Lista de objetos del Tercer Nivel
  final List<Map<String, String>> objetos = [
    {
      'nombre': 'toallitas',
      'imagen': 'assets/icons/objetos/gris/toallitas.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'ceramica',
      'imagen': 'assets/icons/objetos/gris/ceramica.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'tirita',
      'imagen': 'assets/icons/objetos/gris/tirita.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'periodico',
      'imagen': 'assets/icons/objetos/azul/periodico.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'leche',
      'imagen': 'assets/icons/objetos/amarillo/leche.png',
      'contenedor': 'amarillo',
    },
    {
      'nombre': 'perfume',
      'imagen': 'assets/icons/objetos/verde/perfume.png',
      'contenedor': 'verde',
    },
    {
      'nombre': 'manzana',
      'imagen': 'assets/icons/objetos/marron/manzana.png',
      'contenedor': 'marron',
    },
  ];

  late List<Map<String, String>> objetosMezclados;

  int indiceObjetoActual = 0;
  int puntos = 0;
  int intentos = 0;

  final Map<int, String> respuestasCorrectas = {};

  String? respuestaIncorrecta;

  final ScrollController scrollIzquierda = ScrollController();
  final ScrollController scrollDerecha = ScrollController();

  @override
  void initState() {
    super.initState();

    objetosMezclados = List.from(objetos);
    objetosMezclados.shuffle(Random());
  }

  @override
  void dispose() {
    scrollIzquierda.dispose();
    scrollDerecha.dispose();

    super.dispose();
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

      case 'marron':
        return 'assets/icons/contenedores/basura-marron.png';

      case 'gris':
        return 'assets/icons/contenedores/basura-gris.png';

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

      case 'marron':
        return 'marron';

      case 'gris':
        return 'gris';

      default:
        return contenedor;
    }
  }

 // COMPROBAR RESPUESTA
  void comprobarRespuesta(String contenedor) {
    intentos++;

    final contenedorCorrecto = objetoActual['contenedor'];

    if (contenedor == contenedorCorrecto) {
      int puntosGanados = 0;

      if (intentos == 1) {
        puntosGanados = 50;
      } else if (intentos == 2) {
        puntosGanados = 40;
      } else if (intentos == 3) {
        puntosGanados = 30;
      } else if (intentos == 4) {
        puntosGanados = 20;
      } else if (intentos == 5) {
        puntosGanados = 10;
      }

      setState(() {
        puntos += puntosGanados;

        respuestasCorrectas[indiceObjetoActual] =
            contenedor;

        respuestaIncorrecta = null;
      });

      Future.delayed(
        const Duration(milliseconds: 900),
        () {
          if (!mounted) return;

          final siguienteIndice =
              indiceObjetoActual + 1;

          if (siguienteIndice >=
              objetosMezclados.length) {
            context.go(
              '/mygame',
              extra: puntos,
            );

            return;
          }

          setState(() {
            indiceObjetoActual =
                siguienteIndice;

            intentos = 0;

            respuestaIncorrecta = null;
          });
        },
      );
    } else {
      setState(() {
        respuestaIncorrecta = contenedor;
      });
    }
  }

  // FRASE
  Widget construirFrase(
    int indice,
    Map<String, String> objeto,
  ) {
    final bool completada =
        respuestasCorrectas.containsKey(indice);

    final String? contenedorSeleccionado =
        respuestasCorrectas[indice];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: completada
              ? const Color(0xFF298133)
              : const Color(0xFFE0E0E0),

          width: 2,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.06),

            blurRadius: 7,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // IMAGEN DEL OBJETO
          Image.asset(
            objeto['imagen']!,
            width: 60,
            height: 60,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Wrap(
              crossAxisAlignment:
                  WrapCrossAlignment.center,

              children: [
                Text(
                  '',
                  style:
                      GoogleFonts.quicksand(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                Text(
                  objeto['nombre']!,
                  style:
                      GoogleFonts.quicksand(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        const Color(0xFF298133),
                  ),
                ),

                Text(
                  ' va en el contenedor ',
                  style:
                      GoogleFonts.quicksand(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                // HUECO
                Container(
                  width: 125,
                  height: 60,

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),

                  decoration:
                      BoxDecoration(
                    color: completada
                        ? const Color(
                            0xFFE8F5E9,
                          )
                        : const Color(
                            0xFFF5F5F5,
                          ),

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),

                    border: Border.all(
                      color: completada
                          ? const Color(
                              0xFF298133,
                            )
                          : const Color(
                              0xFFBDBDBD,
                            ),

                      width: 2,
                    ),
                  ),

                  child: completada
                      ? Image.asset(
                          imagenContenedor(
                            contenedorSeleccionado!,
                          ),

                          width: 50,
                          height: 50,
                        )
                      : Center(
                          child: Text(
                            '______',

                            style:
                                GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget construirContenedor(
    String contenedor,
  ) {
    final bool esRespuestaIncorrecta =
        respuestaIncorrecta == contenedor;

    return GestureDetector(
      onTap: () {
        comprobarRespuesta(
          contenedor,
        );
      },

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),

        width: 150,
        height: 150,

        decoration:
            BoxDecoration(
          color: esRespuestaIncorrecta
              ? const Color(0xFFFFEBEE)
              : Colors.white,

          borderRadius:
              BorderRadius.circular(20),

          border: Border.all(
            color: esRespuestaIncorrecta
                ? Colors.red
                : const Color(0xFFE0E0E0),

            width: 2,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.08,
              ),

              blurRadius: 7,

              offset:
                  const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Image.asset(
              imagenContenedor(
                contenedor,
              ),

              width: 80,
              height: 80,
            ),

            const SizedBox(height: 4),

            Text(
              nombreContenedor(
                contenedor,
              ).toUpperCase(),

              style:
                  GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
                color:
                    const Color(0xFF298133),
              ),
            ),
          ],
        ),
      ),
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
                padding:
                    const EdgeInsets.fromLTRB(
                  30,
                  20,
                  30,
                  25,
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                  children: [
                    // COLUMNA IZQUIERDA
                    Expanded(
                      flex: 7,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            'RELLENA LOS HUECOS',

                            style:
                                GoogleFonts.quicksand(
                              fontSize: 30,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  const Color(
                                0xFF298133,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            'Nivel 1',

                            style:
                                GoogleFonts.quicksand(
                              fontSize: 23,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Colors.black87,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            'Puntos: $puntos',

                            style:
                                GoogleFonts.quicksand(
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  Colors.black54,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // SCROLL DE LAS FRASES
                          Expanded(
                            child: Scrollbar(
                              controller:
                                  scrollIzquierda,

                              thumbVisibility:
                                  true,

                              child:
                                  SingleChildScrollView(
                                controller:
                                    scrollIzquierda,

                                padding:
                                    const EdgeInsets
                                        .only(
                                  right: 15,
                                  bottom: 20,
                                ),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .stretch,

                                  children:
                                      List.generate(
                                    objetosMezclados
                                        .length,

                                    (index) {
                                      return construirFrase(
                                        index,
                                        objetosMezclados[
                                            index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      width: 35,
                    ),

                    // COLUMNA DERECHA
                    SizedBox(
                      width: 190,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center,

                        children: [
                          Text(
                            'CONTENEDORES',

                            textAlign:
                                TextAlign.center,

                            style:
                                GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  const Color(
                                0xFF298133,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 28,
                          ),

                          // SCROLL DE LOS CONTENEDORES
                          Expanded(
                            child: Scrollbar(
                              controller:
                                  scrollDerecha,

                              thumbVisibility:
                                  true,

                              child:
                                  SingleChildScrollView(
                                controller:
                                    scrollDerecha,

                                padding:
                                    const EdgeInsets
                                        .only(
                                  left: 4,
                                  right: 8,
                                  bottom: 20,
                                ),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,

                                  children: [
                                    construirContenedor(
                                      'amarillo',
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    construirContenedor(
                                      'azul',
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    construirContenedor(
                                      'verde',
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    construirContenedor(
                                      'marron',
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    construirContenedor(
                                      'gris',
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    // MENSAJE DE ERROR
                                    if (respuestaIncorrecta !=
                                        null)
                                      Text(
                                        '¡Prueba otra vez!',

                                        textAlign:
                                            TextAlign
                                                .center,

                                        style:
                                            GoogleFonts
                                                .quicksand(
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Colors.red,
                                        ),
                                      ),
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