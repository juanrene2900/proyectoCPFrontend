import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:logger/logger.dart';
import 'package:sistema_admin_clientes/application/res/cliente_res.dart';
import 'package:sistema_admin_clientes/enums/estado_de_cuenta.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../infrastructure/repository/impl_repo_usuario.dart';
import '../../rutas/direcciones_rutas.dart';
import '../../rutas/rutas.dart';
import '../../utils/globals.dart';
import '../../utils/utils.dart';
import '../utils/mostrar_dialogo.dart';
import '../widgets/vista_metodo_de_autenticacion.dart';

class ClienteLayout extends StatefulWidget {
  const ClienteLayout({super.key, required this.cliente});

  final ClienteRes cliente;

  @override
  State<ClienteLayout> createState() => _ClienteLayoutState();
}

class _ClienteLayoutState extends State<ClienteLayout> {
  final _formulario = GlobalKey<FormState>();

  late final _cliente = widget.cliente.clone();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formulario,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller:
                      TextEditingController(text: _cliente.nombresYApellidos),
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
                  onChanged: (texto) {
                    _cliente.nombresYApellidos = texto.trim();
                  },
                  onSaved: (texto) {
                    _cliente.nombresYApellidos = texto!.trim();
                  },
                  maxLength: 200,
                ),
                const Gutter(),
                TextFormField(
                  controller: TextEditingController(text: _cliente.email),
                  readOnly: true,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  validator: (texto) {
                    if (!esEmailValido(texto!)) {
                      return 'Email inválido.';
                    }
                    return null;
                  },
                  onChanged: (texto) {
                    _cliente.email = texto.trim();
                  },
                  onSaved: (texto) {
                    _cliente.email = texto!.trim();
                  },
                ),
                const Gutter(),
                TextFormField(
                  controller: TextEditingController(text: _cliente.celular),
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
                  onChanged: (texto) {
                    _cliente.celular = texto.trim();
                  },
                  onSaved: (texto) {
                    _cliente.celular = texto!.trim();
                  },
                  maxLength: 20,
                ),
                const Gutter(),
                TextFormField(
                  controller: TextEditingController(text: _cliente.direccion),
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
                  onChanged: (texto) {
                    _cliente.direccion = texto.trim();
                  },
                  onSaved: (texto) {
                    _cliente.direccion = texto!.trim();
                  },
                  maxLength: 200,
                ),
                const Gutter(),
                TextFormField(
                  controller: TextEditingController(text: _cliente.cedula),
                  readOnly: true,
                  decoration: const InputDecoration(
                    label: Text('Cédula'),
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  // Descomenta para volver a verificar la cédula.
                  // validator: (texto) {
                  //  if (!ValidadorDeCedulas.esValida(texto!)) {
                  //    return 'Cédula inválida.';
                  //  }
                  //  return null;
                  // },
                  onChanged: (texto) {
                    _cliente.cedula = texto.trim();
                  },
                  onSaved: (texto) {
                    _cliente.cedula = texto!.trim();
                  },
                ),
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
                      value: _cliente.estado == EstadoDeCuenta.activo,
                      onChanged: (estadoActivado) {
                        setState(() {
                          _cliente.estado = estadoActivado
                              ? EstadoDeCuenta.activo
                              : EstadoDeCuenta.inactivo;
                        });
                      },
                    ),
                  ],
                ),
                const Gutter(),
                VistaMetodoDeAutenticacion(
                  metodoDeAutenticacion: _cliente.metodoDeAutenticacion,
                  onChanged: (nuevoMetodoDeAutenticacion) {
                    setState(() {
                      _cliente.metodoDeAutenticacion =
                          nuevoMetodoDeAutenticacion!;
                    });
                  },
                ),
                const Gutter(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Reconocimiento facial'),
                  subtitle: _cliente.imagenDelRostroEnBase64 != null
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
                  onPressed: _actualizarCliente,
                  child: const Text('Actualizar cliente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _actualizarCliente() async {
    final formularioEstaRelleno = _formulario.currentState!.validate();

    if (formularioEstaRelleno) {
      _formulario.currentState!.save();

      final repositorio = dependencias.get<ImplRepoUsuario>();

      final dialogoProgreso = ProgressDialog(context: context);
      dialogoProgreso.show(msg: 'Actualizando cliente...');

      String mensaje;

      try {
        await repositorio.actualizarCliente(_cliente.id, _cliente);
        mensaje = 'Usuario actualizado correctamente.';
      } on DioException catch (err) {
        _registros.e('Error al actualizar un cliente', error: err);

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
      setState(() => _cliente.imagenDelRostroEnBase64 = imagenEnBase64);
    }
  }
}

final _registros = Logger();
