import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../application/req/validar_rostro_req.dart';
import '../../../../enums/metodo_de_autenticacion.dart';
import '../../../../infrastructure/repository/impl_repo_usuario.dart';
import '../../../../rutas/direcciones_rutas.dart';
import '../../../../rutas/rutas.dart';
import '../../../../utils/globals.dart';
import '../../../utils/mostrar_dialogo.dart';
import '../../../widgets/vista_metodo_de_autenticacion.dart';
import '../providers/home_provider.dart';
import 'vista_formulario_iniciar_sesion.dart';

class VistaIniciarSesion extends StatefulWidget {
  const VistaIniciarSesion({
    super.key,
    required this.eventoBotonCrearCuenta,
    required this.eventoRecuperarContrasena,
  });

  final VoidCallback eventoBotonCrearCuenta;
  final VoidCallback eventoRecuperarContrasena;

  @override
  State<VistaIniciarSesion> createState() => _VistaIniciarSesionState();
}

class _VistaIniciarSesionState extends State<VistaIniciarSesion> {
  MetodoDeAutenticacion _metodoDeAutenticacion =
      MetodoDeAutenticacion.tokenAutomatico;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          VistaMetodoDeAutenticacion(
            metodoDeAutenticacion: _metodoDeAutenticacion,
            onChanged: (nuevoMetodoDeAutenticacion) {
              setState(
                  () => _metodoDeAutenticacion = nuevoMetodoDeAutenticacion!);
            },
          ),
          const Gutter(),
          VistaFormularioIniciarSesion(
            metodoDeAutenticacion: _metodoDeAutenticacion,
            eventoLoginCompletado: _eventoLoginCompletado,
          ),
          const Gutter(),
          TextButton(
            onPressed: widget.eventoBotonCrearCuenta,
            child: const Text('Crear cuenta'),
          ),
          const Gutter(),
          TextButton(
            onPressed: widget.eventoRecuperarContrasena,
            child: const Text('Recuperar contraseña'),
          ),
        ],
      );

  Future _eventoLoginCompletado() async {
    if (_metodoDeAutenticacion == MetodoDeAutenticacion.reconocimientoFacial) {
      final imagenEnBase64 =
          await rutas.pushNamed<String?>(DireccionesRutas.obtenerRostro);

      if (imagenEnBase64 != null) {
        return _validarRostro(imagenEnBase64);
      } else {
        // El usuario canceló la operación.
      }
    } else {
      rutas.pushNamed(
        DireccionesRutas.validarCodigo,
        extra: {
          'metodo_de_autenticacion': _metodoDeAutenticacion,
        },
      );
    }
  }

  Future<void> _validarRostro(String imagenEnBase64) async {
    final repo = dependencias.get<ImplRepoUsuario>();

    final dialogoProgreso = ProgressDialog(context: context);
    dialogoProgreso.show(msg: 'Validando rostro...');

    String? error;

    final validarRostro =
        ValidarRostroReq(imagenDelRostroEnBase64: imagenEnBase64);

    try {
      final usuario = await repo.validarRostro(validarRostro);
      jwt = usuario.token;

      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.actualizarSesionAdmin(usuario);
    } on DioException catch (err) {
      _registros.e('Error al validar el rostro de un usuario', error: err);

      if (err.response?.statusCode == 401) {
        error = 'Este rostro no coincide con el propietario de esta cuenta.';
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

final _registros = Logger();
