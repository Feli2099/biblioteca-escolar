import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';

void main() {
  group('Modelo Emprestimo', () {
    test('toMap deve converter emprestimo corretamente', () {
      final dataEmprestimo = DateTime(2026, 10, 6);
      final dataPrevista = DateTime(2026, 10, 13);

      final emprestimo = Emprestimo(
        id: 'emp123',
        alunoId: 'aluno123',
        alunoNome: 'João da Silva',
        livroIsbn: '9788532511010',
        livroTitulo: 'Livro Teste',
        dataEmprestimo: dataEmprestimo,
        dataDevolucaoPrevista: dataPrevista,
        devolvido: false,
        dataDevolucaoReal: null,
      );

      final map = emprestimo.toMap();

      expect(map['alunoId'], 'aluno123');
      expect(map['alunoNome'], 'João da Silva');
      expect(map['livroIsbn'], '9788532511010');
      expect(map['livroTitulo'], 'Livro Teste');
      expect(map['devolvido'], false);
      expect(map['dataDevolucaoReal'], null);

      expect(
        (map['dataEmprestimo'] as Timestamp).toDate(),
        dataEmprestimo,
      );

      expect(
        (map['dataDevolucaoPrevista'] as Timestamp).toDate(),
        dataPrevista,
      );
    });

    test('fromMap deve criar emprestimo ativo corretamente', () {
      final dataEmprestimo = DateTime(2026, 10, 6);
      final dataPrevista = DateTime(2026, 10, 13);

      final map = {
        'alunoId': 'aluno123',
        'alunoNome': 'Maria Souza',
        'livroIsbn': '9780000000000',
        'livroTitulo': 'O Hobbit',
        'dataEmprestimo': Timestamp.fromDate(dataEmprestimo),
        'dataDevolucaoPrevista': Timestamp.fromDate(dataPrevista),
        'devolvido': false,
        'dataDevolucaoReal': null,
      };

      final emprestimo = Emprestimo.fromMap(
        map,
        'emp456',
      );

      expect(emprestimo.id, 'emp456');
      expect(emprestimo.alunoId, 'aluno123');
      expect(emprestimo.alunoNome, 'Maria Souza');
      expect(emprestimo.livroIsbn, '9780000000000');
      expect(emprestimo.livroTitulo, 'O Hobbit');
      expect(emprestimo.dataEmprestimo, dataEmprestimo);
      expect(
        emprestimo.dataDevolucaoPrevista,
        dataPrevista,
      );
      expect(emprestimo.devolvido, false);
      expect(emprestimo.dataDevolucaoReal, null);
    });

    test('fromMap deve criar emprestimo devolvido corretamente', () {
      final dataEmprestimo = DateTime(2026, 10, 1);
      final dataPrevista = DateTime(2026, 10, 8);
      final dataReal = DateTime(2026, 10, 7);

      final map = {
        'alunoId': 'aluno789',
        'alunoNome': 'Pedro Santos',
        'livroIsbn': '9781111111111',
        'livroTitulo': 'Livro Devolvido',
        'dataEmprestimo': Timestamp.fromDate(dataEmprestimo),
        'dataDevolucaoPrevista': Timestamp.fromDate(dataPrevista),
        'devolvido': true,
        'dataDevolucaoReal': Timestamp.fromDate(dataReal),
      };

      final emprestimo = Emprestimo.fromMap(
        map,
        'emp789',
      );

      expect(emprestimo.devolvido, true);
      expect(emprestimo.dataDevolucaoReal, dataReal);
    });
  });
}