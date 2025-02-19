import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'infrastructure/repository/impl_repo_usuario.dart';
import 'ui/app.dart';
import 'ui/layouts/home/providers/home_provider.dart';
import 'utils/globals.dart';

void main() async {
  // Línea necesaria cuando hacemos un await dentro de el main.
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy(); // Elimina el símbolo '#' en la url.

  // Cargamos variables de entorno.
  await dotenv.load(fileName: 'dot.env');

  // Cargamos las inyecciones de dependencias.
  dependencias.registerSingleton(ImplRepoUsuario());

  runApp(
    ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: const App(),
    ),
  );
}
