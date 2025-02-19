import 'package:go_router/go_router.dart';

import '../application/res/cliente_res.dart';
import '../enums/metodo_de_autenticacion.dart';
import '../ui/layouts/cliente_layout.dart';
import '../ui/layouts/home/home_layout.dart';
import '../ui/layouts/obtener_rostro/obtener_rostro_layout.dart';
import '../ui/layouts/validar_codigo/validar_codigo_layout.dart';
import 'direcciones_rutas.dart';

final rutas = GoRouter(
  initialLocation: DireccionesRutas.inicio,
  routes: [
    GoRoute(
      name: DireccionesRutas.inicio,
      path: DireccionesRutas.inicio,
      builder: (context, _) => const HomeLayout(),
      routes: [
        GoRoute(
          name: DireccionesRutas.validarCodigo,
          path: DireccionesRutas.validarCodigo,
          builder: (context, state) => ValidarCodigoLayout(
            metodoDeAutenticacion:
                (state.extra as Map<String, dynamic>)['metodo_de_autenticacion']
                    as MetodoDeAutenticacion,
          ),
        ),
        GoRoute(
          name: DireccionesRutas.obtenerRostro,
          path: DireccionesRutas.obtenerRostro,
          builder: (context, _) => const ObtenerRostroB64Layout(),
        ),
        GoRoute(
          name: DireccionesRutas.cliente,
          path: DireccionesRutas.cliente,
          builder: (context, state) => ClienteLayout(
            cliente:
                (state.extra as Map<String, dynamic>)['cliente'] as ClienteRes,
          ),
        ),
      ],
    ),
  ],
);
