import 'package:flutter/material.dart';
import 'package:sistema_admin_clientes/ui/layouts/obtener_rostro/vista_camara.dart';

class ObtenerRostroB64Layout extends StatelessWidget {
  const ObtenerRostroB64Layout({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Obtener rostro'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: VistaCamara(
              alSeleccionarLaImagen: (imagenEnBase64) {
                Navigator.pop(context, imagenEnBase64);
              },
            ),
          ),
        ),
      );
}
