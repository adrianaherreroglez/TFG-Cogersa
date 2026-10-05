import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/segundo_nivel_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';



class PuntoLimpioSecondPage extends StatefulWidget {
  const PuntoLimpioSecondPage({super.key, required this.puntosPrevios});

  @override
  State<PuntoLimpioSecondPage> createState() => _FirstPageState();
  final int puntosPrevios;
}

class _FirstPageState extends State<PuntoLimpioSecondPage> {
  
  final GameService gameService = GameService();
  final SegundoNivel segundoNivel = SegundoNivel();

  late List<Map<String, String>> objetos;


  int indiceObjetoActual = 0;
  int puntos = 0;
  int intentos = 0;
  bool objetoVisible = true;

  // Objetos que aparecen dentro de los contenedores

  final List<String> objetosMotor = [];
  final List<String> objetosJuguetes = [];
  final List<String> objetosMetal = [];
  final List<String> objetosVegetales = [];
  final List<String> objetosCapsulas = [];
  final List<String> objetosToxico = [];

  @override
  void initState() {
    super.initState();
    puntos = widget.puntosPrevios;
    objetos = gameService.getObjetosSegundoNivelPuntoLimpio();
    objetos.shuffle(Random());
  }

  // OBJETO ACTUAL
  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    intentos++;

    final objeto = objetoActual;
    final contenedorCorrecto = objeto['contenedor'];

    if (contenedor == contenedorCorrecto) {
      puntos += segundoNivel.sumarPuntosRespuestaCorrecta();
      setState(() {
        // Solo mostramos el último objeto acertado
        // dentro de cada contenedor.

        if (contenedor == 'motor') {
          objetosMotor.clear();
          objetosMotor.add(objeto['nombre']!);
        } else if (contenedor == 'juguetes') {
          objetosJuguetes.clear();
          objetosJuguetes.add(objeto['nombre']!);
        } else if (contenedor == 'metal') {
          objetosMetal.clear();
          objetosMetal.add(objeto['nombre']!);
        } else if (contenedor == 'vegetales') {
          objetosVegetales.clear();
          objetosVegetales.add(objeto['nombre']!);
        } else if (contenedor == 'capsulas') {
          objetosCapsulas.clear();
          objetosCapsulas.add(objeto['nombre']!);
        } else if (contenedor == 'toxico') {
          objetosToxico.clear();
          objetosToxico.add(objeto['nombre']!);
        }

        // Pasamos al siguiente objeto
        indiceObjetoActual++;

        // Reiniciamos los intentos
        intentos = 0;

        // Comprobamos si quedan objetos
        if (indiceObjetoActual < objetos.length) {
          objetoVisible = true;
        } else {
          objetoVisible = false;
        }
      });

      // FIN DEL NIVEL
      if (indiceObjetoActual >= objetos.length) {
        context.go(
          '/mygame',
          extra: puntos,
        );
      }
    }

    // RESPUESTA INCORRECTA
    else {
      setState(() {
        // Mantiene el objeto visible
        objetoVisible = true;

        puntos -= segundoNivel.restarPuntosRespuestaIncorrecta();
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
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
                vertical: 10,
              ),

              child: Column(
                children: [
                  // Cabecera
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
                                '$puntos puntos',
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

                  // OBJETO ARRASTRABLE
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,

                      child: objetoVisible &&
                              indiceObjetoActual <
                                  objetos.length
                          ? _ObjetoArrastrable(
                              imagen: objetoActual['imagen']!,
                              nombre: objetoActual['nombre']!,
                            )
                          : const SizedBox(),
                    ),
                  ),

  
                  // CONTENEDORES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // MOTOR
                      _ContenedorPuntoLimpio(
                        color: const Color.fromARGB(255, 167, 164, 154),
                        imagen:
                            'assets/icons/contenedores/contenedor-de-basura.png',
                        nombre: ' MOTOR',
                        objetos: objetosMotor,
                        todosLosObjetos: objetos,
                        onAccept: () {
                          comprobarRespuesta('motor');
                        },
                      ),

                      const SizedBox(width: 20),

                      // JUGUETES
                      _ContenedorPuntoLimpio(
                        color: const Color.fromARGB(255, 167, 164, 154),
                        imagen:
                            'assets/icons/contenedores/contenedor-de-basura.png',
                        nombre: 'JUGUETES',
                        objetos: objetosJuguetes,
                        todosLosObjetos: objetos,
                        onAccept: () {
                          comprobarRespuesta('juguetes');
                        },
                      ),

                      const SizedBox(width: 20),

                      // METAL
                      _ContenedorPuntoLimpio(
                        color: const Color.fromARGB(255, 167, 164, 154),
                        imagen:
                            'assets/icons/contenedores/contenedor-de-basura.png',
                        nombre: 'METAL',
                        objetos: objetosMetal,
                        todosLosObjetos: objetos,
                        onAccept: () {
                          comprobarRespuesta('metal');
                        },
                      ),

                      const SizedBox(width: 20),

                      // VEGETALES
                      _ContenedorPuntoLimpio(
                        color: const Color.fromARGB(255, 167, 164, 154),
                        imagen:
                            'assets/icons/contenedores/contenedor-de-basura.png',
                        nombre: 'VEGETALES',
                        objetos: objetosVegetales,
                        todosLosObjetos: objetos,
                        onAccept: () {
                          comprobarRespuesta('vegetales');
                        },
                      ),

                      const SizedBox(width: 20),

                      // CÁPSULAS
                      _ContenedorPuntoLimpio(
                        color: const Color.fromARGB(255, 167, 164, 154),
                        imagen:
                            'assets/icons/contenedores/contenedor-de-basura.png',
                        nombre: 'CÁPSULAS',
                        objetos: objetosCapsulas,
                        todosLosObjetos: objetos,
                        onAccept: () {
                          comprobarRespuesta('capsulas');
                        },
                      ),

                      const SizedBox(width: 20),

                      // PILAS
                      _ContenedorPuntoLimpio(
                        color: const Color.fromARGB(255, 167, 164, 154),
                        imagen:
                            'assets/icons/contenedores/contenedor-de-basura.png',
                        nombre: 'TÓXICO',
                        objetos: objetosToxico,
                        todosLosObjetos: objetos,
                        onAccept: () {
                          comprobarRespuesta('toxico');
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
  final String nombre;

  const _ObjetoArrastrable({
    required this.imagen,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: nombre,

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

        child: _ObjetoVisual(
          imagen: imagen,
        ),
      ),

      child: _ObjetoVisual(
        imagen: imagen,
      ),
    );
  }
}


// VISUAL DEL OBJETO
class _ObjetoVisual extends StatelessWidget {
  final String imagen;

  const _ObjetoVisual({
    required this.imagen,
  });

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

      child: Image.asset(
        imagen,
        width: 115,
        height: 115,
        fit: BoxFit.contain,
      ),
    );
  }
}


// CONTENEDOR DEL PUNTO LIMPIO
class _ContenedorPuntoLimpio extends StatefulWidget {
  final Color color;
  final String imagen;
  final String nombre;

  final List<String> objetos;
  final List<Map<String, String>> todosLosObjetos;

  final VoidCallback onAccept;

  const _ContenedorPuntoLimpio({
    required this.color,
    required this.imagen,
    required this.nombre,
    required this.objetos,
    required this.todosLosObjetos,
    required this.onAccept,
  });

  @override
  State<_ContenedorPuntoLimpio> createState() =>
      _ContenedorPuntoLimpioState();
}

class _ContenedorPuntoLimpioState
    extends State<_ContenedorPuntoLimpio> {
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

      builder: (
        BuildContext context,
        List<String?> candidateData,
        List<dynamic> rejectedData,
      ) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          transform: Matrix4.translationValues(
            0,
            isHovering ? -8 : 0,
            0,
          ),

          width: 175,
          height: 225,

          decoration: BoxDecoration(
            color: isHovering
                ? widget.color.withValues(alpha: 0.18)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(25),

            border: Border.all(
              color: isHovering
                  ? widget.color
                  : Colors.transparent,
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
                width: 165,
                height: 165,

                child: Stack(
                  alignment: Alignment.center,

                  children: [
                    Image.asset(
                      widget.imagen,
                      width: 165,
                      height: 165,
                      fit: BoxFit.contain,
                    ),

                    // ÚLTIMO OBJETO CORRECTO
                    if (widget.objetos.isNotEmpty)
                      Image.asset(
                        _buscarImagenObjeto(
                          widget.objetos.last,
                        ),
                        width: 55,
                        height: 55,
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 2),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),

                child: Text(
                  widget.nombre,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: GoogleFonts.quicksand(
                    fontSize: 14,
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


  // BUSCAR IMAGEN DEL OBJETO
  String _buscarImagenObjeto(String nombre) {
    final objeto = widget.todosLosObjetos.firstWhere(
      (objeto) => objeto['nombre'] == nombre,
      orElse: () => {},
    );

    return objeto['imagen'] ?? '';
  }
}
