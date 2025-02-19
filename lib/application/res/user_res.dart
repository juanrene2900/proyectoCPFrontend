import 'dart:convert';

import 'package:sistema_admin_clientes/enums/rol.dart';

class UserRes {
  UserRes({
    required this.nombresYApellidos,
    required this.rol,
    required this.token,
    required this.email,
  });

  factory UserRes.desdeUnJson(Map<String, dynamic> json) => UserRes(
        nombresYApellidos: json['nombres_y_apellidos'],
        rol: Rol.values.firstWhere((e) => e.key == json['rol']),
        token: json['token'],
        email: json['email'],
      );

  factory UserRes.fromRawJson(String str) =>
      UserRes.desdeUnJson(json.decode(str));

  final String nombresYApellidos;
  final Rol rol;
  final String token;
  final String email;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'nombres_y_apellidos': nombresYApellidos,
        'rol': rol,
        'token': token,
        'email': email,
      };
}
