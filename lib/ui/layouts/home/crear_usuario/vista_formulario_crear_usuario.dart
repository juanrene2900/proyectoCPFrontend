import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:logger/logger.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../application/req/usuario_req.dart';
import '../../../../enums/estado_de_cuenta.dart';
import '../../../../enums/metodo_de_autenticacion.dart';
import '../../../../enums/rol.dart';
import '../../../../infrastructure/repository/impl_repo_usuario.dart';
import '../../../../rutas/direcciones_rutas.dart';
import '../../../../rutas/rutas.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/utils.dart';
import '../../../utils/mostrar_dialogo.dart';
import '../../../widgets/vista_metodo_de_autenticacion.dart';

class VistaFormularioCrearUsuario extends StatefulWidget {
  const VistaFormularioCrearUsuario({super.key, required this.rol});

  final Rol rol;

  @override
  State<VistaFormularioCrearUsuario> createState() =>
      _VistaFormularioCrearUsuarioState();
}

class _VistaFormularioCrearUsuarioState
    extends State<VistaFormularioCrearUsuario> {
  final _formulario = GlobalKey<FormState>();

  late final _usuario = UsuarioReq(
    nombresYApellidos: '',
    email: '',
    celular: '',
    direccion: '',
    cedula: '',
    contrasena: '',
    rol: widget.rol.key,
    metodoDeAutenticacion: MetodoDeAutenticacion.tokenAutomatico,
    imagenDelRostroEnBase64: null,
    estado: EstadoDeCuenta.activo,
  );

  @override
  Widget build(BuildContext context) => Form(
        key: _formulario,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Nombres y apellidos'),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (texto) {
                  if (texto!.isBlank) {
                    return 'Los nombres y apellidos son requeridos.';
                  }
                  return null;
                },
                onSaved: (texto) {
                  _usuario.nombresYApellidos = texto!.trim();
                },
                maxLength: 200,
              ),
              const Gutter(),
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
                  label: Text('Teléfono'),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (texto) {
                  if (texto!.isBlank) {
                    return 'El teléfono es requerido.';
                  }
                  return null;
                },
                onSaved: (texto) {
                  _usuario.celular = texto!.trim();
                },
                maxLength: 20,
              ),
              const Gutter(),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Dirección'),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (texto) {
                  if (texto!.isBlank) {
                    return 'La dirección es requerida.';
                  }
                  return null;
                },
                onSaved: (texto) {
                  _usuario.direccion = texto!.trim();
                },
                maxLength: 200,
              ),
              const Gutter(),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Cédula'),
                  border: OutlineInputBorder(),
                ),
                // Descomentar para validar cédulas.
                // validator: (texto) {
                //  if (!ValidadorDeCedulas.esValida(texto!)) {
                //    return 'Cédula inválida.';
                //  }
                //  return null;
                // },
                onSaved: (texto) {
                  _usuario.cedula = texto!.trim();
                },
              ),
              const Gutter(),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Contraseña'),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (texto) {
                  if (texto!.length < 8) {
                    return 'La longitud mínima son 8 caracteres.';
                  }
                  return null;
                },
                onSaved: (texto) {
                  _usuario.contrasena = texto!;
                },
                maxLength: 20,
                obscureText: true,
              ),
              if (widget.rol != Rol.admin) ...[
                const Gutter(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Text(
                      'Estado',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Switch(
                      value: _usuario.estado == EstadoDeCuenta.activo,
                      onChanged: (nuevoEstado) {
                        setState(() {
                          _usuario.estado = nuevoEstado
                              ? EstadoDeCuenta.activo
                              : EstadoDeCuenta.inactivo;
                        });
                      },
                    ),
                  ],
                ),
              ],
              const Gutter(),
              VistaMetodoDeAutenticacion(
                metodoDeAutenticacion: _usuario.metodoDeAutenticacion!,
                agregarTodos: widget.rol == Rol.admin,
                onChanged: (nuevoMetodoDeAutenticacion) {
                  setState(() {
                    _usuario.metodoDeAutenticacion =
                        nuevoMetodoDeAutenticacion!;
                  });
                },
              ),
              const Gutter(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reconocimiento facial'),
                subtitle: _usuario.imagenDelRostroEnBase64 != null
                    ? const Text('Activado',
                        style: TextStyle(color: Colors.green))
                    : const Text('Desactivado'),
                trailing: IconButton(
                  onPressed: _agregarImagenDelRostroEnBase64,
                  icon: const Icon(Icons.add),
                ),
              ),
              const Gutter(),
              FilledButton(
                onPressed: _crearCuenta,
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      );

  Future<void> _crearCuenta() async {
    final formularioEstaRelleno = _formulario.currentState!.validate();

    if (formularioEstaRelleno) {
      _formulario.currentState!.save();

      final repositorio = dependencias.get<ImplRepoUsuario>();

      final dialogoProgreso = ProgressDialog(context: context);
      dialogoProgreso.show(msg: 'Creando cuenta...');

      String mensaje;

      try {
        // Dependiendo si se está agregando un Admin o un Cliente se utiliza
        // una API u otra.
        if (widget.rol == Rol.admin) {
          await repositorio.crearAdmin(_usuario);
        } else {
          await repositorio.crearCliente(_usuario);
        }
        mensaje = 'Usuario creado correctamente.';
      } on DioException catch (err) {
        _registros.e('Error al crear un usuario', error: err);

        if (err.response?.statusCode == 409) {
          mensaje = 'Ya existe un usuario registrado con este email o cédula.';
        } else {
          mensaje = 'Ha ocurrido un error desconocido.';
        }
      } finally {
        dialogoProgreso.close();
      }

      mostrarDialogo(context: context, mensaje: mensaje);
    }
  }

  Future<void> _agregarImagenDelRostroEnBase64() async {
    final imagenEnBase64 =
        await rutas.pushNamed<String?>(DireccionesRutas.obtenerRostro);

    if (imagenEnBase64 != null) {
      setState(() => _usuario.imagenDelRostroEnBase64 = imagenEnBase64);
    }
  }
}

final _registros = Logger();
