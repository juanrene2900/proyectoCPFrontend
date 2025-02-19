import 'package:flutter/material.dart';

Future<void> mostrarDialogo({
  required BuildContext context,
  required String mensaje,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
