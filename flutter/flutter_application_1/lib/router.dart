// Clase que contiene todas las redirecciones de la aplicación

import 'package:go_router/go_router.dart';

import 'screens/home_page.dart';
import 'screens/first_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(
        title: 'Home Page',
      ),
    ),

    GoRoute(
      path: '/first',
      builder: (context, state) => const FirstPage(),
    ),
  ],
);

