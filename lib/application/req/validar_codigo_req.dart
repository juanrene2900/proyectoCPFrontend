import 'dart:convert';

class ValidarCodigoReq {
  ValidarCodigoReq({
    required this.codigo,
  });

  factory ValidarCodigoReq.fromRawJson(String str) =>
      ValidarCodigoReq.fromJson(json.decode(str));

  factory ValidarCodigoReq.fromJson(Map<String, dynamic> json) =>
      ValidarCodigoReq(
        codigo: json['codigo'],
      );

  String codigo;

  String toRawJson() => json.encode(convertirAJson());

  Map<String, dynamic> convertirAJson() => {
        'codigo': codigo,
      };
}
