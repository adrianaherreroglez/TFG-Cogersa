import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/segundo_nivel_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';


class PuntoLimpioSecondFillPage extends StatefulWidget {
  const PuntoLimpioSecondFillPage({super.key, required this.puntosPrevios});

  @override
  State<PuntoLimpioSecondFillPage> createState() =>
      _PuntoLimpioSecondFillPageState();
  final int puntosPrevios;
}

class _PuntoLimpioSecondFillPageState extends State<PuntoLimpioSecondFillPage> {
  final GameService gameService = GameService();
  final SegundoNivel segundoNivel = SegundoNivel();

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
    puntos = widget.puntosPrevios;

    objetos = gameService.getObjetosSegundoNivelPuntoLimpio();


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
      final int puntosRespuesta = segundoNivel.sumarPuntosRespuestaCorrecta();

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
          context.go('/mygame', extra: puntos);
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
        puntos -= segundoNivel.restarPuntosRespuestaIncorrecta();
        respuestaCorrectaMostrada = false;
        puntosGanadosActuales = 0;
      });
    }
  }

  // TARJETA DEL OBJETO
  Widget construirTarjetaFrase() {
    final String nombre = objetoActual['nombre']!;
    final String articulo = objetoActual['articulo']!;
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
            // IMAGEN DEL OBJETO
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

            // FRASE
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ARTÍCULO
                      Text(
                        '$articulo ',
                        style: GoogleFonts.quicksand(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF4F5951),
                        ),
                      ),

                      // NOMBRE
                      Text(
                        nombre,
                        style: GoogleFonts.quicksand(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: themeGreen,
                        ),
                      ),

                      // TEXTO
                      Text(
                        ' va en el contenedor de ',
                        style: GoogleFonts.quicksand(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4F5951),
                        ),
                      ),

                      // HUECO

                      // HUECO
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 180,
                        height: 50,
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: completada
                              ? colorContenedor.withValues(alpha: 0.10)
                              : const Color(0xFFF8FAF7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: completada
                                ? colorContenedor
                                : themeGreen.withValues(alpha: 0.55),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: completada
                              ? Text(
                                  gameService
                                      .nombreContenedor(contenedorCorrecto)
                                      .toUpperCase(),
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: themeGreen,
                                  ),
                                )
                              : Text(
                                  '...',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: themeGreen,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // MENSAJE DE ESTADO
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
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BOTÓN DEL CONTENEDOR
  Widget construirBotonContenedor(String contenedor) {
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
        height: 50,
        decoration: BoxDecoration(
          color: esRespuestaIncorrecta
              ? const Color(0xFFFFEBEE)
              : esRespuestaCorrecta
              ? color.withValues(alpha: 0.15)
              : Colors.black,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: esRespuestaIncorrecta
                ? const Color(0xFFE53935)
                : esRespuestaCorrecta
                ? color
                : Colors.black,
            width: esRespuestaCorrecta ? 3 : 1,
          ),
        ),
        child: Center(
          child: Text(
            gameService.nombreContenedor(contenedor).toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: esRespuestaIncorrecta
                  ? const Color(0xFFE53935)
                  : esRespuestaCorrecta
                  ? color
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // TARJETA BLANCA CON LOS CONTENEDORES
  Widget construirTarjetaContenedores() {
    final List<String> contenedoresBotones = gameService
        .getContenedoresBotonesSegundoNivel();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E7E0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: contenedoresBotones.map((contenedor) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: construirBotonContenedor(contenedor),
            ),
          );
        }).toList(),
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
                          // NIVEL 2
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
                                    'NIVEL 2',
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

                    const SizedBox(height: 18),

                    // TARJETA DEL OBJETO
                    construirTarjetaFrase(),

                    const SizedBox(height: 20),

                    // TARJETA BLANCA DE CONTENEDORES
                    construirTarjetaContenedores(),
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
