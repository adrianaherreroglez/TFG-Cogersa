
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/primer_nivel_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class FirstFillPage extends StatefulWidget {
  final DatosPartida datosPartida;
  final int salaId;

  const FirstFillPage({
    super.key,
    required this.datosPartida,
    required this.salaId,
  });

  @override
  State<FirstFillPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstFillPage> {
  final GameService gameService = GameService();
  final PrimerNivel primerNivel = PrimerNivel();

  late List<Map<String, String>> objetos;

  int indiceObjetoActual = 0;

  final Map<int, String> respuestasCorrectas = {};

  String? respuestaIncorrecta;
  bool respuestaCorrectaMostrada = false;
  int puntosGanadosActuales = 0;
  int puntosPerdidosActuales = 0;

  final Color themeGreen = const Color(0xFF298133);
  final Color lightGreen = const Color(0xFFE8F5E9);
  final Color secondaryGreen = const Color(0xFFD8EDD5);
  final Color secondaryText = const Color(0xFF5D7A61);

  @override
  void initState() {
    super.initState();

    objetos = gameService.getObjetosPrimerNivel();
    objetos.shuffle(Random());

    widget.datosPartida.cronometro.start();
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    if (respuestaCorrectaMostrada) return;

    widget.datosPartida.intentos++;

    final String contenedorCorrecto = objetoActual['contenedor']!;

    if (contenedor == contenedorCorrecto) {
      final int puntosRespuesta =
          primerNivel.sumarPuntosRespuestaCorrecta();

      final int puntosRespuestaIncorrecta =
          primerNivel.restarPuntosRespuestaIncorrecta();

      widget.datosPartida.puntos += puntosRespuesta;

      setState(() {
        respuestasCorrectas[indiceObjetoActual] = contenedor;
        respuestaIncorrecta = null;
        respuestaCorrectaMostrada = true;
        puntosGanadosActuales = puntosRespuesta;
        puntosPerdidosActuales = puntosRespuestaIncorrecta;
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;

        final int siguienteIndice = indiceObjetoActual + 1;

        if (siguienteIndice >= objetos.length) {
          context.go(
            '/fillGaps/second',
            extra: {
              'salaId': widget.salaId,
              'datosPartida': widget.datosPartida,
            },
          );
          return;
        }

        setState(() {
          indiceObjetoActual = siguienteIndice;
          respuestaIncorrecta = null;
          respuestaCorrectaMostrada = false;
          puntosGanadosActuales = 0;
          puntosPerdidosActuales = 0;
        });
      });
    } else {
      final int puntosPerdidos =
          primerNivel.restarPuntosRespuestaIncorrecta();

      setState(() {
        respuestaIncorrecta = contenedor;

        widget.datosPartida.puntos -= puntosPerdidos;

        respuestaCorrectaMostrada = false;
        puntosGanadosActuales = 0;
        puntosPerdidosActuales = puntosPerdidos;
      });
    }
  }

  
  Widget _chipNivel(bool esMovil) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: esMovil ? 12 : 17,
        vertical: esMovil ? 7 : 9,
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
            size: esMovil ? 18 : 20,
          ),
          SizedBox(width: esMovil ? 5 : 7),
          Text(
            'NIVEL 1',
            style: GoogleFonts.quicksand(
              fontSize: esMovil ? 13 : 15,
              fontWeight: FontWeight.w800,
              color: themeGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipPuntos(bool esMovil) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: esMovil ? 12 : 16,
        vertical: esMovil ? 7 : 9,
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
          Icon(
            Icons.star_rounded,
            color: const Color(0xFFFFB300),
            size: esMovil ? 20 : 22,
          ),
          SizedBox(width: esMovil ? 5 : 6),
          Text(
            '${widget.datosPartida.puntos} puntos',
            style: GoogleFonts.quicksand(
              fontSize: esMovil ? 13 : 15,
              fontWeight: FontWeight.w800,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tituloSubtitulo(bool esMovil) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '¡RELLENA LOS HUECOS!',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: esMovil ? 24 : 29,
            fontWeight: FontWeight.w800,
            color: themeGreen,
            height: 1,
          ),
        ),
        SizedBox(height: esMovil ? 4 : 5),
        Text(
          'Completa cada frase eligiendo el contenedor correcto',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: esMovil ? 13 : 14,
            fontWeight: FontWeight.w500,
            color: secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _cabeceraEscritorio() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 750) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chipNivel(true),
                  _chipPuntos(true),
                ],
              ),
              const SizedBox(height: 14),
              _tituloSubtitulo(true),
            ],
          );
        }

        return SizedBox(
          height: 72,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: _chipNivel(false),
              ),
              _tituloSubtitulo(false),
              Align(
                alignment: Alignment.topRight,
                child: _chipPuntos(false),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cabeceraMovil() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            _chipNivel(true),
            _chipPuntos(true),
          ],
        ),
        const SizedBox(height: 16),
        _tituloSubtitulo(true),
      ],
    );
  }

  
  Widget construirTarjetaFrase(bool esMovil) {
    final String nombre = objetoActual['nombre']!;
    final String articulo = objetoActual['articulo']!;
    final String contenedorCorrecto = objetoActual['contenedor']!;

    final bool completada = respuestaCorrectaMostrada;

    final Color colorContenedor =
        gameService.colorContenedor(contenedorCorrecto);

    final double tamanoImagen = esMovil ? 90 : 125;
    final double paddingImagen = esMovil ? 8 : 12;
    final double separacionImagen = esMovil ? 14 : 28;
    final double tamanoFrase = esMovil ? 18 : 21;
    final double anchoHueco = esMovil ? 62 : 85;
    final double altoHueco = esMovil ? 46 : 60;

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
        height: esMovil ? null : 190,
        constraints: esMovil
            ? const BoxConstraints(minHeight: 120)
            : null,
        padding: EdgeInsets.symmetric(
          horizontal: esMovil ? 14 : 25,
          vertical: esMovil ? 14 : 20,
        ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool espacioReducido =
                constraints.maxWidth < 450;

            final double imagenAdaptada = espacioReducido
                ? min(tamanoImagen, 75.0)
                : tamanoImagen;

            return Row(
              children: [
                Container(
                  width: imagenAdaptada,
                  height: imagenAdaptada,
                  padding: EdgeInsets.all(paddingImagen),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: themeGreen.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Image.asset(
                    objetoActual['imagen']!,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(
                  width: espacioReducido ? 10 : separacionImagen,
                ),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿DÓNDE VA?',
                        style: GoogleFonts.quicksand(
                          fontSize: esMovil ? 11 : 12,
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
                            '$articulo ',
                            style: GoogleFonts.quicksand(
                              fontSize: tamanoFrase,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF4F5951),
                            ),
                          ),

                          Text(
                            nombre,
                            style: GoogleFonts.quicksand(
                              fontSize: tamanoFrase,
                              fontWeight: FontWeight.w800,
                              color: themeGreen,
                            ),
                          ),

                          Text(
                            ' va en el contenedor ',
                            style: GoogleFonts.quicksand(
                              fontSize: tamanoFrase,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4F5951),
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: anchoHueco,
                            height: altoHueco,
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
                                        fontSize: esMovil ? 20 : 24,
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

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: respuestaIncorrecta != null
                            ? Row(
                                key: const ValueKey('error'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.cancel_rounded,
                                    color: Color(0xFFE53935),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '-$puntosPerdidosActuales puntos',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFE53935),
                                    ),
                                  ),
                                ],
                              )
                            : completada
                                ? Row(
                                    key: const ValueKey('correcto'),
                                    mainAxisSize: MainAxisSize.min,
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
            );
          },
        ),
      ),
    );
  }

  
  Widget construirContenedor(
    String contenedor, {
    double ancho = 190,
  }) {
    final bool esRespuestaIncorrecta =
        respuestaIncorrecta == contenedor;

    final bool esRespuestaCorrecta =
        respuestaCorrectaMostrada &&
        objetoActual['contenedor'] == contenedor;

    final Color color = gameService.colorContenedor(contenedor);

    final double alto = ancho * 165 / 190;
    final double tamanoCirculo = ancho * 95 / 190;
    final double paddingCirculo = ancho * 8 / 190;
    final double tamanoTexto = ancho < 150 ? 11 : 13;

    return GestureDetector(
      onTap: () {
        if (!respuestaCorrectaMostrada) {
          comprobarRespuesta(contenedor);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: ancho,
        height: alto,
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
              width: tamanoCirculo,
              height: tamanoCirculo,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(paddingCirculo),
                child: Image.asset(
                  gameService.imagenContenedor(contenedor),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  gameService.nombreContenedor(contenedor).toUpperCase(),
                  style: GoogleFonts.quicksand(
                    fontSize: tamanoTexto,
                    fontWeight: FontWeight.w800,
                    color: esRespuestaIncorrecta
                        ? const Color(0xFFE53935)
                        : esRespuestaCorrecta
                            ? color
                            : secondaryText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _cuerpoEscritorio() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double paddingHorizontal = 55;

        final double anchoDisponible =
            constraints.maxWidth - paddingHorizontal * 2;

        // MISMO ANCHO PARA LOS TRES CONTENEDORES.
        final double anchoContenedor = min(
          190.0,
          (anchoDisponible - 50) / 3,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(55, 25, 55, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cabeceraEscritorio(),

              const SizedBox(height: 14),

              Expanded(
                child: Column(
                  children: [
                    construirTarjetaFrase(false),

                    const SizedBox(height: 24),

                    Expanded(
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 25,
                          runSpacing: 20,
                          children: [
                            construirContenedor(
                              'amarillo',
                              ancho: anchoContenedor,
                            ),

                            construirContenedor(
                              'azul',
                              ancho: anchoContenedor,
                            ),

                            construirContenedor(
                              'verde',
                              ancho: anchoContenedor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

 
  Widget _cuerpoMovil(double ancho) {
    const double paddingH = 16;
    const double separacion = 8;

    // Los tres contenedores tienen exactamente el mismo ancho.
    final double anchoContenedor = max(
      65.0,
      min(
        190.0,
        (ancho - paddingH * 2 - separacion * 2) / 3,
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        paddingH,
        12,
        paddingH,
        20,
      ),
      child: Column(
        children: [
          _cabeceraMovil(),

          const SizedBox(height: 18),

          construirTarjetaFrase(true),

          const SizedBox(height: 22),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: separacion,
            runSpacing: 12,
            children: [
              construirContenedor(
                'amarillo',
                ancho: anchoContenedor,
              ),

              construirContenedor(
                'azul',
                ancho: anchoContenedor,
              ),

              construirContenedor(
                'verde',
                ancho: anchoContenedor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double ancho = constraints.maxWidth;
            final double alto = constraints.maxHeight;

            final bool esMovil = ancho < 800 || alto < 500;

            return Column(
              children: [
                const NavBar(),

                Expanded(
                  child: esMovil
                      ? _cuerpoMovil(ancho)
                      : _cuerpoEscritorio(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
