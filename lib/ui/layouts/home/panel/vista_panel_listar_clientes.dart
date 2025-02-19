import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sistema_admin_clientes/application/res/cliente_res.dart';
import 'package:sistema_admin_clientes/rutas/direcciones_rutas.dart';
import 'package:sistema_admin_clientes/rutas/rutas.dart';
import 'package:sistema_admin_clientes/ui/utils/mostrar_dialogo.dart';

import '../../../../infrastructure/repository/impl_repo_usuario.dart';
import '../../../../utils/globals.dart';

class VistaPanelListarClientes extends StatefulWidget {
  const VistaPanelListarClientes({super.key});

  @override
  State<VistaPanelListarClientes> createState() =>
      _VistaPanelListarClientesState();
}

class _VistaPanelListarClientesState extends State<VistaPanelListarClientes> {
  bool _cargando = true;
  List<ClienteRes> _clientes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarClientes());
  }

  Future<void> _cargarClientes() async {
    final repo = dependencias.get<ImplRepoUsuario>();

    try {
      _clientes = await repo.listarClientes();
      setState(() {});
    } on DioException catch (err) {
      _logger.e('Error al listar clientes', error: err);
      if (err.response?.statusCode == 401) {
        mostrarDialogo(
          context: context,
          mensaje: 'No está autorizado para listar estos clientes.',
        );
        return;
      }
      mostrarDialogo(context: context, mensaje: 'Ha ocurrido un error.');
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Center(child: CircularProgressIndicator());
    }

    return DataTable(
      columns: _buildEncabezados(),
      rows: List<DataRow>.from(
        _clientes.map(
          (e) => DataRow(
            cells: [
              DataCell(Text(e.nombresYApellidos)),
              DataCell(Text(e.email)),
              DataCell(Text(e.celular)),
              DataCell(Text(e.direccion)),
              DataCell(Text(e.cedula)),
              DataCell(Text(e.estado.texto)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          rutas.pushNamed(
                            DireccionesRutas.cliente,
                            extra: {'cliente': e},
                          );
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          _eliminarCliente(e.id);
                        },
                        icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _eliminarCliente(String idCliente) async {
    final confirmado = await _confirmarEliminacion();
    if (!(confirmado ?? false)) {
      return;
    }

    final repo = dependencias.get<ImplRepoUsuario>();

    try {
      await repo.eliminarCliente(idCliente);
      _clientes.removeWhere((e) => e.id == idCliente);
      setState(() {});
    } catch (err) {
      _logger.e('Error al eliminar cliente', error: err);
      mostrarDialogo(
        context: context,
        mensaje: 'No se pudo eliminar el cliente.',
      );
    }
  }

  Future<bool?> _confirmarEliminacion() => showDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Eliminar cliente'),
          content: Text('¿Está seguro de eliminar este cliente?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Eliminar'),
            ),
          ],
        ),
      );

  List<DataColumn> _buildEncabezados() {
    final encabezados = [
      'Nombres y apellidos',
      'Email',
      'Celular',
      'Dirección',
      'Cédula',
      'Estado',
      'Acciones'
    ];

    return List.from(
      encabezados.map(
        (e) => DataColumn(
          label: Expanded(
            child: Text(
              e,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ),
    );
  }
}

final _logger = Logger();
