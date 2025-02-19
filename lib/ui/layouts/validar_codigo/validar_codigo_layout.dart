import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sistema_admin_clientes/application/res/user_res.dart';
import 'package:sistema_admin_clientes/enums/metodo_de_autenticacion.dart';
import 'package:sistema_admin_clientes/ui/layouts/validar_codigo/falso_conjunto_codigos.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../application/req/validar_codigo_req.dart';
import '../../../infrastructure/repository/impl_repo_usuario.dart';
import '../../../utils/globals.dart';
import '../../utils/mostrar_dialogo.dart';
import '../home/providers/home_provider.dart';

class ValidarCodigoLayout extends StatefulWidget {
  const ValidarCodigoLayout({super.key, required this.metodoDeAutenticacion});

  final MetodoDeAutenticacion metodoDeAutenticacion;

  @override
  State<ValidarCodigoLayout> createState() => _ValidarCodigoLayoutState();
}

class _ValidarCodigoLayoutState extends State<ValidarCodigoLayout> {
  final _campoCodigo = TextEditingController();

  Duration _duracionParaCaducarCodigo = _duracionTotalDelCodigo;
  Timer? _contadorDelCodigo;
  bool _codigoCaducado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _inicializarContador());
  }

  void _inicializarContador() {
    _contadorDelCodigo = Timer.periodic(
      const Duration(seconds: 1), // Repetir cada segundo.
      (_) {
        setState(() {
          // Cada segundo restamos un segundo a la duración del código.
          _duracionParaCaducarCodigo =
              _duracionParaCaducarCodigo - const Duration(seconds: 1);

          // El código se caduca si la duración es igual a 0 (0 segundos).
          _codigoCaducado = _duracionParaCaducarCodigo.inSeconds == 0;

          // Detenemos el contador si ha llegado a 0 (es decir, el código caducó).
          if (_codigoCaducado) {
            _contadorDelCodigo!.cancel();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Validar código')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Se ha enviado el código.\n'
                        'Por favor ingréselo en el siguiente campo y valídelo.',
                        textAlign: TextAlign.center,
                      ),
                      const Gutter(),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _campoCodigo,
                          // Activar el campo solo si el código no se caducó.
                          enabled: !_codigoCaducado,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '000000',
                            counterText: '',
                          ),
                          style: const TextStyle(fontSize: 35),
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          onChanged: (text) => setState(() {}),
                        ),
                      ),
                      const Gutter(),
                      if (!_codigoCaducado)
                        Text(_formatearDuration(_duracionParaCaducarCodigo))
                      else
                        const Text('El código caducó. Por favor genere otro.'),
                      const Gutter(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            // Si el usuario cancela simplemente salimos de la pantalla.
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                                !_codigoCaducado ? 'Cancelar' : 'Regresar'),
                          ),
                          if (!_codigoCaducado) ...[
                            const Gutter(),
                            FilledButton(
                              onPressed: _campoCodigo.text.length == 6
                                  ? _validarCodigo
                                  : null,
                              child: const Text('Validar'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  // Simular que los tokens están en el dispositivo
                  // y se generan cada minuto.
                  if (widget.metodoDeAutenticacion ==
                      MetodoDeAutenticacion.tokenManual)
                    FalsoConjuntoCodigos(),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _validarCodigo() async {
    final repo = dependencias.get<ImplRepoUsuario>();

    final dialogoProgreso = ProgressDialog(context: context);
    dialogoProgreso.show(msg: 'Validando código...');

    String? error;

    try {
      UserRes usuario;

      if (widget.metodoDeAutenticacion == MetodoDeAutenticacion.tokenManual) {
        usuario = await repo.validarCodigoManual();
      } else {
        final codigo = _campoCodigo.text;
        final validarCodigo = ValidarCodigoReq(codigo: codigo);

        usuario = await repo.validarCodigo(validarCodigo);
      }

      jwt = usuario.token;

      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.actualizarSesionAdmin(usuario);
    } on DioException catch (err) {
      _registros.e('Error al validar el código de un usuario', error: err);

      if (err.response?.statusCode == 401) {
        error = 'Este código no coincide en nuestros sistemas.';
      } else {
        error = 'Ha ocurrido un error desconocido.';
      }
    } finally {
      dialogoProgreso.close();
    }

    if (error != null) {
      mostrarDialogo(context: context, mensaje: error);
    } else {
      // Salimos de este layout si fue ok.
      // Al volver la vista ya estará actualizada.
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _contadorDelCodigo?.cancel();
    super.dispose();
  }
}

/// Convierte un objeto Duration al formato mm:ss (minutos:segundos).
String _formatearDuration(Duration duration) {
  String obtener2Digitos(int n) => n.toString().padLeft(2, '0');

  final minutes = obtener2Digitos(duration.inMinutes.remainder(60));
  final seconds = obtener2Digitos(duration.inSeconds.remainder(60));

  return '$minutes:$seconds';
}

/// Define cuánto dura el código en total.
const _duracionTotalDelCodigo = Duration(minutes: 5);

final _registros = Logger();
