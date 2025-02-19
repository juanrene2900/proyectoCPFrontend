import 'dart:convert';

import '../../enums/metodo_de_autenticacion.dart';

class IniciarSesionReq {
  IniciarSesionReq({
    required this.email,
    required this.contrasena,
    required this.metodoDeAutenticacion,
  });

  factory IniciarSesionReq.fromRawJson(String str) =>
      IniciarSesionReq.fromJson(json.decode(str));

  factory IniciarSesionReq.fromJson(Map<String, dynamic> json) =>
      IniciarSesionReq(
        email: json['email'],
        contrasena: json['contrasena'],
        metodoDeAutenticacion: json['metodo_de_autenticacion'],
      );

  String email;
  String contrasena;
  MetodoDeAutenticacion metodoDeAutenticacion;

  String toRawJson() => json.encode(convertirAJson());

  Map<String, dynamic> convertirAJson() => {
        'email': email,
        'contrasena': contrasena,
        'metodo_de_autenticacion': metodoDeAutenticacion.key,
      };
}
