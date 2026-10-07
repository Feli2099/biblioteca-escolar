import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';
import 'package:biblioteca_escolar/telas/emprestimos/tela_cadastro_emprestimo.dart';

void main() {
  final alunoTeste = Aluno(
    id: 'aluno123',
    nomeCompleto: 'João da Silva',
    turma: '7º A',
  );

  final livroTeste = Livro(
    titulo: 'O Hobbit',
    autor: 'J. R. R. Tolkien',
    isbn: '9788532511010',
    editora: 'HarperCollins',
  );

  group('TelaCadastroEmprestimo', () {
    testWidgets(
      'deve mostrar aviso quando dados obrigatórios não forem selecionados',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroEmprestimo(
              alunos: [alunoTeste],
              livros: [livroTeste],
              onCadastrar: (emprestimo) async {
                return emprestimo;
              },
            ),
          ),
        );

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pump();

        expect(
          find.text(
            'Selecione aluno, livro e data de devolução.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'deve registrar empréstimo com dados selecionados',
          (tester) async {
        Emprestimo? emprestimoRecebido;

        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroEmprestimo(
              alunos: [alunoTeste],
              livros: [livroTeste],
              onCadastrar: (emprestimo) async {
                emprestimoRecebido = emprestimo;
                return emprestimo;
              },
            ),
          ),
        );

        await tester.tap(
          find.byType(
            DropdownButtonFormField<Aluno>,
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find
              .text('João da Silva - 7º A')
              .last,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.byType(
            DropdownButtonFormField<Livro>,
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('O Hobbit').last,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text(
            'Selecionar data de devolução',
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('OK'),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pumpAndSettle();

        expect(
          emprestimoRecebido,
          isNotNull,
        );

        expect(
          emprestimoRecebido!.alunoId,
          'aluno123',
        );

        expect(
          emprestimoRecebido!.alunoNome,
          'João da Silva',
        );

        expect(
          emprestimoRecebido!.livroIsbn,
          '9788532511010',
        );

        expect(
          emprestimoRecebido!.livroTitulo,
          'O Hobbit',
        );

        expect(
          emprestimoRecebido!.devolvido,
          false,
        );

        expect(
          emprestimoRecebido!.dataDevolucaoReal,
          null,
        );

        expect(
          find.text(
            'Empréstimo registrado com sucesso!',
          ),
          findsOneWidget,
        );

        expect(
          find.text('João da Silva - 7º A'),
          findsNothing,
        );

        expect(
          find.text('O Hobbit'),
          findsNothing,
        );

        expect(
          find.textContaining('Devolução prevista:'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'deve informar quando livro já estiver emprestado',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroEmprestimo(
              alunos: [alunoTeste],
              livros: [livroTeste],
              onCadastrar: (emprestimo) async {
                return null;
              },
            ),
          ),
        );

        await tester.tap(
          find.byType(
            DropdownButtonFormField<Aluno>,
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find
              .text('João da Silva - 7º A')
              .last,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.byType(
            DropdownButtonFormField<Livro>,
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('O Hobbit').last,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text(
            'Selecionar data de devolução',
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('OK'),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Esse livro já está emprestado.',
          ),
          findsOneWidget,
        );
      },
    );
  });
}