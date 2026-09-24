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
        respuestasCorrectas[indiceObjetoActual] = contenedor;
        respuestaIncorrecta = null;
      });

      Future.delayed(
        const Duration(milliseconds: 900),
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
          });
        },
      );
    } else {
      setState(() {
        respuestaIncorrecta = contenedor;
      });
    }
  }

  Widget construirFrase(
    int indice,
    Map<String, String> objeto,
  ) {
    final bool completada = respuestasCorrectas.containsKey(indice);

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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: completada
              ? const Color(0xFF298133)
              : const Color(0xFFE0E0E0),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            objeto['imagen']!,
            width: 60,
            height: 60,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '',
                  style: GoogleFonts.quicksand(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                Text(
                  objeto['nombre']!,
                  style: GoogleFonts.quicksand(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF298133),
                  ),
                ),

                Text(
                  ' va en el contenedor ',
                  style: GoogleFonts.quicksand(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                Container(
                  width: 125,
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: completada
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: completada
                          ? const Color(0xFF298133)
                          : const Color(0xFFBDBDBD),
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
                            style: GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
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

  Widget construirContenedor(String contenedor) {
    final bool esRespuestaIncorrecta =
        respuestaIncorrecta == contenedor;

    return GestureDetector(
      onTap: () {
        comprobarRespuesta(contenedor);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        width: 150,
        height: 150,

        decoration: BoxDecoration(
          color: esRespuestaIncorrecta
              ? const Color(0xFFFFEBEE)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: esRespuestaIncorrecta
                ? Colors.red
                : const Color(0xFFE0E0E0),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagenContenedor(contenedor),
              width: 80,
              height: 80,
            ),

            const SizedBox(height: 4),

            Text(
              nombreContenedor(contenedor).toUpperCase(),
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF298133),
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
      backgroundColor: const Color(0xFFF7F8F6),

      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  30,
                  20,
                  30,
                  25,
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            style: GoogleFonts.quicksand(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF298133),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Nivel 1',
                            style: GoogleFonts.quicksand(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Puntos: $puntos',
                            style: GoogleFonts.quicksand(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),


                          const SizedBox(height: 20),

                          // Frases
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount:
                                  objetosMezclados.length,
                              itemBuilder:
                                  (context, index) {
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

                    const SizedBox(width: 35),

                    // COLUMNA DERECHA CON TÍTULO E ICONOS DE LOS CONTENEDORES
                    SizedBox(
                      width: 190,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center,
                        children: [
                          // Título de la columna derecha
                          Text(
                            'CONTENEDORES',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF298133),
                            ),
                          ),

                          // Espacio para los contenedores
                          const SizedBox(height: 28),

                          // Amarillo
                          Expanded(
                            child: Center(
                              child: construirContenedor(
                                'amarillo',
                              ),
                            ),
                          ),

                          // Azul
                          Expanded(
                            child: Center(
                              child: construirContenedor(
                                'azul',
                              ),
                            ),
                          ),

                          // Verde
                          Expanded(
                            child: Center(
                              child: construirContenedor(
                                'verde',
                              ),
                            ),
                          ),

                          // Mensaje de error
                          SizedBox(
                            height: 30,
                            child: respuestaIncorrecta != null
                                ? Text(
                                    '¡Prueba otra vez!',
                                    textAlign: TextAlign.center,
                                    style:
                                        GoogleFonts.quicksand(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  )
                                : null,
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
