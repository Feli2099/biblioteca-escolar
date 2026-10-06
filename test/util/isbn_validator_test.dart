import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_escolar/util/isbn_validator.dart';

void main() {
  group('Validação de ISBN', () {
    test('deve aceitar ISBN-13 válido', () {
      final resultado = IsbnValidator.validar('9788532511010');

      expect(resultado, true);
    });

    test('deve rejeitar ISBN-13 inválido', () {
      final resultado =
      IsbnValidator.validar('9788532511011');

      expect(resultado, false);
    });

    test('deve rejeitar ISBN com tamanho inválido', () {
      final resultado =
      IsbnValidator.validar('123456');

      expect(resultado, false);
    });
  });
}