class GameService {
  
  // Buscar imagen de un objeto
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
  
  List<Map<String, String>> getObjetosPrimerNivel() {
    return
    [
    {
      'nombre': 'botella',
      'imagen': 'assets/icons/objetos/amarillo/botella-de-plastico.png',
      'contenedor': 'amarillo',
    },
    {
      'nombre': 'avion',
      'imagen': 'assets/icons/objetos/azul/avion-de-papel.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'botella de vidrio',
      'imagen': 'assets/icons/objetos/verde/botella-de-vidrio.png',
      'contenedor': 'verde',
    },
    {
      'nombre': 'papel-regalo',
      'imagen': 'assets/icons/objetos/azul/papel-de-regalo.png',
      'contenedor': 'azul',
    },
  ];
  }

  List<Map<String, String>> getObjetosSegundoNivel() {
    return
    [
      {
      'nombre': 'platano',
      'imagen': 'assets/icons/objetos/marron/platano.png',
      'contenedor': 'marron',
    },
    {
      'nombre': 'espina',
      'imagen': 'assets/icons/objetos/marron/espina-de-pescado.png',
      'contenedor': 'marron',
    },
    {
      'nombre': 'tarro',
      'imagen': 'assets/icons/objetos/verde/tarro-de-mermelada.png',
      'contenedor': 'verde',
    },
    {
      'nombre': 'caja',
      'imagen': 'assets/icons/objetos/azul/caja.png',
      'contenedor': 'azul',
    },
    {
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
      'nombre': 'toallitas',
      'imagen': 'assets/icons/objetos/gris/toallitas.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'ceramica',
      'imagen': 'assets/icons/objetos/gris/ceramica.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'tirita',
      'imagen': 'assets/icons/objetos/gris/tirita.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'periodico',
      'imagen': 'assets/icons/objetos/azul/periodico.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'leche',
      'imagen': 'assets/icons/objetos/amarillo/leche.png',
      'contenedor': 'amarillo',
    },
    {
      'nombre': 'perfume',
      'imagen': 'assets/icons/objetos/verde/perfume.png',
      'contenedor': 'verde',
    },
    {
      'nombre': 'manzana',
      'imagen': 'assets/icons/objetos/marron/manzana.png',
      'contenedor': 'marron',
    },
  ];
  }

}
