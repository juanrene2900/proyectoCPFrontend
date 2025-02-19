import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_admin_clientes/ui/layouts/home/panel/menu_izquierdo.dart';
import 'package:sistema_admin_clientes/ui/layouts/home/recuperar_contrasena/recuperar_contrasena_view.dart';

import '../../../enums/rol.dart';
import 'crear_usuario/vista_crear_usuario.dart';
import 'login/vista_iniciar_sesion.dart';
import 'panel/panel_admin.dart';
import 'providers/home_provider.dart';

/// Ya que el login de un Admin o Cliente utilizan el mismo flujo,
/// se reutiliza esta clase.
class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  _EstadoLogin _estadoLogin = _EstadoLogin.iniciandoSesion;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<HomeProvider>(
            builder: (_, provider, __) {
              // Si el Admin ha iniciado sesión, entonces mostramos el panel o dashboard.
              if (provider.user != null) {
                if (provider.user!.rol == Rol.admin) {
                  return PanelAdmin();
                } else {
                  // Solo hay 2 roles.
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Text(
                          'Hola, ${provider.user!.nombresYApellidos}',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: BtnCerrarSesion(),
                        ),
                      ],
                    ),
                  );
                }
              }

              if (_estadoLogin == _EstadoLogin.iniciandoSesion) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: VistaIniciarSesion(
                      eventoBotonCrearCuenta: () => setState(
                        () => _estadoLogin = _EstadoLogin.creandoCuenta,
                      ),
                      eventoRecuperarContrasena: () => setState(
                        () => _estadoLogin = _EstadoLogin.recuperandoContrasena,
                      ),
                    ),
                  ),
                );
              } else if (_estadoLogin == _EstadoLogin.creandoCuenta) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: VistaCrearUsuario(
                      eventoBotonIniciarSesion: () => setState(
                        () => _estadoLogin = _EstadoLogin.iniciandoSesion,
                      ),
                    ),
                  ),
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: RecuperarContrasenaView(
                    eventoBotonIniciarSesion: () => setState(
                      () => _estadoLogin = _EstadoLogin.iniciandoSesion,
                    ),
                    eventoContrasenaRestablecida: () => setState(
                      () => _estadoLogin = _EstadoLogin.iniciandoSesion,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

enum _EstadoLogin {
  iniciandoSesion,
  creandoCuenta,
  recuperandoContrasena,
}
