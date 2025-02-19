import 'dart:convert';

class LoginRes {
  LoginRes({
    required this.token,
  });

  factory LoginRes.fromRawJson(String str) =>
      LoginRes.desdeUnJson(json.decode(str));

  factory LoginRes.desdeUnJson(Map<String, dynamic> json) => LoginRes(
        token: json['token'],
      );

  final String token;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}
