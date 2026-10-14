import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  static const green = Color(0xFF218838);
  static const darkGreen = Color(0xFF17652B);
  static const background = Color(0xFFFFF9E9);

  late AnimationController _planetController;
  late AnimationController _entranceController;
  late AnimationController _starsController;
  late AnimationController _buttonController;

  late Animation<double> _planetAnimation;
  // ignore: unused_field
  late Animation<double> _entranceAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    // El planeta rebota continuamente.
    _planetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _planetAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(
      CurvedAnimation(
        parent: _planetController,
        curve: Curves.easeInOut,
      ),
    );

    // Aparición progresiva del contenido.
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutBack,
    );

    // Movimiento de las decoraciones.
    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Animación al pulsar el botón.
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0,
      upperBound: 0.06,
    );

    _buttonAnimation = Tween<double>(
      begin: 1,
      end: 0.94,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _planetController.dispose();
    _entranceController.dispose();
    _starsController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Widget _appear({
    required double delay,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, _) {
        final progress = ((_entranceController.value - delay) /
                (1 - delay))
            .clamp(0.0, 1.0);

        final curved = Curves.easeOutCubic.transform(progress);

        return Opacity(
          opacity: curved,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - curved)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            // Estrellas y decoraciones animadas.
            Positioned(
              top: 35,
              left: 24,
              child: _floatingEmoji('🌼', 38, 0),
            ),
            Positioned(
              top: 75,
              right: 30,
              child: _floatingEmoji('⭐', 32, 1),
            ),
            Positioned(
              bottom: 80,
              left: 25,
              child: _floatingEmoji('🌱', 38, 2),
            ),
            Positioned(
              bottom: 105,
              right: 25,
              child: _floatingEmoji('♻️', 35, 3),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Planeta que rebota.
                      _appear(
                        delay: 0.08,
                        child: AnimatedBuilder(
                          animation: _planetAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                _planetAnimation.value,
                              ),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 156,
                            height: 156,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC9F0B7),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 7,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x263D8B40),
                                  blurRadius: 0,
                                  offset: Offset(0, 7),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '🌎',
                                style: TextStyle(fontSize: 91),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Título animado.
                      _appear(
                        delay: 0.15,
                        child: Text(
                          'EcoKids',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 58,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                            color: green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _appear(
                        delay: 0.25,
                        child: Text(
                          '¡Aprender puede ser una aventura!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF754C24),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _appear(
                        delay: 0.32,
                        child: Text(
                          'Juega, recicla y descubre cómo salvar nuestro planeta.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF69604F),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Botón que se encoge al pulsarlo.
                      _appear(
                        delay: 0.55,
                        child: AnimatedBuilder(
                          animation: _buttonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _buttonAnimation.value,
                              child: child,
                            );
                          },
                          child: GestureDetector(
                            onTapDown: (_) {
                              _buttonController.forward();
                            },
                            onTapUp: (_) {
                              _buttonController.reverse();
                              context.go('/login');
                            },
                            onTapCancel: () {
                              _buttonController.reverse();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 62,
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: darkGreen,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x553D8B40),
                                    offset: Offset(0, 5),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¡EMPEZAR!',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.play_circle_fill_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingEmoji(String emoji, double size, int seed) {
    return AnimatedBuilder(
      animation: _starsController,
      builder: (context, child) {
        final phase = _starsController.value * 2 * math.pi;
        final offset = math.sin(phase + seed) * 9;

        return Transform.translate(
          offset: Offset(0, offset),
          child: Transform.rotate(
            angle: math.sin(phase + seed) * 0.12,
            child: child,
          ),
        );
      },
      child: Text(
        emoji,
        style: TextStyle(fontSize: size),
      ),
    );
  }
}

class _ActivityCard extends StatefulWidget {
  const _ActivityCard({
    required this.emoji,
    required this.label,
    required this.color,
  });

  final String emoji;
  final String label;
  final Color color;

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 31),
              ),
              const SizedBox(height: 7),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF315B36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
