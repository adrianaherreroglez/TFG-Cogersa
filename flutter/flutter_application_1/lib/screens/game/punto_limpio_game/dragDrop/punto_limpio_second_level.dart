
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/screens/game/service/segundo_nivel_service.dart';
import 'package:flutter_application_1/services/salas_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PuntoLimpioSecondPage extends StatefulWidget {
  final DatosPartida datosPartida;
  final int salaId;

  const PuntoLimpioSecondPage({
    super.key,
    required this.datosPartida,
    required this.salaId,
  });

  @override
  State<PuntoLimpioSecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<PuntoLimpioSecondPage> {
  final GameService gameService = GameService();
  final SegundoNivel segundoNivel = SegundoNivel();
  final SalasService salasService = SalasService();

  late List<Map<String, String>> objetos;

  int indiceObjetoActual = 0;
  bool objetoVisible = true;

  final List<String> objetosMotor = [];
  final List<String> objetosJuguetes = [];
  final List<String> objetosMetal = [];
  final List<String> objetosVegetales = [];
  final List<String> objetosCapsulas = [];
  final List<String> objetosToxico = [];

  @override
  void initState() {
    super.initState();

    widget.datosPartida.cronometro.start();

    objetos = gameService.getObjetosSegundoNivelPuntoLimpio();
    objetos.shuffle(Random());
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }

  Future<void> comprobarRespuesta(String contenedor) async {
    if (indiceObjetoActual >= objetos.length) return;

    widget.datosPartida.intentos++;

    final objeto = objetoActual;
    final contenedorCorrecto = objeto['contenedor'];

    if (contenedor == contenedorCorrecto) {
      widget.datosPartida.puntos +=
          segundoNivel.sumarPuntosRespuestaCorrecta();

      setState(() {
        if (contenedor == 'motor') {
          objetosMotor
            ..clear()
            ..add(objeto['nombre']!);
        } else if (contenedor == 'juguetes') {
          objetosJuguetes
            ..clear()
            ..add(objeto['nombre']!);
        } else if (contenedor == 'metal') {
          objetosMetal
            ..clear()
            ..add(objeto['nombre']!);
        } else if (contenedor == 'vegetales') {
          objetosVegetales
            ..clear()
            ..add(objeto['nombre']!);
        } else if (contenedor == 'capsulas') {
          objetosCapsulas
            ..clear()
            ..add(objeto['nombre']!);
        } else if (contenedor == 'toxico') {
          objetosToxico
            ..clear()
            ..add(objeto['nombre']!);
        }

        indiceObjetoActual++;
        objetoVisible = indiceObjetoActual < objetos.length;
      });

      // FIN DEL NIVEL
      if (indiceObjetoActual >= objetos.length) {
        widget.datosPartida.cronometro.stop();

        final tiempoSegundos =
            widget.datosPartida.cronometro.elapsed.inSeconds;

        await salasService.guardarResultado(
          salaId: widget.salaId,
          puntos: widget.datosPartida.puntos < 0
              ? 0
              : widget.datosPartida.puntos,
          tiempoSegundos: tiempoSegundos,
          intentos: widget.datosPartida.intentos,
        );

        if (!mounted) return;

        _irAClasificacion();
      }
    } else {
      setState(() {
        objetoVisible = true;

        widget.datosPartida.puntos -=
            segundoNivel.restarPuntosRespuestaIncorrecta();
      });
    }
  }

  
  void _irAClasificacion() {
    context.go(
      '/clasificacion',
      extra: {
        'salaId': widget.salaId,
        'esAnfitrion': false,
        'datosPartida': widget.datosPartida,
      },
    );
  }


  Widget _chipNivel(bool movil) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: movil ? 12 : 22,
        vertical: movil ? 8 : 10,
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
            size: movil ? 18 : 22,
          ),
          SizedBox(width: movil ? 5 : 8),
          Text(
            'NIVEL 2',
            style: GoogleFonts.quicksand(
              fontSize: movil ? 13 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF298133),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipPuntos(bool movil) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: movil ? 12 : 22,
        vertical: movil ? 8 : 10,
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
            size: movil ? 20 : 25,
          ),
          SizedBox(width: movil ? 5 : 7),
          Text(
            '${widget.datosPartida.puntos} puntos',
            style: GoogleFonts.quicksand(
              fontSize: movil ? 13 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D7A61),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titulo(bool movil) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '¡RECICLA ESTE OBJETO!',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: movil ? 23 : 32,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF298133),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Arrastra el objeto hasta el contenedor correcto',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: movil ? 12 : 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF5D7A61),
          ),
        ),
      ],
    );
  }

  Widget _cabecera(bool movil) {
    if (movil) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _chipNivel(true),
              _chipPuntos(true),
            ],
          ),
          const SizedBox(height: 10),
          _titulo(true),
        ],
      );
    }

    return SizedBox(
      height: 75,
      child: Row(
        children: [
          _chipNivel(false),
          const SizedBox(width: 15),
          Expanded(
            child: _titulo(false),
          ),
          const SizedBox(width: 15),
          _chipPuntos(false),
        ],
      ),
    );
  }


  Widget _zonaObjeto(bool movil) {
    final double tamano = movil ? 85 : 140;

    return SizedBox(
      height: movil ? 115 : 230,
      width: double.infinity,
      child: Center(
        child: objetoVisible && indiceObjetoActual < objetos.length
            ? _ObjetoArrastrable(
                imagen: objetoActual['imagen']!,
                nombre: objetoActual['nombre']!,
                tamano: tamano,
              )
            : const SizedBox(),
      ),
    );
  }


  Widget _contenedores(bool movil, double anchoDisponible) {
    const double separacion = 8;

    // Tres columnas en móvil y tablet.
    // Seis columnas en escritorio amplio.
    final int columnas = movil
        ? 3
        : anchoDisponible >= 1120
            ? 6
            : 3;

    final double anchoContenedor = min(
      175.0,
      (anchoDisponible - separacion * (columnas - 1)) / columnas,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: separacion,
      runSpacing: movil ? 5 : 18,
      children: [
        _crearContenedor(
          'ACEITE DE MOTOR',
          objetosMotor,
          'motor',
          anchoContenedor,
        ),
        _crearContenedor(
          'JUGUETES',
          objetosJuguetes,
          'juguetes',
          anchoContenedor,
        ),
        _crearContenedor(
          'METAL HOGAR',
          objetosMetal,
          'metal',
          anchoContenedor,
        ),
        _crearContenedor(
          'ACEITES VEGETALES',
          objetosVegetales,
          'vegetales',
          anchoContenedor,
        ),
        _crearContenedor(
          'CÁPSULAS',
          objetosCapsulas,
          'capsulas',
          anchoContenedor,
        ),
        _crearContenedor(
          'TÓXICO HOGAR',
          objetosToxico,
          'toxico',
          anchoContenedor,
        ),
      ],
    );
  }

  Widget _crearContenedor(
    String nombre,
    List<String> listaObjetos,
    String identificador,
    double ancho,
  ) {
    return _ContenedorPuntoLimpio(
      ancho: ancho,
      color: const Color.fromARGB(255, 167, 164, 154),
      imagen: 'assets/icons/contenedores/contenedor-de-basura.png',
      nombre: nombre,
      objetos: listaObjetos,
      todosLosObjetos: objetos,
      onAccept: () {
        comprobarRespuesta(identificador);
      },
    );
  }

  
  Widget _cuerpo(double ancho) {
    final bool movil = ancho < 800;

    final double paddingHorizontal = movil ? 8 : 45;

    final double anchoContenido = max(
      0,
      ancho - paddingHorizontal * 2,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        paddingHorizontal,
        movil ? 8 : 10,
        paddingHorizontal,
        movil ? 8 : 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _cabecera(movil),
          SizedBox(height: movil ? 5 : 5),
          _zonaObjeto(movil),
          SizedBox(height: movil ? 2 : 5),
          _contenedores(movil, anchoContenido),
        ],
      ),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return _cuerpo(constraints.maxWidth);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// OBJETO ARRASTRABLE
// ===========================================================================

class _ObjetoArrastrable extends StatelessWidget {
  final String imagen;
  final String nombre;
  final double tamano;

  const _ObjetoArrastrable({
    required this.imagen,
    required this.nombre,
    required this.tamano,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: nombre,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(
          imagen,
          width: tamano * 0.75,
          height: tamano * 0.75,
          fit: BoxFit.contain,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: _ObjetoVisual(
          imagen: imagen,
          tamano: tamano,
        ),
      ),
      child: _ObjetoVisual(
        imagen: imagen,
        tamano: tamano,
      ),
    );
  }
}

// ===========================================================================
// VISUAL DEL OBJETO
// ===========================================================================

class _ObjetoVisual extends StatelessWidget {
  final String imagen;
  final double tamano;

  const _ObjetoVisual({
    required this.imagen,
    required this.tamano,
  });

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
        fit: BoxFit.contain,
      ),
    );
  }
}

// ===========================================================================
// CONTENEDOR DEL PUNTO LIMPIO
// ===========================================================================

class _ContenedorPuntoLimpio extends StatefulWidget {
  final Color color;
  final String imagen;
  final String nombre;

  final List<String> objetos;
  final List<Map<String, String>> todosLosObjetos;

  final VoidCallback onAccept;
  final double ancho;

  const _ContenedorPuntoLimpio({
    required this.color,
    required this.imagen,
    required this.nombre,
    required this.objetos,
    required this.todosLosObjetos,
    required this.onAccept,
    required this.ancho,
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
    final bool movil = widget.ancho < 130;

    final double alto = movil
        ? widget.ancho * 1.15
        : widget.ancho * 225 / 175;

    final double tamanoImagen = movil
        ? widget.ancho * 0.82
        : widget.ancho * 165 / 175;

    final double tamanoObjeto = movil
        ? widget.ancho * 0.28
        : widget.ancho * 55 / 175;

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        setState(() {
          isHovering = true;
        });

        return true;
      },
      onLeave: (_) {
        if (mounted) {
          setState(() {
            isHovering = false;
          });
        }
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
            isHovering ? -3 : 0,
            0,
          ),
          width: widget.ancho,
          height: alto,
          decoration: BoxDecoration(
            color: isHovering
                ? widget.color.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovering
                  ? widget.color
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
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
                      Image.asset(
                        _buscarImagenObjeto(widget.objetos.last),
                        width: tamanoObjeto,
                        height: tamanoObjeto,
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SizedBox(
                  width: widget.ancho - 4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.nombre,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.quicksand(
                        fontSize: movil ? 10 : 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF298133),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _buscarImagenObjeto(String nombre) {
    final objeto = widget.todosLosObjetos.firstWhere(
      (objeto) => objeto['nombre'] == nombre,
      orElse: () => {},
    );

    return objeto['imagen'] ?? '';
  }
}
