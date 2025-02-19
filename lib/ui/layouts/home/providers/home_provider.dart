import 'package:flutter/material.dart';

import '../../../../application/res/user_res.dart';

class HomeProvider extends ChangeNotifier {
  UserRes? user;

  void actualizarSesionAdmin(UserRes admin) {
    this.user = admin;
    notifyListeners();
  }

  void eliminarSesionAdmin() {
    user = null;
    notifyListeners();
  }
}
