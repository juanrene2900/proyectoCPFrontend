class ValidadorDeCedulas {
  ValidadorDeCedulas._();

  static bool esValida(String id) {
    if (!_contieneSoloNumeros(id)) {
      return false;
    }

    var suma = 0;

    if (id.length != 10) {
      return false;
    } else {
      final a = List<int>.filled(id.length ~/ 2, 0);
      final b = List<int>.filled(id.length ~/ 2, 0);
      var c = 0;
      var d = 1;

      for (var i = 0; i < id.length ~/ 2; i++) {
        a[i] = int.parse(id[c]);
        c += 2;

        if (i < id.length ~/ 2 - 1) {
          b[i] = int.parse(id[d]);
          d += 2;
        }
      }

      for (var i = 0; i < a.length; i++) {
        a[i] = a[i] * 2;
        if (a[i] > 9) {
          a[i] = a[i] - 9;
        }
        suma += a[i] + b[i];
      }

      final aux = suma ~/ 10;
      final dec = (aux + 1) * 10;
      return dec - suma == int.parse(id[id.length - 1]) ||
          (suma % 10 == 0 && id[id.length - 1] == '0');
    }
  }

  static bool _contieneSoloNumeros(String str) =>
      RegExp(r'^[0-9]+$').hasMatch(str);
}
