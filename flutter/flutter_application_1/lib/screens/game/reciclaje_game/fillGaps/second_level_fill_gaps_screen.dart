import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/segundo_nivel_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SecondFillPage extends StatefulWidget {
  final DatosPartida datosPartida;
  final int salaId;

  const SecondFillPage({
    super.key,
    required this.datosPartida,
    required this.salaId,
  });

  @override
  State<SecondFillPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondFillPage> {
  final GameService gameService = GameService();
  final SegundoNivel segundoNivel = SegundoNivel();

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

    objetos = gameService.getObjetosSegundoNivel();
    objetos.shuffle(Random());
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    if (respuestaCorrectaMostrada) {
      return;
    }

    widget.datosPartida.intentos++;

    final String contenedorCorrecto = objetoActual['contenedor']!;

    if (contenedor == contenedorCorrecto) {
      final int puntosRespuesta = segundoNivel.sumarPuntosRespuestaCorrecta();
      final int puntosRespuestaIncorrecta = segundoNivel
          .restarPuntosRespuestaIncorrecta();

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
            '/fillGaps/third',
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
      final int puntosPerdidos = segundoNivel.restarPuntosRespuestaIncorrecta();

      setState(() {
        respuestaIncorrecta = contenedor;
        widget.datosPartida.puntos -= segundoNivel
            .restarPuntosRespuestaIncorrecta();
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
          Icon(Icons.flag_rounded, color: themeGreen, size: esMovil ? 18 : 20),
          SizedBox(width: esMovil ? 5 : 7),
          Text(
            'NIVEL 2',
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
        border: Border.all(color: const Color(0xFFE2E7E0)),
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

  // Pantalla grande: nivel a la izquierda, título en el centro, puntos a la derecha
  Widget _cabeceraEscritorio() {
    return SizedBox(
      height: 72,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(alignment: Alignment.topLeft, child: _chipNivel(false)),
          _tituloSubtitulo(false),
          Align(alignment: Alignment.topRight, child: _chipPuntos(false)),
        ],
      ),
    );
  }

  // Móvil: nivel y puntos arriba, título debajo
  Widget _cabeceraMovil() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_chipNivel(true), _chipPuntos(true)],
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

    final Color colorContenedor = gameService.colorContenedor(
      contenedorCorrecto,
    );

    // Tamaños según el dispositivo
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
        // En móvil la altura se adapta al contenido (la frase puede ocupar
        // varias líneas); en pantalla grande es fija.
        height: esMovil ? null : 190,
        constraints: esMovil ? const BoxConstraints(minHeight: 120) : null,
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
        child: Row(
          children: [
            // IMAGEN DEL OBJETO
            Container(
              width: tamanoImagen,
              height: tamanoImagen,
              padding: EdgeInsets.all(paddingImagen),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeGreen.withValues(alpha: 0.12)),
              ),
              child: Image.asset(objetoActual['imagen']!, fit: BoxFit.contain),
            ),

            SizedBox(width: separacionImagen),

            // FRASE
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
                      // Artículo
                      Text(
                        '$articulo ',
                        style: GoogleFonts.quicksand(
                          fontSize: tamanoFrase,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF4F5951),
                        ),
                      ),

                      // Nombre
                      Text(
                        nombre,
                        style: GoogleFonts.quicksand(
                          fontSize: tamanoFrase,
                          fontWeight: FontWeight.w800,
                          color: themeGreen,
                        ),
                      ),

                      // va en el contenedor
                      Text(
                        ' va en el contenedor ',
                        style: GoogleFonts.quicksand(
                          fontSize: tamanoFrase,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4F5951),
                        ),
                      ),

                      // HUECO
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

                  // MENSAJE DE ESTADO
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
        ),
      ),
    );
  }

  
  Widget construirContenedor(String contenedor, {double ancho = 190}) {
    final bool esRespuestaIncorrecta = respuestaIncorrecta == contenedor;

    final bool esRespuestaCorrecta =
        respuestaCorrectaMostrada && objetoActual['contenedor'] == contenedor;

    final Color color = gameService.colorContenedor(contenedor);

    // Todo se calcula a partir del ancho (diseño original: 190 px)
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

  
  // Pantalla grande (igual que el diseño original)
  Widget _cuerpoEscritorio() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(55, 25, 55, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CABECERA
          _cabeceraEscritorio(),

          const SizedBox(height: 14),

          Expanded(
            child: Column(
              children: [
                // TARJETA DEL OBJETO
                construirTarjetaFrase(false),

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

                          const SizedBox(width: 25),

                          construirContenedor('marrón'),
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
    );
  }

  // Móvil: todo en una columna, con scroll por si la pantalla es muy baja
  Widget _cuerpoMovil(double ancho) {
    const double paddingH = 16;
    const double separacion = 8;

    // Los contenedores van de 2 en 2 (2 filas), así que pueden ser más grandes
    final double anchoContenedor = min(
      190.0,
      (ancho - paddingH * 2 - separacion) / 2,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(paddingH, 12, paddingH, 20),
      child: Column(
        children: [
          // CABECERA
          _cabeceraMovil(),

          const SizedBox(height: 18),

          // TARJETA DEL OBJETO
          construirTarjetaFrase(true),

          const SizedBox(height: 22),

          // CONTENEDORES: 2 arriba y 2 abajo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              construirContenedor('amarillo', ancho: anchoContenedor),

              const SizedBox(width: separacion),

              construirContenedor('azul', ancho: anchoContenedor),
            ],
          ),

          const SizedBox(height: separacion),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              construirContenedor('verde', ancho: anchoContenedor),

              const SizedBox(width: separacion),

              construirContenedor('marrón', ancho: anchoContenedor),
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
            final ancho = constraints.maxWidth;
            final alto = constraints.maxHeight;

            // Móvil en vertical o en horizontal (poca altura)
            final esMovil = ancho < 800 || alto < 500;

            return Column(
              children: [
                const NavBar(),

                Expanded(
                  child: esMovil ? _cuerpoMovil(ancho) : _cuerpoEscritorio(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}