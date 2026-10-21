import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/screens/game/service/game_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';

class JuegoCartas extends StatefulWidget {
  final int salaId;
  final bool esAnfitrion;
  final DatosPartida? datosPartida;

  const JuegoCartas({
    super.key,
    required this.salaId,
    required this.esAnfitrion,
    this.datosPartida,
  });

  @override
  State<JuegoCartas> createState() => _JuegoCartasState();
}

class _Carta {
  final String imagen;
  bool descubierta;
  bool encontrada;

  _Carta({required this.imagen}) : descubierta = false, encontrada = false;
}

class _JuegoCartasState extends State<JuegoCartas> {
  static const Color fondo = Color(0xFFF6FBF5);
  // static const Color verdePastel = Color(0xFFB9E4D0);
  static const Color verdeOscuro = Color(0xFF347653);
  static const Color crema = Color(0xFFFFF8E7);

  final GameService gameService = GameService();

  final List<String> _imagenes = [
    'assets/icons/objetos/amarillo/botella-de-plastico.png',
    'assets/icons/objetos/azul/papel.png',
    'assets/icons/objetos/gris/espejo.png',
    'assets/icons/objetos/marron/manzana.png',
    'assets/icons/objetos/verde/tarro-de-mermelada.png',
    'assets/icons/objetos/amarillo/lata-de-refresco.png',
    'assets/icons/objetos/azul/caja.png',
    'assets/icons/objetos/gris/ceramica.png',
    'assets/icons/objetos/marron/espina-de-pescado.png',
    'assets/icons/objetos/verde/botella-de-vidrio.png',
  ];

  late List<_Carta> _cartas;

  int _parejasEncontradas = 0;
  int _movimientos = 0;
  bool _bloqueado = false;

  @override
  void initState() {
    super.initState();
    _prepararCartas();
  }

  void _prepararCartas() {
    final lista = [..._imagenes, ..._imagenes];
    lista.shuffle(Random());

    _cartas = lista.map((imagen) => _Carta(imagen: imagen)).toList();
  }

  void _reiniciarJuego() {
    setState(() {
      _prepararCartas();
      _parejasEncontradas = 0;
      _movimientos = 0;
      _bloqueado = false;
    });
  }

  Future<void> _seleccionarCarta(int indice) async {
    if (_bloqueado ||
        _cartas[indice].descubierta ||
        _cartas[indice].encontrada) {
      return;
    }

    setState(() {
      _cartas[indice].descubierta = true;
    });

    final descubiertas = <int>[];

    for (int i = 0; i < _cartas.length; i++) {
      if (_cartas[i].descubierta && !_cartas[i].encontrada) {
        descubiertas.add(i);
      }
    }

    if (descubiertas.length != 2) return;

    final primera = descubiertas[0];
    final segunda = descubiertas[1];

    setState(() {
      _movimientos++;
      _bloqueado = true;
    });

    if (_cartas[primera].imagen == _cartas[segunda].imagen) {
      await Future.delayed(const Duration(milliseconds: 350));

      if (!mounted) return;

      setState(() {
        _cartas[primera].encontrada = true;
        _cartas[segunda].encontrada = true;
        _parejasEncontradas++;
        _bloqueado = false;
      });

      if (_parejasEncontradas == _imagenes.length) {
        _mostrarVictoria();
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 850));

      if (!mounted) return;

      setState(() {
        _cartas[primera].descubierta = false;
        _cartas[segunda].descubierta = false;
        _bloqueado = false;
      });
    }
  }

  void _mostrarVictoria() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: fondo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              size: 64,
              color: Color(0xFFFFC857),
            ),
            const SizedBox(height: 12),
            const Text(
              '¡Lo has conseguido!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: verdeOscuro,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Has encontrado todas las parejas en $_movimientos movimientos.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeOscuro,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _reiniciarJuego();
              },
              child: const Text('Volver a jugar'), // cambiar a ir a clasificacion
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _indicador(
                    Icons.touch_app_rounded,
                    'Movimientos',
                    '$_movimientos',
                  ),
                  const Spacer(),
                  _indicador(
                    Icons.favorite_rounded,
                    'Parejas',
                    '$_parejasEncontradas/${_imagenes.length}',
                  ),
                ],
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const columnas = 4;
                  const filas = 5;
                  const separacion = 8.0;
                  const margen = 12.0;

                  final anchoDisponible = constraints.maxWidth - margen * 2;

                  final altoDisponible = constraints.maxHeight - margen * 2;

                  final anchoCarta =
                      (anchoDisponible - separacion * (columnas - 1)) /
                      columnas;

                  final altoCarta =
                      (altoDisponible - separacion * (filas - 1)) / filas;

                  final anchoFinal = min(anchoCarta, altoCarta * 0.9);

                  final altoFinal = anchoFinal / 0.9;

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(margen),
                      child: SizedBox(
                        width:
                            anchoFinal * columnas + separacion * (columnas - 1),
                        height: altoFinal * filas + separacion * (filas - 1),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columnas,
                                crossAxisSpacing: separacion,
                                mainAxisSpacing: separacion,
                                childAspectRatio: 0.9,
                              ),
                          itemCount: _cartas.length,
                          itemBuilder: (context, index) {
                            final carta = _cartas[index];
                            final visible =
                                carta.descubierta || carta.encontrada;

                            return CartaAnimada(
                              key: ValueKey('carta_$index'),
                              visible: visible,
                              imagen: carta.imagen,
                              color: carta.encontrada
                                  ? gameService.obtenerColorContenedor(
                                      carta.imagen,
                                    )
                                  : crema,
                              encontrada: carta.encontrada,
                              onTap: () => _seleccionarCarta(index),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

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
}

class CartaAnimada extends StatelessWidget {
  final bool visible;
  final String imagen;
  final Color color;
  final bool encontrada;
  final VoidCallback onTap;

  const CartaAnimada({
    super.key,
    required this.visible,
    required this.imagen,
    required this.color,
    required this.encontrada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final giro = Tween<double>(begin: pi, end: 0).animate(animation);

          return AnimatedBuilder(
            animation: giro,
            child: child,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(giro.value),
                child: child,
              );
            },
          );
        },
        child: Container(
          key: ValueKey(visible),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: visible
                  ? [color, Color.lerp(color, Colors.white, 0.22)!]
                  : [const Color(0xFFB9E4D0), const Color(0xFFDEF3E7)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF467A62).withValues(alpha: 0.15),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(5),
          child: visible
              ? Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        imagen,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.recycling_rounded,
                          size: 28,
                          color: Color(0xFF477C61),
                        ),
                      ),
                    ),
                    if (encontrada)
                      const Positioned(
                        top: 1,
                        right: 1,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: Color(0xFF347653),
                        ),
                      ),
                  ],
                )
              : const Center(
                  child: Icon(
                    Icons.eco_rounded,
                    size: 30,
                    color: Color(0xFF347653),
                  ),
                ),
        ),
      ),
    );
  }
}
