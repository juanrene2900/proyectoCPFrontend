import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

import '../../utils/mostrar_snack_bar.dart';

class VistaCamara extends StatefulWidget {
  const VistaCamara({super.key, required this.alSeleccionarLaImagen});

  final AlSeleccionarLaImagen alSeleccionarLaImagen;

  @override
  _VistaCamaraState createState() => _VistaCamaraState();
}

class _VistaCamaraState extends State<VistaCamara> {
  CameraController? _controlador;
  bool _iniciandoCamara = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _inicializarCamara());
  }

  @override
  Widget build(BuildContext context) {
    if (_iniciandoCamara) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Gutter(),
          Text('Cargando una cámara...'),
        ],
      );
    }

    if (_controlador == null) {
      return const Center(child: Text('No se pudo inicializar una cámara.'));
    }

    return Column(
      children: [
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: CameraPreview(_controlador!),
          ),
        ),
        const Gutter(),
        FilledButton(
          onPressed: _capturarYProcesarImagen,
          child: const Text('Seleccionar imagen'),
        ),
      ],
    );
  }

  Future<void> _inicializarCamara() async {
    final camaras = await _obtenerCamarasDisponibles();

    if (camaras != null) {
      if (camaras.isEmpty) {
        mostrarSnackBar(
            context: context, text: 'No se encontró ninguna cámara.');
      } else {
        final camaraSeleccionada = camaras.first;
        _controlador =
            CameraController(camaraSeleccionada, ResolutionPreset.ultraHigh);

        try {
          await _controlador!.initialize();
        } on CameraException catch (err) {
          if (err.code == 'CameraAccessDenied') {
            _mostrarMensajeSinPermisos();
          }
          _controlador = null;
        }
      }
    }

    if (mounted) {
      setState(() => _iniciandoCamara = false);
    }
  }

  Future<List<CameraDescription>?> _obtenerCamarasDisponibles() async {
    try {
      return await availableCameras();
    } on CameraException catch (err) {
      if (err.code == 'CameraAccessDenied') {
        _mostrarMensajeSinPermisos();
      }
    }
    return null;
  }

  Future<void> _capturarYProcesarImagen() async {
    try {
      // Obtenemos la imagen.
      final imagen = await _controlador!.takePicture();
      // Obtenemos sus bytes.
      final bytes = await imagen.readAsBytes();
      // Y lo convertimos a base64.
      final base64 = base64Encode(bytes);
      // Para finalmente enviarlo.
      widget.alSeleccionarLaImagen(base64);
    } catch (err) {
      mostrarSnackBar(context: context, text: 'No se pudo procesar la imagen.');
    }
  }

  void _mostrarMensajeSinPermisos() => mostrarSnackBar(
        context: context,
        text: 'No tenemos el permiso para usar su cámara y micrófono.',
      );

  @override
  void dispose() {
    _controlador?.dispose();
    super.dispose();
  }
}

typedef AlSeleccionarLaImagen = Function(String imagenEnBase64);
