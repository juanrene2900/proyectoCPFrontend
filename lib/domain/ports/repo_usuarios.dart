import 'package:dio/dio.dart';
import 'package:sistema_admin_clientes/application/res/cliente_res.dart';

import '../../application/req/iniciar_sesion_req.dart';
import '../../application/req/usuario_req.dart';
import '../../application/req/validar_codigo_req.dart';
import '../../application/req/validar_rostro_req.dart';
import '../../application/res/login_res.dart';
import '../../application/res/user_res.dart';

mixin RepoUsuarios {
  Future<Response> crearAdmin(UsuarioReq usuario);

  Future<Response> crearCliente(UsuarioReq usuario);

  Future<Response> eliminarCliente(String idCliente);

  Future<Response> actualizarCliente(String idCliente, ClienteRes usuario);

  Future<LoginRes> loginUsuario(IniciarSesionReq iniciarSesion);

  Future<UserRes> validarCodigo(ValidarCodigoReq validarCodigo);

  Future<UserRes> validarCodigoManual();

  Future<UserRes> validarRostro(ValidarRostroReq validarRostro);

  Future<List<ClienteRes>> listarClientes();

  Future<Response> solicitarRecuperarContrasena(String email);

  Future<Response> cambiarContrasena(
      String email, String nuevaContrasena, String codigo);
}
