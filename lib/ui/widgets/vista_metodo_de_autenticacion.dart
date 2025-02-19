import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

import '../../enums/metodo_de_autenticacion.dart';

class VistaMetodoDeAutenticacion extends StatelessWidget {
  const VistaMetodoDeAutenticacion({
    super.key,
    required this.metodoDeAutenticacion,
    required this.onChanged,
    this.agregarTodos = false,
  });

  final MetodoDeAutenticacion? metodoDeAutenticacion;
  final ValueChanged<MetodoDeAutenticacion?> onChanged;
  final bool agregarTodos;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Método de autenticación:'),
          const Gutter(),
          DropdownButton<MetodoDeAutenticacion>(
            value: metodoDeAutenticacion,
            icon: const Icon(Icons.arrow_downward),
            onChanged: onChanged,
            items: !agregarTodos
                ? List.from(
                    [
                      MetodoDeAutenticacion.tokenManual,
                      MetodoDeAutenticacion.tokenAutomatico,
                      MetodoDeAutenticacion.reconocimientoFacial,
                    ].map(
                      (e) => DropdownMenuItem<MetodoDeAutenticacion>(
                        value: e,
                        child: Text(e.texto),
                      ),
                    ),
                  )
                : List.from(
                    [
                      MetodoDeAutenticacion.todos,
                      MetodoDeAutenticacion.tokenManual,
                      MetodoDeAutenticacion.tokenAutomatico,
                      MetodoDeAutenticacion.reconocimientoFacial,
                    ].map(
                      (e) => DropdownMenuItem<MetodoDeAutenticacion>(
                        value: e,
                        child: Text(e.texto),
                      ),
                    ),
                  ),
          ),
        ],
      );
}
