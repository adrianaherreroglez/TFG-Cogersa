import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/primer_nivel_service.dart';
import 'package:flutter_application_1/services/salas_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';

class JuegoTest extends StatefulWidget {
  final int salaId;
  final bool esAnfitrion;
  final DatosPartida? datosPartida;

  const JuegoTest({
    super.key,
    required this.salaId,
    required this.esAnfitrion,
    this.datosPartida,
  });

  @override
  State<JuegoTest> createState() => _JuegoTestState();
}

class PreguntaTest {
  final String pregunta;
  final List<String> opciones;
  final int respuestaCorrecta;

  const PreguntaTest({
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
  });
}

class _JuegoTestState extends State<JuegoTest> {
  static const Color fondo = Color(0xFFFAFDF4);
  static const Color verde = Color(0xFF298133);
  static const Color verdeOscuro = Color(0xFF347653);
  static const Color verdeClaro = Color(0xFFE8F5E9);
  static const Color rojo = Color(0xFFE53935);

  final PrimerNivel _nivel = PrimerNivel();
  final SalasService salasService = SalasService();

  bool _guardandoResultado = false;

  final List<PreguntaTest> _preguntas = const [
    PreguntaTest(
      pregunta: '¿Dónde debemos tirar una botella de plástico?',
      opciones: [
        'Al contenedor amarillo',
        'Al contenedor azul',
        'Al contenedor marrón',
      ],
      respuestaCorrecta: 0,
    ),
    PreguntaTest(
      pregunta: '¿Dónde se tira el papel y el cartón?',
      opciones: [
        'Al contenedor verde',
        'Al contenedor azul',
        'Al contenedor amarillo',
      ],
      respuestaCorrecta: 1,
    ),
    PreguntaTest(
      pregunta: '¿Dónde debemos tirar una botella de vidrio?',
      opciones: [
        'Al contenedor marrón',
        'Al contenedor amarillo',
        'Al contenedor verde',
      ],
      respuestaCorrecta: 2,
    ),
    PreguntaTest(
      pregunta: '¿Dónde se tiran las pieles de una manzana?',
      opciones: [
        'Al contenedor marrón',
        'Al contenedor azul',
        'Al contenedor amarillo',
      ],
      respuestaCorrecta: 0,
    ),
    PreguntaTest(
      pregunta: '¿Qué debemos hacer con una pila usada?',
      opciones: [
        'Tirarla al suelo',
        'Llevarla a un punto limpio',
        'Tirarla al contenedor azul',
      ],
      respuestaCorrecta: 1,
    ),
    PreguntaTest(
      pregunta: '¿A dónde llevamos un juguete roto?',
      opciones: [
        'Al contenedor amarillo',
        'Al contenedor verde',
        'A un punto limpio',
      ],
      respuestaCorrecta: 2,
    ),
    PreguntaTest(
      pregunta: '¿Dónde debemos tirar una lata de refresco?',
      opciones: [
        'Al contenedor amarillo',
        'Al contenedor marrón',
        'Al contenedor azul',
      ],
      respuestaCorrecta: 0,
    ),
    PreguntaTest(
      pregunta: '¿Dónde podemos reciclar una bombilla?',
      opciones: [
        'No se puede reciclar una bombilla',
        'En su correspondiente contenedor del punto limpio',
        'En el contenedor gris',
      ],
      respuestaCorrecta: 1,
    ),
    PreguntaTest(
      pregunta: '¿Qué objeto podemos reciclar en el contenedor gris?',
      opciones: ['Una revista', 'Un plato de cerámica', 'Un trozo de plástico'],
      respuestaCorrecta: 1,
    ),
    PreguntaTest(
      pregunta: '¿Qué debemos hacer con un aparato electrónico viejo?',
      opciones: [
        'Llevarlo a un punto limpio',
        'Dejarlo en la calle',
        'Tirarlo al contenedor de papel',
      ],
      respuestaCorrecta: 0,
    ),
  ];

  int _indicePregunta = 0;
  int _puntos = 0;
  int _fallos = 0;

  int? _opcionIncorrecta;
  int? _opcionCorrecta;

  bool _procesando = false;
  bool _terminado = false;

  @override
  void initState() {
    super.initState();

    final cronometro = widget.datosPartida?.cronometro;

    if (cronometro != null && !cronometro.isRunning) {
      cronometro.start();
    }
  }

  Future<void> _responder(int indiceOpcion) async {
    if (_procesando || _terminado) return;

    final pregunta = _preguntas[_indicePregunta];

    setState(() {
      _procesando = true;
    });

    if (indiceOpcion == pregunta.respuestaCorrecta) {
      setState(() {
        _puntos += _nivel.sumarPuntosRespuestaCorrecta();
        _opcionCorrecta = indiceOpcion;
      });

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      setState(() {
        _opcionCorrecta = null;

        if (_indicePregunta < _preguntas.length - 1) {
          _indicePregunta++;
          _procesando = false;
        } else {
          _terminado = true;
          _procesando = false;

          widget.datosPartida?.puntos = _puntos;
          widget.datosPartida?.intentos = _fallos;
          widget.datosPartida?.cronometro.stop();
        }
      });
    } else {
      setState(() {
        _puntos -= _nivel.restarPuntosRespuestaIncorrecta();
        _fallos++;
        _opcionIncorrecta = indiceOpcion;
      });

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      setState(() {
        _opcionIncorrecta = null;
        _procesando = false;
      });
    }
  }

  Future<void> _guardarYMostrarClasificacion() async {
    if (_guardandoResultado) return;

    setState(() {
      _guardandoResultado = true;
    });

    try {
      final partida = widget.datosPartida;

      partida?.cronometro.stop();

      final tiempoSegundos = partida?.cronometro.elapsed.inSeconds ?? 0;

      if (partida != null) {
        partida.puntos = _puntos;
        partida.intentos = _fallos;
      }

      await salasService.guardarResultado(
        salaId: widget.salaId,
        puntos: _puntos < 0 ? 0 : _puntos,
        tiempoSegundos: tiempoSegundos,
        intentos: _fallos,
      );

      if (!mounted) return;

      context.go(
        '/clasificacion',
        extra: {
          'salaId': widget.salaId,
          'esAnfitrion': widget.esAnfitrion,
          'datosPartida': partida,
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el resultado: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardandoResultado = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),
            Expanded(
              child: _terminado ? _pantallaFinal() : _pantallaPregunta(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pantallaPregunta() {
    final pregunta = _preguntas[_indicePregunta];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: _indicador(
                        Icons.stars_rounded,
                        'PUNTOS',
                        '$_puntos',
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 35,
                      ),
                      decoration: BoxDecoration(
                        color: verdeClaro,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFD8EDD5),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.recycling_rounded,
                            size: 48,
                            color: verde,
                          ),

                          const SizedBox(height: 18),

                          Text(
                            pregunta.pregunta,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: verdeOscuro,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    flex: 2,
                    child: Center(
                      child: _indicador(
                        Icons.replay_rounded,
                        'INTENTOS',
                        '$_fallos',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                'ELIGE UNA RESPUESTA',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: verdeOscuro,
                ),
              ),

              const SizedBox(height: 18),

              ...List.generate(
                pregunta.opciones.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _opcionRespuesta(
                    texto: pregunta.opciones[index],
                    indice: index,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Indicador de puntuación e intentos
  Widget _indicador(IconData icono, String titulo, String valor) {
    return Container(
      constraints: const BoxConstraints(minWidth: 135),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: verdeOscuro.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: verdeOscuro, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: verdeOscuro,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _opcionRespuesta({required String texto, required int indice}) {
    final esIncorrecta = _opcionIncorrecta == indice;
    final esCorrecta = _opcionCorrecta == indice;

    Color colorFondo = Colors.white;
    Color colorBorde = const Color(0xFFD8EDD5);
    Color colorTexto = verdeOscuro;

    if (esIncorrecta) {
      colorFondo = const Color(0xFFFFE5E5);
      colorBorde = rojo;
      colorTexto = rojo;
    } else if (esCorrecta) {
      colorFondo = const Color(0xFFE0F4E3);
      colorBorde = verde;
      colorTexto = verde;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorBorde, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _procesando ? null : () => _responder(indice),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorBorde.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    String.fromCharCode(65 + indice),
                    style: GoogleFonts.quicksand(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: colorTexto,
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Text(
                    texto,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorTexto,
                    ),
                  ),
                ),

                if (esIncorrecta) const Icon(Icons.close_rounded, color: rojo),

                if (esCorrecta)
                  const Icon(Icons.check_circle_rounded, color: verde),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pantallaFinal() {
    final aciertos = _preguntas.length;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: verdeOscuro.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 82,
                  color: Color(0xFFFFC857),
                ),

                const SizedBox(height: 16),

                Text(
                  '¡Test completado!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: verde,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Has respondido correctamente las $aciertos preguntas.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: verdeOscuro,
                  ),
                ),

                const SizedBox(height: 24),

                // Indicadores finales.
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _indicador(
                      Icons.stars_rounded,
                      'Puntuación',
                      '$_puntos puntos',
                    ),
                    _indicador(
                      Icons.replay_rounded,
                      'Intentos',
                      '$_fallos fallos',
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _guardandoResultado
                        ? null
                        : _guardarYMostrarClasificacion,
                    icon: _guardandoResultado
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.emoji_events_rounded),
                    label: Text(
                      _guardandoResultado
                          ? 'Guardando resultado...'
                          : 'Ver clasificación',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verdeOscuro,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
