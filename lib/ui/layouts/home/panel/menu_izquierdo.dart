import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../enums/vista_panel.dart';
import '../providers/home_provider.dart';
import '../providers/panel_provider.dart';

class MenuIzquierdo extends StatelessWidget {
  const MenuIzquierdo({super.key});

  @override
  Widget build(BuildContext context) {
    final panel = Provider.of<PanelProvider>(context, listen: false);

    return SizedBox(
      width: 300,
      child: Column(
        children: [
          const _Encabezado(),
          const Gutter(),
          ListTile(
            onTap: () => panel.actualizarListaPanel(VistaPanel.crearCliente),
            title: const Text('Crear cliente'),
            leading: const Icon(Icons.add),
          ),
          const Divider(),
          ListTile(
            onTap: () => panel.actualizarListaPanel(VistaPanel.listarClientes),
            title: const Text('Listar clientes'),
            leading: const Icon(Icons.list),
          ),
          const Spacer(),
          const BtnCerrarSesion(),
        ],
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    return ListTile(
      title: Text(provider.user!.nombresYApellidos),
      subtitle: Text(provider.user!.email),
      // Mostramos un Avatar como adorno que toma la primera letra del usuario.
      // Si no existe el nombre usamos la letra 'U' (de 'Usuario') por defecto.
      leading: CircleAvatar(
        child: Text(
          provider.user!.nombresYApellidos.toArray.firstOrNull ?? 'U',
        ),
      ),
    );
  }
}

class BtnCerrarSesion extends StatelessWidget {
  const BtnCerrarSesion();

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () => _cerrarSesion(context),
        title: const Text('Cerrar sesión'),
        leading: const Icon(Icons.exit_to_app),
      );

  void _cerrarSesion(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    // ¡La vista de login se volverá a mostrar!
    provider.eliminarSesionAdmin();
  }
}
