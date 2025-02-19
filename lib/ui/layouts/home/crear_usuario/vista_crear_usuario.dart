import 'package:flutter/material.dart';

import '../../../../enums/rol.dart';
import 'vista_formulario_crear_usuario.dart';

class VistaCrearUsuario extends StatelessWidget {
  const VistaCrearUsuario({
    super.key,
    required this.eventoBotonIniciarSesion,
  });

  final VoidCallback eventoBotonIniciarSesion;

  @override
  Widget build(BuildContext context) => Column(
        spacing: 16,
        children: [
          const VistaFormularioCrearUsuario(rol: Rol.admin),
          SizedBox(width: 16.0),
          TextButton(
            onPressed: eventoBotonIniciarSesion,
            child: const Text('Iniciar sesión'),
          ),
        ],
      );
}
