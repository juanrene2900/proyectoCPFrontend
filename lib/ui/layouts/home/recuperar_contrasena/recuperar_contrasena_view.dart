import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../infrastructure/repository/impl_repo_usuario.dart';
import '../../../../utils/globals.dart';
import '../../../utils/mostrar_dialogo.dart';

class RecuperarContrasenaView extends StatefulWidget {
  const RecuperarContrasenaView({
    super.key,
    required this.eventoContrasenaRestablecida,
    required this.eventoBotonIniciarSesion,
  });

  final VoidCallback eventoBotonIniciarSesion;
  final VoidCallback eventoContrasenaRestablecida;

  @override
  State<RecuperarContrasenaView> createState() =>
      _RecuperarContrasenaViewState();
}

class _RecuperarContrasenaViewState extends State<RecuperarContrasenaView> {
  String _email = "";
  String _nuevaContrasena = "";
  String _codigo = "";
  bool _codigoEnviado = false;

  @override
  Widget build(BuildContext context) => Column(
        spacing: 16,
        children: [
          Text(
            'Recuperar contraseña',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          TextField(
            readOnly: _codigoEnviado,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: _codigoEnviado,
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => _email = text.trim(),
          ),
          if (_codigoEnviado) ...[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (text) => _nuevaContrasena = text.trim(),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Código',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => _codigo = text.trim(),
            ),
            FilledButton(
              onPressed: () {
                _cambiarContrasena();
              },
              child: Text('Cambiar contrasena'),
            ),
          ] else
            FilledButton(
              onPressed: () {
                _recuperarContrasena();
              },
              child: Text('Recuperar contraseña'),
            ),
          Divider(),
          TextButton(
            onPressed: widget.eventoBotonIniciarSesion,
            child: const Text('Iniciar sesión'),
          ),
        ],
      );

  Future<void> _recuperarContrasena() async {
    if (!_isValidEmail(_email)) {
      mostrarDialogo(
        context: context,
        mensaje: 'El email no es válido.',
      );
      return;
    }

    final repo = dependencias.get<ImplRepoUsuario>();

    final dialogoProgreso = ProgressDialog(context: context);
    dialogoProgreso.show(msg: 'Enviando código...');

    try {
      await repo.solicitarRecuperarContrasena(_email);
      setState(() {
        _codigoEnviado = true;
      });
    } on DioException catch (err) {
      _logger.e('Error al listar clientes', error: err);
      mostrarDialogo(context: context, mensaje: 'No se pudo enviar el código.');
    } finally {
      dialogoProgreso.close();
    }
  }

  Future<void> _cambiarContrasena() async {
    if (_nuevaContrasena.isEmpty || _codigo.isEmpty) {
      mostrarDialogo(
        context: context,
        mensaje: 'Ingrese la nueva contraseña y el código.',
      );
      return;
    }

    final repo = dependencias.get<ImplRepoUsuario>();

    final dialogoProgreso = ProgressDialog(context: context);
    dialogoProgreso.show(msg: 'Cambiando contraseña...');

    try {
      await repo.cambiarContrasena(_email, _nuevaContrasena, _codigo);
      dialogoProgreso.close();
      widget.eventoContrasenaRestablecida(); // Ir al login
      mostrarDialogo(
        context: context,
        mensaje: 'Contraseña cambiada correctamente.',
      );
    } on DioException catch (err) {
      _logger.e('Error al listar clientes', error: err);
      dialogoProgreso.close();
      mostrarDialogo(
          context: context, mensaje: 'No se pudo cambiar la contraseña.');
    }
  }
}

bool _isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

final _logger = Logger();
