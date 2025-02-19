enum Rol {
  admin('admin', 'Admin'),
  cliente('cliente', 'Cliente');

  const Rol(this.key, this.texto);

  final String key;
  final String texto;
}
