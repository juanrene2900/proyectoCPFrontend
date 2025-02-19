import 'dart:convert';

import '../../enums/estado_de_cuenta.dart';
import '../../enums/metodo_de_autenticacion.dart';

class ClienteRes {
  final String id;
  String nombresYApellidos;
  String email;
  String celular;
  String direccion;
  String cedula;
  EstadoDeCuenta estado;
  MetodoDeAutenticacion metodoDeAutenticacion =
      MetodoDeAutenticacion.tokenAutomatico;
  String? imagenDelRostroEnBase64;

  ClienteRes({
    required this.id,
    required this.nombresYApellidos,
    required this.email,
    required this.celular,
    required this.direccion,
    required this.cedula,
    required this.estado,
    required this.metodoDeAutenticacion,
    required this.imagenDelRostroEnBase64,
  });

  // Clone.
  ClienteRes clone() => ClienteRes(
        id: id,
        nombresYApellidos: nombresYApellidos,
        email: email,
        celular: celular,
        direccion: direccion,
        cedula: cedula,
        estado: estado,
        metodoDeAutenticacion: metodoDeAutenticacion,
        imagenDelRostroEnBase64: imagenDelRostroEnBase64,
      );

  ClienteRes copyWith({
    String? id,
    String? nombresYApellidos,
    String? email,
    String? celular,
    String? direccion,
    String? cedula,
    EstadoDeCuenta? estado,
    MetodoDeAutenticacion? metodoDeAutenticacion,
    String? imagenDelRostroEnBase64,
  }) =>
      ClienteRes(
        id: id ?? this.id,
        nombresYApellidos: nombresYApellidos ?? this.nombresYApellidos,
        email: email ?? this.email,
        celular: celular ?? this.celular,
        direccion: direccion ?? this.direccion,
        cedula: cedula ?? this.cedula,
        estado: estado ?? this.estado,
        metodoDeAutenticacion:
            metodoDeAutenticacion ?? this.metodoDeAutenticacion,
        imagenDelRostroEnBase64:
            imagenDelRostroEnBase64 ?? this.imagenDelRostroEnBase64,
      );

  factory ClienteRes.fromRawJson(String str) =>
      ClienteRes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClienteRes.fromJson(dynamic json) {
    return ClienteRes(
      id: json["_id"],
      nombresYApellidos: json["nombres_y_apellidos"],
      email: json["email"],
      celular: json["celular"],
      direccion: json["direccion"],
      cedula: json["cedula"],
      estado: EstadoDeCuenta.values.firstWhere((e) => e.key == json["estado"]),
      metodoDeAutenticacion: MetodoDeAutenticacion.values
          .firstWhere((e) => e.key == json['metodo_de_autenticacion']),
      imagenDelRostroEnBase64: null, // TODO: Implementar.
    );
  }

  Map<String, dynamic> toJson() => {
        "nombres_y_apellidos": nombresYApellidos,
        "celular": celular,
        "direccion": direccion,
        "estado": estado.key,
        'metodo_de_autenticacion': metodoDeAutenticacion.key,
        'imagen_del_rostro_en_base_64': imagenDelRostroEnBase64,
      };
}
