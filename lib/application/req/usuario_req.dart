import 'dart:convert';

import 'package:sistema_admin_clientes/enums/estado_de_cuenta.dart';

import '../../enums/metodo_de_autenticacion.dart';

class UsuarioReq {
  UsuarioReq({
    required this.nombresYApellidos,
    required this.email,
    required this.celular,
    required this.direccion,
    required this.cedula,
    required this.contrasena,
    required this.rol,
    required this.metodoDeAutenticacion,
    required this.imagenDelRostroEnBase64,
    required this.estado,
  });

  String nombresYApellidos;
  String email;
  String celular;
  String direccion;
  String cedula;
  String contrasena;
  String rol;
  EstadoDeCuenta estado;

  // El rostro del usuario en base64.
  // NOTA: Solo es obligatorio cuando el método de autenticación seleccionado es el Reconocimiento facial.
  String? imagenDelRostroEnBase64;

  // Un Admin puede utilizar cualquier método de autenticación,
  // pero el Client solo el que le haya asignado su Admin.
  MetodoDeAutenticacion? metodoDeAutenticacion;

  String toRawJson() => json.encode(convertirAJson());

  Map<String, dynamic> convertirAJson() => {
        'nombres_y_apellidos': nombresYApellidos,
        'email': email,
        'celular': celular,
        'direccion': direccion,
        'cedula': cedula,
        'contrasena': contrasena,
        'rol': rol,
        'metodo_de_autenticacion': metodoDeAutenticacion?.key,
        'imagen_del_rostro_en_base_64': imagenDelRostroEnBase64,
        'estado': estado.key,
      };
}
