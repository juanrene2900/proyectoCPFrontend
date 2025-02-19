import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../rutas/rutas.dart';
import '../tokens/colores.dart';

class App extends StatelessWidget {
  const App({super.key});

  // MaterialApp es un tipo de app que usa los patrones de diseño de Android.
  // Si queremos usar el de iOS usamos CupertinoApp.
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        // El título de la app. En este caso es visible en la pestaña del navegador.
        title: 'Sistema Admin - Clientes',
        // Ocultamos el banner 'debug' que aparece en la parte superior derecha.
        debugShowCheckedModeBanner: false,
        // Configuración de estilos.
        theme: ThemeData(
          // La paleta de colores.
          // Al usar ColorScheme.fromSeed creamos una paleta desde un solo color base.
          // En este caso usamos el color primario de la app => primaryColor.
          colorScheme: ColorScheme.fromSeed(seedColor: colorPrimario),
          // Usamos Material3 para tener una interfaz de usuario más bonita.
          useMaterial3: true,
          // Fuente de letra personalizada.
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        // Configuramos las rutas.
        routerConfig: rutas,
      );
}
