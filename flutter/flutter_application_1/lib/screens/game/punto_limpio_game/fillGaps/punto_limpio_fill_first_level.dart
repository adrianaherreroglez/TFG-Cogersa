import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/primer_nivel_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PuntoLimpioFirstFillPage extends StatefulWidget {
  final DatosPartida datosPartida;
  final int salaId;

  const PuntoLimpioFirstFillPage({
    super.key,
    required this.datosPartida,
    required this.salaId,
  });

  @override
  State<PuntoLimpioFirstFillPage> createState() =>
      _PuntoLimpioFirstFillPageState();
}

class _PuntoLimpioFirstFillPageState extends State<PuntoLimpioFirstFillPage> {
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

    objetos = gameService.getObjetosPrimerNivelPuntoLimpio();
    objetos.shuffle();

    widget.datosPartida.cronometro.start();
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  // COMPROBAR RESPUESTA
  void comprobarRespuesta(String contenedor) {
    if (respuestaCorrectaMostrada) return;

    widget.datosPartida.intentos++;

    final String contenedorCorrecto = objetoActual['contenedor']!;

    if (contenedor == contenedorCorrecto) {
      final int puntosRespuesta = primerNivel.sumarPuntosRespuestaCorrecta();

      widget.datosPartida.puntos += puntosRespuesta;

      setState(() {
        respuestasCorrectas[indiceObjetoActual] = contenedor;
        respuestaIncorrecta = null;
        respuestaCorrectaMostrada = true;
        puntosGanadosActuales = puntosRespuesta;
        puntosPerdidosActuales = 0;
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;

        final int siguienteIndice = indiceObjetoActual + 1;

        if (siguienteIndice >= objetos.length) {
          context.go(
            '/puntolimpio/fillGaps/secondlevel',
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
      final int puntosRestados = primerNivel.restarPuntosRespuestaIncorrecta();

      setState(() {
        respuestaIncorrecta = contenedor;
        widget.datosPartida.puntos -= puntosRestados;
        respuestaCorrectaMostrada = false;
        puntosGanadosActuales = 0;
        puntosPerdidosActuales = puntosRestados;
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool esMovil = constraints.maxWidth < 600;

        final double tamanoImagen = esMovil ? 95 : 125;
        final double altoTarjeta = esMovil ? 290 : 190;

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
            constraints: BoxConstraints(minHeight: altoTarjeta),
            padding: EdgeInsets.symmetric(
              horizontal: esMovil ? 14 : 25,
              vertical: esMovil ? 16 : 20,
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
            child: esMovil
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _construirImagenObjeto(tamanoImagen),
                      const SizedBox(height: 12),
                      _construirTextoFrase(
                        nombre,
                        articulo,
                        contenedorCorrecto,
                        completada,
                        colorContenedor,
                        true,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _construirImagenObjeto(tamanoImagen),
                      const SizedBox(width: 28),
                      Expanded(
                        child: _construirTextoFrase(
                          nombre,
                          articulo,
                          contenedorCorrecto,
                          completada,
                          colorContenedor,
                          false,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // IMAGEN DEL OBJETO
  Widget _construirImagenObjeto(double tamano) {
    return Container(
      width: tamano,
      height: tamano,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeGreen.withValues(alpha: 0.12)),
      ),
      child: Image.asset(objetoActual['imagen']!, fit: BoxFit.contain),
    );
  }

  // TEXTO DE LA FRASE
  Widget _construirTextoFrase(
    String nombre,
    String articulo,
    String contenedorCorrecto,
    bool completada,
    Color colorContenedor,
    bool esMovil,
  ) {
    final double tamanoTexto = esMovil ? 15 : 19;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: esMovil
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          '¿DÓNDE VA?',
          textAlign: esMovil ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.quicksand(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: secondaryText,
            letterSpacing: 0.6,
          ),
        ),

        const SizedBox(height: 8),

        // FRASE Y HUECO
        Wrap(
          alignment: esMovil ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 3,
          runSpacing: 7,
          children: [
            Text(
              '$articulo ',
              style: GoogleFonts.quicksand(
                fontSize: tamanoTexto,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4F5951),
              ),
            ),

            Text(
              nombre,
              style: GoogleFonts.quicksand(
                fontSize: tamanoTexto,
                fontWeight: FontWeight.w800,
                color: themeGreen,
              ),
            ),

            Text(
              ' va en el contenedor de ',
              style: GoogleFonts.quicksand(
                fontSize: tamanoTexto,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4F5951),
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: esMovil ? 145 : 180,
              height: esMovil ? 48 : 58,
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6),
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
                        gameService.nombreContenedorPuntoLimpio(
                          contenedorCorrecto,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: esMovil ? 10 : 12,
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
                  mainAxisAlignment: esMovil
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
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
                  mainAxisAlignment: esMovil
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
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
    );
  }

  // BOTÓN DEL CONTENEDOR
  Widget construirBotonContenedor(String contenedor) {
    final bool esRespuestaIncorrecta = respuestaIncorrecta == contenedor;

    final bool esRespuestaCorrecta =
        respuestaCorrectaMostrada && objetoActual['contenedor'] == contenedor;

    final Color color = gameService.colorContenedor(contenedor);

   
    const Color azulMarino = Color(0xFF0B1F4B);

    return GestureDetector(
      onTap: () {
        if (!respuestaCorrectaMostrada) {
          comprobarRespuesta(contenedor);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 55,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: esRespuestaIncorrecta
              ? const Color(0xFFFFEBEE)
              : esRespuestaCorrecta
              ? color.withValues(alpha: 0.15)
              : azulMarino,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: esRespuestaIncorrecta
                ? const Color(0xFFE53935)
                : esRespuestaCorrecta
                ? color
                : azulMarino,
            width: esRespuestaCorrecta ? 3 : 1,
          ),
        ),
        child: Center(
          child: Text(
            gameService.nombreContenedorPuntoLimpio(contenedor),
            textAlign: TextAlign.center,
            maxLines: 2,
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
        .getContenedoresBotonesPrimerNivel();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double ancho = constraints.maxWidth;

        final int columnas;
        if (ancho >= 1100) {
          columnas = 6;
        } else if (ancho >= 600) {
          columnas = 3;
        } else {
          columnas = 2;
        }

        const double separacion = 10;
        final double padding = ancho < 600 ? 12 : 20;

        final double anchoInterior = ancho - (padding * 2);

        final double anchoBoton =
            (anchoInterior - separacion * (columnas - 1)) / columnas;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
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
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: separacion,
            runSpacing: 10,
            children: contenedoresBotones.map((contenedor) {
              return SizedBox(
                width: anchoBoton,
                child: construirBotonContenedor(contenedor),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // CABECERA ADAPTABLE
  Widget _construirCabecera(bool esMovil) {
    final nivel = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_rounded, color: themeGreen, size: 20),
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
    );

    final puntos = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E7E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 22),
          const SizedBox(width: 6),
          Text(
            '${widget.datosPartida.puntos} puntos',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );

    final titulo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '¡RELLENA LOS HUECOS!',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: esMovil ? 22 : 29,
            fontWeight: FontWeight.w800,
            color: themeGreen,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Completa cada frase eligiendo el contenedor correcto',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: esMovil ? 11 : 14,
            fontWeight: FontWeight.w500,
            color: secondaryText,
          ),
        ),
      ],
    );

    if (esMovil) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [nivel, puntos],
          ),
          const SizedBox(height: 14),
          titulo,
        ],
      );
    }

    return SizedBox(
      height: 72,
      child: Row(
        children: [
          nivel,
          const SizedBox(width: 15),
          Expanded(child: Center(child: titulo)),
          const SizedBox(width: 15),
          puntos,
        ],
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool esMovil = constraints.maxWidth < 650;

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      esMovil ? 12 : 35,
                      esMovil ? 15 : 25,
                      esMovil ? 12 : 35,
                      25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // CABECERA
                        _construirCabecera(esMovil),

                        SizedBox(height: esMovil ? 18 : 20),

                        // TARJETA DEL OBJETO
                        construirTarjetaFrase(),

                        SizedBox(height: esMovil ? 15 : 20),

                        // TARJETA DE CONTENEDORES
                        construirTarjetaContenedores(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
