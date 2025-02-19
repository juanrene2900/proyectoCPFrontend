import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../enums/rol.dart';
import '../../../../enums/vista_panel.dart';
import '../crear_usuario/vista_formulario_crear_usuario.dart';
import '../providers/panel_provider.dart';
import 'menu_izquierdo.dart';
import 'vista_panel_listar_clientes.dart';

class PanelAdmin extends StatelessWidget {
  const PanelAdmin({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => PanelProvider(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            const MenuIzquierdo(),
            Expanded(
              child: Consumer<PanelProvider>(
                builder: (context, panel, _) => switch (panel.vistaPanel) {
                  VistaPanel.crearCliente => const VistaFormularioCrearUsuario(
                      rol: Rol.cliente,
                    ),
                  VistaPanel.listarClientes => const VistaPanelListarClientes(),
                  // Mostramos un texto genérico para la vista de panel 'nada'.
                  _ => const Text(
                      'Bienvenido, seleccione una acción del menú.',
                      textAlign: TextAlign.center,
                    ),
                },
              ),
            ),
          ],
        ),
      );
}
