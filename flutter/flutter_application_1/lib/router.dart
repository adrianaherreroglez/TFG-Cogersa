// Clase que contiene todas las redirecciones de la aplicación

import 'package:go_router/go_router.dart';

import 'screens/home_page.dart';
import 'screens/game/first_page.dart';
import 'screens/game/third_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(
        title: 'EcoKids',
      ),
    ),

    GoRoute(
      path: '/first',
      builder: (context, state) => const FirstPage(),
    ),

    GoRoute(
      path: '/third',
      builder: (context, state) => const ThirdPage(),
    ),
    
  ],
);

