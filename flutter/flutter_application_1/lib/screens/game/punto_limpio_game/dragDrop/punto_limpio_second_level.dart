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
      runSpacing: movil ? 8 : 18,
      children: [
        _crearContenedor(
          7,
          'ACEITE DE MOTOR',
          objetosMotor,
          'motor',
          anchoContenedor,
        ),
        _crearContenedor(
          8,
          'JUGUETES',
          objetosJuguetes,
          'juguetes',
          anchoContenedor,
        ),
        _crearContenedor(
          9,
          'METAL HOGAR',
          objetosMetal,
          'metal',
          anchoContenedor,
        ),
        _crearContenedor(
          10,
          'ACEITES VEGETALES',
          objetosVegetales,
          'vegetales',
          anchoContenedor,
        ),
        _crearContenedor(
          11,
          'CÁPSULAS',
          objetosCapsulas,
          'capsulas',
          anchoContenedor,
        ),
        _crearContenedor(
          12,
          'TÓXICO HOGAR',
          objetosToxico,
          'toxico',
          anchoContenedor,
        ),
      ],
    );
  }

  Widget _crearContenedor(
    int numero,
    String nombre,
    List<String> listaObjetos,
    String identificador,
    double ancho,
  ) {
    return _ContenedorPuntoLimpio(
      numero: numero,
      nombre: nombre,
      objetos: listaObjetos,
      todosLosObjetos: objetos,
      ancho: ancho,
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
//
// Un botón grande azul marino con:
//   1. el nombre del contenedor (blanco, ajustado para que quepa),
//   2. una tapa metálica que se desliza hacia la izquierda al acercar
//      un objeto,
//   3. debajo, una bandeja que muestra siempre el último objeto colocado,
//   4. al final, el número del contenedor (1-6) en un círculo azul eléctrico.
//
// Todas las medidas se calculan a partir del ancho, así que se adapta a
// cualquier pantalla.
// ===========================================================================

class _ContenedorPuntoLimpio extends StatefulWidget {
  final int numero;
  final String nombre;

  final List<String> objetos;
  final List<Map<String, String>> todosLosObjetos;

  final double ancho;

  final VoidCallback onAccept;

  const _ContenedorPuntoLimpio({
    required this.numero,
    required this.nombre,
    required this.objetos,
    required this.todosLosObjetos,
    required this.ancho,
    required this.onAccept,
  });

  @override
  State<_ContenedorPuntoLimpio> createState() =>
      _ContenedorPuntoLimpioState();
}

class _ContenedorPuntoLimpioState extends State<_ContenedorPuntoLimpio> {
  bool isHovering = false;

  // Colores
  static const Color azulMarino = Color(0xFF0B1F4B);
  static const Color azulMarinoClaro = Color(0xFF173A85);
  static const Color azulElectrico = Color(0xFF0057FF);

  @override
  Widget build(BuildContext context) {
    final double a = widget.ancho;

    final double alto = a * 1.45;
    final double relleno = a * 0.07;

    final double anchoTexto = a - relleno * 2;
    final double altoTexto = a * 0.30;
    final double tamanoFuente = a * 0.10;

    final double anchoTapa = a * 0.80;
    final double altoTapa = a * 0.20;

    final double diametroNumero = a * 0.28;

    final double altoBandeja = a * 0.34;

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
        // El tamaño va en un SizedBox (cambia al instante al redimensionar);
        // la animación se limita al borde, la sombra y el movimiento.
        return SizedBox(
          width: a,
          height: alto,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            transform: Matrix4.translationValues(
              0,
              isHovering ? -4 : 0,
              0,
            ),
            padding: EdgeInsets.all(relleno),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [azulMarinoClaro, azulMarino],
              ),
              borderRadius: BorderRadius.circular(a * 0.16),
              border: Border.all(
                color: isHovering
                    ? azulElectrico
                    : Colors.white.withValues(alpha: 0.12),
                width: isHovering ? 3 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHovering
                      ? azulElectrico.withValues(alpha: 0.55)
                      : Colors.black.withValues(alpha: 0.28),
                  blurRadius: isHovering ? 18 : 10,
                  offset: Offset(0, isHovering ? 8 : 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. TEXTO (se divide en líneas y se reduce si no cabe)
                SizedBox(
                  width: anchoTexto,
                  height: altoTexto,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: anchoTexto),
                        child: Text(
                          widget.nombre,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: tamanoFuente,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. TAPA METÁLICA
                _tapa(anchoTapa, altoTapa),

                // 3. ÚLTIMO OBJETO COLOCADO (siempre visible)
                _bandeja(anchoTexto, altoBandeja),

                // 4. NÚMERO
                _numero(diametroNumero),
              ],
            ),
          ),
        );
      },
    );
  }

  // Tapa metálica que se desliza hacia la izquierda y deja ver el hueco
  Widget _tapa(double ancho, double alto) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(alto * 0.3),
      child: SizedBox(
        width: ancho,
        height: alto,
        child: Stack(
          children: [
            // Hueco que queda al abrir la tapa
            Positioned.fill(
              child: Container(color: const Color(0xFF050D24)),
            ),

            // Tapa metálica
            Positioned.fill(
              child: AnimatedSlide(
                offset: Offset(isHovering ? -0.85 : 0, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF4F6F8),
                        Color(0xFFB9C0C9),
                        Color(0xFFE8EBEF),
                        Color(0xFF9AA2AD),
                      ],
                      stops: [0.0, 0.45, 0.7, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(alto * 0.3),
                    border: Border.all(
                      color: const Color(0xFF7C8591),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    // Ranura / asa de la tapa
                    child: Container(
                      width: ancho * 0.45,
                      height: alto * 0.14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C8591),
                        borderRadius: BorderRadius.circular(alto),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Número del contenedor: blanco, dentro de un círculo azul eléctrico
  Widget _numero(double diametro) {
    return Container(
      width: diametro,
      height: diametro,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: azulElectrico,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: azulElectrico.withValues(alpha: 0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        '${widget.numero}',
        style: GoogleFonts.quicksand(
          fontSize: diametro * 0.6,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }

  // Bandeja con el último objeto colocado en este contenedor.
  // Está siempre visible, con la tapa abierta o cerrada.
  Widget _bandeja(double ancho, double alto) {
    final double margen = alto * 0.10;

    return Container(
      width: ancho,
      height: alto,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(alto * 0.35),
      ),
      child: widget.objetos.isEmpty
          ? null
          : _miniObjeto(widget.objetos.last, alto - margen * 2),
    );
  }

  Widget _miniObjeto(String nombre, double tamano) {
    final String imagen = _buscarImagenObjeto(nombre);

    return SizedBox(
      width: tamano,
      height: tamano,
      child: imagen.isEmpty
          ? null
          : Image.asset(
              imagen,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
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