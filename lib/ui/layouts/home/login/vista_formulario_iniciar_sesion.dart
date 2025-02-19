import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:logger/logger.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../application/req/iniciar_sesion_req.dart';
import '../../../../enums/metodo_de_autenticacion.dart';
import '../../../../infrastructure/repository/impl_repo_usuario.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/utils.dart';
import '../../../utils/mostrar_dialogo.dart';

class VistaFormularioIniciarSesion extends StatefulWidget {
  const VistaFormularioIniciarSesion({
    super.key,
    required this.metodoDeAutenticacion,
    required this.eventoLoginCompletado,
  });

  final MetodoDeAutenticacion metodoDeAutenticacion;
  final VoidCallback eventoLoginCompletado;

  @override
  State<VistaFormularioIniciarSesion> createState() =>
      _VistaFormularioIniciarSesionState();
}

class _VistaFormularioIniciarSesionState
    extends State<VistaFormularioIniciarSesion> {
  final _formulario = GlobalKey<FormState>();
  late final _usuario = IniciarSesionReq(
    email: '',
    contrasena: '',
    metodoDeAutenticacion: widget.metodoDeAutenticacion,
  );

  @override
  void didUpdateWidget(covariant VistaFormularioIniciarSesion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _usuario.metodoDeAutenticacion = widget.metodoDeAutenticacion;
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formulario,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Email'),
                border: OutlineInputBorder(),
              ),
              validator: (texto) {
                if (!esEmailValido(texto!)) {
                  return 'Email inválido.';
                }
                return null;
              },
              onSaved: (texto) {
                _usuario.email = texto!.trim();
              },
            ),
            const Gutter(),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Contraseña'),
                border: OutlineInputBorder(),
              ),
              validator: (texto) {
                if (texto!.isBlank) {
                  return 'La contraseña es requerida.';
                }
                return null;
              },
              onSaved: (texto) {
                _usuario.contrasena = texto!;
              },
              obscureText: true,
            ),
            const Gutter(),
            FilledButton(
              onPressed: _iniciarSesion,
              child: const Text('Acceder'),
            ),
          ],
        ),
      );

  Future<void> _iniciarSesion() async {
    final formularioEstaRelleno = _formulario.currentState!.validate();

    if (formularioEstaRelleno) {
      _formulario.currentState!.save();

      final repositorio = dependencias.get<ImplRepoUsuario>();

      final dialogoProgreso = ProgressDialog(context: context);
      dialogoProgreso.show(msg: 'Iniciando sesión...');

      String? error;

      try {
        final login = await repositorio.loginUsuario(_usuario);

        // Guardamos el token recibido en la memoria del dispositivo.
        jwt = login.token;

        widget.eventoLoginCompletado();
      } on DioException catch (err) {
        _registros.e('Error al iniciar sesión', error: err);

        if (err.response?.statusCode == 401) {
          error = 'Credenciales incorrectas.';
        } else if (err.response?.statusCode == 403) {
          error = 'No está autorizado para realizar esta acción.';
        } else {
          error = 'Ha ocurrido un error desconocido.';
        }
      } finally {
        dialogoProgreso.close();
      }

      if (error != null) {
        mostrarDialogo(context: context, mensaje: error);
      }
    }
  }
}

final _registros = Logger();
