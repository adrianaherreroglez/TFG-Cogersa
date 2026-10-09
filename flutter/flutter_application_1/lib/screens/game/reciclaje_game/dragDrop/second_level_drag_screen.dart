import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/segundo_nivel_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.datosPartida});

  @override
  State<SecondPage> createState() => _SecondPageState();
  final DatosPartida datosPartida;
}

class _SecondPageState extends State<SecondPage> {
  final GameService gameService = GameService();
  final SegundoNivel segundoNivel = SegundoNivel();

  late List<Map<String, String>> objetos;

  int indiceObjetoActual = 0;
  int intentos = 0;
  bool objetoVisible = true;

  final List<String> objetosAmarillos = [];
  final List<String> objetosAzules = [];
  final List<String> objetosVerdes = [];
  final List<String> objetosMarrones = [];

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
    intentos++;

    final objeto = objetoActual;
    final contenedorCorrecto = objeto['contenedor'];

    if (contenedor == contenedorCorrecto) {
      widget.datosPartida.puntos += segundoNivel.sumarPuntosRespuestaCorrecta();

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
        } else if (contenedor == 'marrón') {
          objetosMarrones.clear();
          objetosMarrones.add(objeto['nombre']!);
        }

        indiceObjetoActual++;
        intentos = 0;

        if (indiceObjetoActual < objetos.length) {
          objetoVisible = true;
        } else {
          objetoVisible = false;
        }
      });

      if (indiceObjetoActual >= objetos.length) {
        context.go('/third', extra: widget.datosPartida);
      }
    } else {
      widget.datosPartida.puntos -= segundoNivel
          .restarPuntosRespuestaIncorrecta();

      setState(() {
        objetoVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),

      body: Column(
        children: [
          const NavBar(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),

              child: Column(
                children: [
                  // CABECERA
                  SizedBox(
                    height: 70,

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // NIVEL
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xFFD8EDD5),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.flag_rounded,
                                color: Color(0xFF298133),
                                size: 22,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                'NIVEL 2',
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF298133),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 28),

                        // TÍTULO Y SUBTÍTULO
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '¡RECICLA ESTE OBJETO!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF298133),
                                    height: 1,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  'Arrastra el objeto hasta el contenedor correcto',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5D7A61),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 28),

                        // PUNTOS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 10,
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
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFB300),
                                size: 25,
                              ),

                              const SizedBox(width: 7),

                              Text(
                                '${widget.datosPartida.puntos} puntos',
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5D7A61),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // OBJETO
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child:
                          objetoVisible && indiceObjetoActual < objetos.length
                          ? _ObjetoArrastrable(imagen: objetoActual['imagen']!)
                          : const SizedBox(),
                    ),
                  ),

                  // CONTENEDORES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ContenedorReciclaje(
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

                      const SizedBox(width: 35),

                      _ContenedorReciclaje(
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

                      const SizedBox(width: 35),

                      _ContenedorReciclaje(
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

                      const SizedBox(width: 35),

                      _ContenedorReciclaje(
                        color: const Color.fromARGB(255, 146, 100, 71),
                        imagen: 'assets/icons/contenedores/basura-marron.png',
                        nombre: 'MARRÓN',
                        objetos: objetosMarrones,
                        gameService: gameService,
                        todosLosObjetos: objetos,
                        onAccept: () {
                          comprobarRespuesta('marrón');
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// OBJETO ARRASTRABLE
class _ObjetoArrastrable extends StatelessWidget {
  final String imagen;

  const _ObjetoArrastrable({required this.imagen});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: imagen,

      // Tamaño del objeto cuando lo estamos arrastrando
      feedback: Material(
        color: Colors.transparent,

        child: Image.asset(
          imagen,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),

      childWhenDragging: Opacity(
        opacity: 0.2,

        child: _ObjetoVisual(imagen: imagen),
      ),

      child: _ObjetoVisual(imagen: imagen),
    );
  }
}

// VISUAL DEL OBJETO
class _ObjetoVisual extends StatelessWidget {
  final String imagen;

  const _ObjetoVisual({required this.imagen});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,

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

      padding: const EdgeInsets.all(32),

      child: Image.asset(imagen, width: 115, height: 115, fit: BoxFit.contain),
    );
  }
}

// CONTENEDOR DE RECICLAJE
class _ContenedorReciclaje extends StatefulWidget {
  final Color color;
  final String imagen;
  final String nombre;

  final List<String> objetos;

  final GameService gameService;
  final List<Map<String, String>> todosLosObjetos;

  final VoidCallback onAccept;

  const _ContenedorReciclaje({
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

              width: 205,
              height: 245,

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
                    width: 180,
                    height: 180,

                    child: Stack(
                      alignment: Alignment.center,

                      children: [
                        Image.asset(
                          widget.imagen,
                          width: 180,
                          height: 180,
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
                              width: 55,
                              height: 55,
                              fit: BoxFit.contain,
                            );
                          }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    widget.nombre,
                    style: GoogleFonts.quicksand(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF298133),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
