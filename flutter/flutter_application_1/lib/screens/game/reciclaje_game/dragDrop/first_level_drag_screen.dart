import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/primer_nivel_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class FirstPage extends StatefulWidget {
  final DatosPartida datosPartida;
  final int salaId;

  const FirstPage({
    super.key,
    required this.datosPartida,
    required this.salaId,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final GameService gameService = GameService();
  final PrimerNivel primerNivel = PrimerNivel();

  late List<Map<String, String>> objetos;

  int indiceObjetoActual = 0;
  bool objetoVisible = true;

  final List<String> objetosAmarillos = [];
  final List<String> objetosAzules = [];
  final List<String> objetosVerdes = [];

  DatosPartida get datosPartida => widget.datosPartida;

  @override
  void initState() {
    super.initState();

    objetos = gameService.getObjetosPrimerNivel();
    objetos.shuffle(Random());
    datosPartida.cronometro.start();
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    datosPartida.intentos++;

    final objeto = objetoActual;
    final contenedorCorrecto = objeto['contenedor'];

    if (contenedor == contenedorCorrecto) {
      datosPartida.puntos += primerNivel.sumarPuntosRespuestaCorrecta();

      setState(() {
        if (contenedor == 'amarillo') {
          objetosAmarillos.clear();
          objetosAmarillos.add(objeto['nombre']!);
        } else if (contenedor == 'azul') {
          objetosAzules.clear();
          objetosAzules.add(objeto['nombre']!);
        } else if (contenedor == 'verde') {
          objetosVerdes.clear();
          objetosVerdes.add(objeto['nombre']!);
        }

        indiceObjetoActual++;

        if (indiceObjetoActual < objetos.length) {
          objetoVisible = true;
        } else {
          objetoVisible = false;
        }
      });

      if (indiceObjetoActual >= objetos.length) {
        context.go(
          '/second',
          extra: {'salaId': widget.salaId, 'datosPartida': widget.datosPartida},
        );
      }
    } else {
      datosPartida.puntos -= primerNivel.restarPuntosRespuestaIncorrecta();

      setState(() {
        objetoVisible = true;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // WIDGETS DE LA CABECERA
  // ---------------------------------------------------------------------------

  Widget _chipNivel(bool esMovil) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: esMovil ? 12 : 22,
        vertical: esMovil ? 7 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD8EDD5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_rounded,
            color: const Color(0xFF298133),
            size: esMovil ? 18 : 22,
          ),
          SizedBox(width: esMovil ? 5 : 8),
          Text(
            'NIVEL 1',
            style: GoogleFonts.quicksand(
              fontSize: esMovil ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF298133),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipPuntos(bool esMovil) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: esMovil ? 12 : 22,
        vertical: esMovil ? 7 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: const Color(0xFFFFB300),
            size: esMovil ? 20 : 25,
          ),
          SizedBox(width: esMovil ? 5 : 7),
          Text(
            '${datosPartida.puntos} puntos',
            style: GoogleFonts.quicksand(
              fontSize: esMovil ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D7A61),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titulo(bool esMovil) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '¡RECICLA ESTE OBJETO!',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: esMovil ? 26 : 32,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF298133),
            height: 1,
          ),
        ),
        SizedBox(height: esMovil ? 4 : 5),
        Text(
          'Arrastra el objeto hasta el contenedor correcto',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: esMovil ? 14 : 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF5D7A61),
          ),
        ),
      ],
    );
  }

  Widget _cabecera(bool esMovil) {
    if (esMovil) {
      // Móvil: nivel y puntos arriba, título debajo
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_chipNivel(true), _chipPuntos(true)],
          ),
          const SizedBox(height: 26),
          _titulo(true),
        ],
      );
    }

    // Pantalla grande: todo en una fila
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _chipNivel(false),
          const SizedBox(width: 28),
          Expanded(child: Center(child: _titulo(false))),
          const SizedBox(width: 28),
          _chipPuntos(false),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OBJETO Y CONTENEDORES
  // ---------------------------------------------------------------------------

  // Objeto con altura fija para que el diseño no "salte" al desaparecer
  Widget _objeto(double tamano, bool esMovil) {
    return SizedBox(
      height: tamano,
      child: objetoVisible && indiceObjetoActual < objetos.length
          ? _ObjetoArrastrable(
              imagen: objetoActual['imagen']!,
              tamano: tamano,
              esMovil: esMovil,
            )
          : null,
    );
  }

  // Los 3 contenedores, en el orden: amarillo, azul, verde
  List<Widget> _contenedores(double ancho) {
    return [
      _ContenedorReciclaje(
        ancho: ancho,
        color: const Color(0xFFFFD740),
        imagen: 'assets/icons/contenedores/basura-amarilla.png',
        nombre: 'AMARILLO',
        objetos: objetosAmarillos,
        gameService: gameService,
        todosLosObjetos: objetos,
        onAccept: () {
          comprobarRespuesta('amarillo');
        },
      ),
      _ContenedorReciclaje(
        ancho: ancho,
        color: const Color(0xFF42A5F5),
        imagen: 'assets/icons/contenedores/basura-azul.png',
        nombre: 'AZUL',
        objetos: objetosAzules,
        gameService: gameService,
        todosLosObjetos: objetos,
        onAccept: () {
          comprobarRespuesta('azul');
        },
      ),
      _ContenedorReciclaje(
        ancho: ancho,
        color: const Color(0xFF66BB6A),
        imagen: 'assets/icons/contenedores/basura-verde.png',
        nombre: 'VERDE',
        objetos: objetosVerdes,
        gameService: gameService,
        todosLosObjetos: objetos,
        onAccept: () {
          comprobarRespuesta('verde');
        },
      ),
    ];
  }

  // Une una lista de widgets en una fila, con separación entre ellos
  Widget _fila(List<Widget> items, double separacion) {
    final hijos = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      if (i > 0) hijos.add(SizedBox(width: separacion));
      hijos.add(items[i]);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: hijos,
    );
  }

  // Pantalla grande: los 3 contenedores en una sola fila
  Widget _contenedoresEscritorio(double ancho, double separacion) {
    return _fila(_contenedores(ancho), separacion);
  }

  // Móvil: 2 contenedores arriba y el tercero debajo, en medio de ellos
  Widget _contenedoresMovil(double ancho, double separacion) {
    final c = _contenedores(ancho);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _fila([c[0], c[1]], separacion),
        const SizedBox(height: 4),
        c[2],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final ancho = constraints.maxWidth;
            final alto = constraints.maxHeight;

            // Móvil en vertical o en horizontal (poca altura)
            final esMovil = ancho < 700 || alto < 500;

            final paddingH = esMovil ? 14.0 : 45.0;
            final separacion = esMovil ? 8.0 : 35.0;

            // Móvil: 2 contenedores por fila (2 filas).
            // Pantalla grande: 3 contenedores en una sola fila.
            final anchoPorPantalla = esMovil
                ? (ancho - paddingH * 2 - separacion) / 2
                : (ancho - paddingH * 2 - separacion * 2) / 3;

            // Altura que pueden ocupar los contenedores:
            // en móvil hay 2 filas, así que se deja sitio para el resto.
            final alturaFila = max(110.0, (alto - 400) / 2);
            final anchoPorAlto = esMovil
                ? alturaFila * 205 / 245
                : alto * 0.38 * 205 / 245;
            final anchoContenedor = min(
              205.0,
              min(anchoPorPantalla, anchoPorAlto),
            );

            final tamanoObjeto = esMovil
                ? min(ancho * 0.30, alto * 0.16).clamp(70.0, 120.0).toDouble()
                : 140.0;

            return Column(
              children: [
                const NavBar(),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingH,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        // CABECERA
                        _cabecera(esMovil),

                        if (esMovil)
                          // MÓVIL: objeto y contenedores juntos, pegados arriba
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Espacio entre el título y el objeto
                                    const SizedBox(height: 30),
                                    _objeto(tamanoObjeto, esMovil),
                                    // Espacio entre el objeto y los contenedores
                                    const SizedBox(height: 24),
                                    _contenedoresMovil(
                                      anchoContenedor,
                                      separacion,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else ...[
                          // PANTALLA GRANDE: objeto en el centro, contenedores abajo
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child:
                                  objetoVisible &&
                                      indiceObjetoActual < objetos.length
                                  ? _ObjetoArrastrable(
                                      imagen: objetoActual['imagen']!,
                                      tamano: tamanoObjeto,
                                      esMovil: esMovil,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: _contenedoresEscritorio(
                              anchoContenedor,
                              separacion,
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// OBJETO ARRASTRABLE
class _ObjetoArrastrable extends StatelessWidget {
  final String imagen;
  final double tamano;
  final bool esMovil;

  const _ObjetoArrastrable({
    required this.imagen,
    required this.tamano,
    required this.esMovil,
  });

  @override
  Widget build(BuildContext context) {
    final tamanoFeedback = tamano * 0.72;

    // En móvil el objeto se muestra encima del dedo para que no lo tape.
    final DragAnchorStrategy estrategia = esMovil
        ? (draggable, context, position) =>
              Offset(tamanoFeedback / 2, tamanoFeedback + 10)
        : childDragAnchorStrategy;

    return Draggable<String>(
      data: imagen,
      dragAnchorStrategy: estrategia,

      // Tamaño del objeto cuando lo estamos arrastrando
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(
          imagen,
          width: tamanoFeedback,
          height: tamanoFeedback,
          fit: BoxFit.contain,
        ),
      ),

      childWhenDragging: Opacity(
        opacity: 0.2,
        child: _ObjetoVisual(imagen: imagen, tamano: tamano),
      ),

      child: _ObjetoVisual(imagen: imagen, tamano: tamano),
    );
  }
}

// VISUAL DEL OBJETO
class _ObjetoVisual extends StatelessWidget {
  final String imagen;
  final double tamano;

  const _ObjetoVisual({required this.imagen, required this.tamano});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      padding: EdgeInsets.all(tamano * 0.23),
      child: Image.asset(
        imagen,
        width: tamano * 0.82,
        height: tamano * 0.82,
        fit: BoxFit.contain,
      ),
    );
  }
}

// CONTENEDOR DE RECICLAJE
class _ContenedorReciclaje extends StatefulWidget {
  final double ancho;
  final Color color;
  final String imagen;
  final String nombre;

  final List<String> objetos;

  final GameService gameService;
  final List<Map<String, String>> todosLosObjetos;

  final VoidCallback onAccept;

  const _ContenedorReciclaje({
    required this.ancho,
    required this.color,
    required this.imagen,
    required this.nombre,
    required this.objetos,
    required this.gameService,
    required this.todosLosObjetos,
    required this.onAccept,
  });

  @override
  State<_ContenedorReciclaje> createState() => _ContenedorReciclajeState();
}

class _ContenedorReciclajeState extends State<_ContenedorReciclaje> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Todo se calcula a partir del ancho (proporciones del diseño original: 205 px)
    final ancho = widget.ancho;
    final alto = ancho * 245 / 205;
    final tamanoImagen = ancho * 180 / 205;
    final tamanoObjetoDentro = ancho * 55 / 205;
    final tamanoTexto = ancho < 150 ? 12.0 : 17.0;

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        setState(() {
          isHovering = true;
        });

        return true;
      },

      onLeave: (_) {
        setState(() {
          isHovering = false;
        });
      },

      onAcceptWithDetails: (details) {
        setState(() {
          isHovering = false;
        });

        widget.onAccept();
      },

      builder:
          (
            BuildContext context,
            List<String?> candidateData,
            List<dynamic> rejectedData,
          ) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              transform: Matrix4.translationValues(0, isHovering ? -8 : 0, 0),

              width: ancho,
              height: alto,

              decoration: BoxDecoration(
                color: isHovering
                    ? widget.color.withValues(alpha: 0.18)
                    : Colors.transparent,

                borderRadius: BorderRadius.circular(25),

                border: Border.all(
                  color: isHovering ? widget.color : Colors.transparent,
                  width: 3,
                ),

                boxShadow: isHovering
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: tamanoImagen,
                    height: tamanoImagen,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          widget.imagen,
                          width: tamanoImagen,
                          height: tamanoImagen,
                          fit: BoxFit.contain,
                        ),

                        if (widget.objetos.isNotEmpty)
                          ...widget.objetos.take(3).map((nombreObjeto) {
                            final imagenObjeto = widget.gameService
                                .imagenDelObjeto(
                                  nombreObjeto,
                                  widget.todosLosObjetos,
                                );

                            if (imagenObjeto == null) {
                              return const SizedBox();
                            }

                            return Image.asset(
                              imagenObjeto,
                              width: tamanoObjetoDentro,
                              height: tamanoObjetoDentro,
                              fit: BoxFit.contain,
                            );
                          }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.nombre,
                      style: GoogleFonts.quicksand(
                        fontSize: tamanoTexto,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF298133),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}