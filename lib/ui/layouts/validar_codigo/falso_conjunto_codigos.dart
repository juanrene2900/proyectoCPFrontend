import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FalsoConjuntoCodigos extends StatefulWidget {
  const FalsoConjuntoCodigos({super.key});

  @override
  _FalsoConjuntoCodigosState createState() => _FalsoConjuntoCodigosState();
}

class _FalsoConjuntoCodigosState extends State<FalsoConjuntoCodigos> {
  late Timer _timer;
  String _codigo = '';
  double _progreso = 1.0;
  final Duration _duracionTotal = const Duration(minutes: 1);
  late Duration _duracionRestante;

  @override
  void initState() {
    super.initState();
    _generarCodigo();
    _duracionRestante = _duracionTotal;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duracionRestante -= const Duration(seconds: 1);
        _progreso = _duracionRestante.inSeconds / _duracionTotal.inSeconds;
        if (_duracionRestante.inSeconds == 0) {
          _generarCodigo();
          _duracionRestante = _duracionTotal;
        }
      });
    });
  }

  void _generarCodigo() {
    final random = Random();
    _codigo = List.generate(6, (_) => random.nextInt(10)).join();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color _obtenerColor() {
      if (_progreso > 0.7) {
        return Colors.green;
      } else if (_progreso > 0.3) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    }

    return Column(
      spacing: 16,
      children: [
        Text(
          'Token manual',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: _progreso,
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(_obtenerColor()),
                  backgroundColor: Colors.grey[300],
                ),
              ),
              Text(
                _codigo,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
