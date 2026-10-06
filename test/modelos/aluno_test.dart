import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';

void main() {
  group('Modelo Aluno', () {
    test('toMap deve converter aluno para Map corretamente', () {
      final aluno = Aluno(
        id: '123',
        nomeCompleto: 'João da Silva',
        turma: '7º A',
      );

      final map = aluno.toMap();

      expect(map['nomeCompleto'], 'João da Silva');
      expect(map['turma'], '7º A');

      expect(map.containsKey('id'), false);
    });

    test('fromMap deve criar Aluno corretamente', () {
      final map = {
        'nomeCompleto': 'Maria Souza',
        'turma': '8º B',
      };

      final aluno = Aluno.fromMap(
        map,
        'abc123',
      );

      expect(aluno.id, 'abc123');
      expect(aluno.nomeCompleto, 'Maria Souza');
      expect(aluno.turma, '8º B');
    });

    test('fromMap deve usar valores vazios quando campos não existirem', () {
      final aluno = Aluno.fromMap(
        {},
        'xyz789',
      );

      expect(aluno.id, 'xyz789');
      expect(aluno.nomeCompleto, '');
      expect(aluno.turma, '');
    });
  });
}