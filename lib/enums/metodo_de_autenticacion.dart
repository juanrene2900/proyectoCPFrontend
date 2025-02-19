enum MetodoDeAutenticacion {
  todos(null, 'Todos'),
  tokenManual('token_manual', 'Token manual'),
  tokenAutomatico('token_automatico', 'Token automático'),
  reconocimientoFacial('reconocimiento_facial', 'Reconocimiento facial');

  const MetodoDeAutenticacion(this.key, this.texto);

  final String? key;
  final String texto;
}
