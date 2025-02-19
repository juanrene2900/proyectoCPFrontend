enum EstadoDeCuenta {
  activo('activo', 'Activo'),
  inactivo('inactivo', 'Inactivo');

  const EstadoDeCuenta(this.key, this.texto);

  final String key;
  final String texto;
}
