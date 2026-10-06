class IsbnValidator {
  static bool validar(String isbn) {
    final isbnLimpo =
    isbn.replaceAll(RegExp(r'[\s-]'), '');

    if (isbnLimpo.length == 10) {
      return _validarIsbn10(isbnLimpo);
    }

    if (isbnLimpo.length == 13) {
      return _validarIsbn13(isbnLimpo);
    }

    return false;
  }

  static bool _validarIsbn13(String isbn) {
    if (!RegExp(r'^\d{13}$').hasMatch(isbn)) {
      return false;
    }

    int soma = 0;

    for (int i = 0; i < 12; i++) {
      final digito = int.parse(isbn[i]);

      if (i % 2 == 0) {
        soma += digito;
      } else {
        soma += digito * 3;
      }
    }

    final digitoVerificador =
        (10 - (soma % 10)) % 10;

    return digitoVerificador ==
        int.parse(isbn[12]);
  }

  static bool _validarIsbn10(String isbn) {
    if (!RegExp(r'^\d{9}[\dXx]$')
        .hasMatch(isbn)) {
      return false;
    }

    int soma = 0;

    for (int i = 0; i < 9; i++) {
      final digito = int.parse(isbn[i]);
      soma += digito * (10 - i);
    }

    final ultimoCaractere = isbn[9];

    final digitoVerificador =
    ultimoCaractere.toUpperCase() == 'X'
        ? 10
        : int.parse(ultimoCaractere);

    soma += digitoVerificador;

    return soma % 11 == 0;
  }
}