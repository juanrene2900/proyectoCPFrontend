import 'dart:convert';

class ValidarRostroReq {
  ValidarRostroReq({
    required this.imagenDelRostroEnBase64,
  });

  factory ValidarRostroReq.fromRawJson(String str) =>
      ValidarRostroReq.fromJson(json.decode(str));

  factory ValidarRostroReq.fromJson(Map<String, dynamic> json) =>
      ValidarRostroReq(
        imagenDelRostroEnBase64: json['imagen_del_rostro_en_base_64'],
      );

  String imagenDelRostroEnBase64;

  String toRawJson() => json.encode(convertirAJson());

  Map<String, dynamic> convertirAJson() => {
        'imagen_del_rostro_en_base_64': imagenDelRostroEnBase64,
      };
}
