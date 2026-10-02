import 'package:flutter/material.dart';

class GameService {

  
  // Buscar imagen de un objeto por nombre del objeto
  String? imagenDelObjeto(String? nombre, List<Map<String,String>> objetos) {
    if (nombre == null) {
      return null;
    }

    for (final objeto in objetos) {
      if (objeto['nombre'] == nombre) {
        return objeto['imagen'];
      }
    }

    return null;
  }

  // Buscar imagen del contenedor
  String imagenContenedor(String contenedor) {
    switch (contenedor) {
      case 'amarillo':
        return 'assets/icons/contenedores/basura-amarilla.png';
      case 'azul':
        return 'assets/icons/contenedores/basura-azul.png';
      case 'verde':
        return 'assets/icons/contenedores/basura-verde.png';
      case 'marrón':
        return 'assets/icons/contenedores/basura-marron.png';
      case 'gris':
        return 'assets/icons/contenedores/basura-gris.png';
      default:
        return '';
    }

    
   
  }

  String nombreContenedor(String contenedor) {
    switch (contenedor) {
      case 'amarillo':
        return 'amarillo';
      case 'azul':
        return 'azul';
      case 'verde':
        return 'verde';
      case 'marrón':
        return 'marrón';
      case 'gris':
        return 'gris';
      default:
        return contenedor;
    }
  }

  Color colorContenedor(String contenedor) {
    switch (contenedor) {
      case 'amarillo':
        return const Color(0xFFFFD740);
      case 'azul':
        return const Color(0xFF42A5F5);
      case 'verde':
        return const Color(0xFF66BB6A);
      case 'marrón':
        return const Color.fromARGB(255, 170, 119, 77);
      case 'gris':
        return const Color.fromARGB(255, 188, 185, 182);
      default:
        return const Color(0xFF298133);
    }
  }


  
  List<Map<String, String>> getObjetosPrimerNivel() {
    return
    [
    {
      'articulo': 'La',
      'nombre': 'botella de plástico',
      'imagen': 'assets/icons/objetos/amarillo/botella-de-plastico.png',
      'contenedor': 'amarillo',
    },
    {
      'articulo': 'El',
      'nombre': 'avión de papel',
      'imagen': 'assets/icons/objetos/azul/avion-de-papel.png',
      'contenedor': 'azul',
    },
    {
      'articulo': 'La',
      'nombre': 'botella de vidrio',
      'imagen': 'assets/icons/objetos/verde/botella-de-vidrio.png',
      'contenedor': 'verde',
    },
    {
      'articulo': 'El',
      'nombre': 'papel de regalo',
      'imagen': 'assets/icons/objetos/azul/papel-de-regalo.png',
      'contenedor': 'azul',
    },
  ];
  }

  List<Map<String, String>> getObjetosSegundoNivel() {
    return
    [
    {
      'articulo': 'El',
      'nombre': 'plátano',
      'imagen': 'assets/icons/objetos/marron/platano.png',
      'contenedor': 'marrón',
    },
    {
      'articulo': 'La',
      'nombre': 'espina',
      'imagen': 'assets/icons/objetos/marron/espina-de-pescado.png',
      'contenedor': 'marrón',
    },
    {
      'articulo': 'El',
      'nombre': 'tarro',
      'imagen': 'assets/icons/objetos/verde/tarro-de-mermelada.png',
      'contenedor': 'verde',
    },
    {
      'articulo': 'La',
      'nombre': 'caja',
      'imagen': 'assets/icons/objetos/azul/caja.png',
      'contenedor': 'azul',
    },
    {
      'articulo': 'La',
      'nombre': 'lata',
      'imagen': 'assets/icons/objetos/amarillo/lata-de-refresco.png',
      'contenedor': 'amarillo',
    },
    ];
  }

  List<Map<String, String>> getObjetosTercerNivel() {
    return
    [
      {
      'articulo': 'La',
      'nombre': 'mascarilla',
      'imagen': 'assets/icons/objetos/gris/mascara-medica.png',
      'contenedor': 'gris',
    },
    {
      'articulo': 'La',
      'nombre': 'cerámica',
      'imagen': 'assets/icons/objetos/gris/ceramica.png',
      'contenedor': 'gris',
    },
    {
      'articulo': 'La',
      'nombre': 'tirita',
      'imagen': 'assets/icons/objetos/gris/tirita.png',
      'contenedor': 'gris',
    },
    {
      'articulo': 'El',
      'nombre': 'periódico',
      'imagen': 'assets/icons/objetos/azul/periodico.png',
      'contenedor': 'azul',
    },
    {
      'articulo': 'El',
      'nombre': 'brick de leche',
      'imagen': 'assets/icons/objetos/amarillo/leche.png',
      'contenedor': 'amarillo',
    },
    {
      'articulo': 'El',
      'nombre': 'perfume',
      'imagen': 'assets/icons/objetos/verde/perfume.png',
      'contenedor': 'verde',
    },
    {
      'articulo': 'La',
      'nombre': 'manzana',
      'imagen': 'assets/icons/objetos/marron/manzana.png',
      'contenedor': 'marrón',
    },
  ];
  }

  List<Map<String,String>> getObjetosPrimerNivelPuntoLimpio(){
    return
    [
    {
      'articulo': 'El',
      'nombre': 'teléfono',
      'imagen': 'assets/icons/puntolimpio/primer_nivel/telefono-inteligente.png',
      'contenedor': 'informatica',
    },
    {
      'articulo': 'El',
      'nombre': 'microondas',
      'imagen': 'assets/icons/puntolimpio/primer_nivel/horno-microondas.png',
      'contenedor': 'electrodomesticos',
    },
    {
      'articulo': 'El',
      'nombre': 'cd',
      'imagen': 'assets/icons/puntolimpio/primer_nivel/cd.png',
      'contenedor': 'dvd',
    },
    {
      'articulo': 'La',
      'nombre': 'bombilla',
      'imagen': 'assets/icons/puntolimpio/primer_nivel/bombilla.png',
      'contenedor': 'iluminacion',
    },
    {
      'articulo': 'La',
      'nombre': 'batería',
      'imagen': 'assets/icons/puntolimpio/primer_nivel/bateria.png',
      'contenedor': 'pilas',
    },
    {
      'articulo': 'El',
      'nombre': 'cartucho',
      'imagen': 'assets/icons/puntolimpio/primer_nivel/cartucho-de-tinta.png',
      'contenedor': 'toner',
    },
    ];
  }

  List<String> getContenedoresBotones(){
    return
    [
      'informatica',
      'electrodomesticos',
      'dvd',
      'iluminacion',
      'pilas',
      'toner',
    ];
  }

}