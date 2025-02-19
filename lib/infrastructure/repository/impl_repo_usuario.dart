import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../application/req/iniciar_sesion_req.dart';
import '../../application/req/usuario_req.dart';
import '../../application/req/validar_codigo_req.dart';
import '../../application/req/validar_rostro_req.dart';
import '../../application/res/cliente_res.dart';
import '../../application/res/login_res.dart';
import '../../application/res/user_res.dart';
import '../../domain/ports/repo_usuarios.dart';
import '../../utils/globals.dart';

class ImplRepoUsuario with RepoUsuarios {
  @override
  Future<Response> crearAdmin(UsuarioReq usuario) async {
    final http = await _buildHttp();
    return http.post('/usuarios', data: usuario.convertirAJson());
  }

  @override
  Future<Response> crearCliente(UsuarioReq usuario) async {
    final http = await _buildHttp();
    return http.post('/clientes', data: usuario.convertirAJson());
  }

  @override
  Future<Response> eliminarCliente(String idCliente) async {
    final http = await _buildHttp();
    return http.delete('/clientes/$idCliente');
  }

  @override
  Future<Response> actualizarCliente(
    String idCliente,
    ClienteRes usuario,
  ) async {
    final http = await _buildHttp();
    return http.patch('/clientes/$idCliente', data: usuario.toJson());
  }

  @override
  Future<LoginRes> loginUsuario(IniciarSesionReq iniciarSesion) async {
    final http = await _buildHttp();
    final respuesta = await http.post(
      '/usuarios/login',
      data: iniciarSesion.convertirAJson(),
    );
    return LoginRes.desdeUnJson(respuesta.data);
  }

  @override
  Future<UserRes> validarCodigo(ValidarCodigoReq validarCodigo) async {
    final http = await _buildHttp();
    final respuesta = await http.post(
      '/usuarios/validar-codigo',
      data: validarCodigo.convertirAJson(),
    );
    return UserRes.desdeUnJson(respuesta.data);
  }

  @override
  Future<UserRes> validarCodigoManual() async {
    final http = await _buildHttp();
    final respuesta = await http.post(
      '/usuarios/validar-codigo-manual',
    );
    return UserRes.desdeUnJson(respuesta.data);
  }

  @override
  Future<UserRes> validarRostro(ValidarRostroReq validarRostro) async {
    final http = await _buildHttp();
    final respuesta = await http.post(
      '/usuarios/validar-rostro',
      data: validarRostro.convertirAJson(),
    );
    return UserRes.desdeUnJson(respuesta.data);
  }

  @override
  Future<List<ClienteRes>> listarClientes() async {
    final http = await _buildHttp();
    final respuesta = await http.get<List>('/clientes');
    return List.from(respuesta.data!.map(ClienteRes.fromJson));
  }

  @override
  Future<Response> solicitarRecuperarContrasena(String email) async {
    final http = await _buildHttp();
    return http.post('/usuarios/solicitar-recuperar-contrasena', data: {
      'email': email,
    });
  }

  @override
  Future<Response> cambiarContrasena(
    String email,
    String nuevaContrasena,
    String codigo,
  ) async {
    final http = await _buildHttp();
    return http.post('/usuarios/cambiar-contrasena', data: {
      'email': email,
      'nueva_contrasena': nuevaContrasena,
      'codigo': codigo,
    });
  }
}

Future<Dio> _buildHttp() async {
  final urlBase = dotenv.env['URL_BASE']!;

  final ajustes = BaseOptions(baseUrl: urlBase);
  ajustes.headers['Authorization'] = 'Bearer $jwt';

  return Dio(ajustes);
}
