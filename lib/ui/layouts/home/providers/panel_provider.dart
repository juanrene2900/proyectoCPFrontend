import 'package:flutter/material.dart';

import '../../../../enums/vista_panel.dart';

/// Provider que nos sirve para manejar los estados en el panel de un Admin.
class PanelProvider extends ChangeNotifier {
  VistaPanel vistaPanel = VistaPanel.nada;

  void actualizarListaPanel(VistaPanel vistaPanel) {
    this.vistaPanel = vistaPanel;
    notifyListeners();
  }
}
