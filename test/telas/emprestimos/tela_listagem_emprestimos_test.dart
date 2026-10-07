import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';
import 'package:biblioteca_escolar/telas/emprestimos/tela_listagem_emprestimos.dart';

void main() {
  final emprestimoAtivo = Emprestimo(
    id: 'emp123',
    alunoId: 'aluno123',
    alunoNome: 'João da Silva',
    livroIsbn: '9788532511010',
    livroTitulo: 'O Hobbit',
    dataEmprestimo: DateTime(2026, 10, 1),
    dataDevolucaoPrevista: DateTime(2026, 10, 8),
    devolvido: false,
  );

  final emprestimoDevolvido = Emprestimo(
    id: 'emp456',
    alunoId: 'aluno456',
    alunoNome: 'Maria Souza',
    livroIsbn: '9780451524935',
    livroTitulo: '1984',
    dataEmprestimo: DateTime(2026, 10, 1),
    dataDevolucaoPrevista: DateTime(2026, 10, 8),
    devolvido: true,
    dataDevolucaoReal: DateTime(2026, 10, 7),
  );

  group('TelaListagemEmprestimos', () {
    testWidgets(
      'deve mostrar mensagem quando não houver empréstimos',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaListagemEmprestimos(
              emprestimos: const [],
              onRegistrarDevolucao: (id) async {},
            ),
          ),
        );

        expect(
          find.text('Nenhum empréstimo registrado.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'deve exibir dados de empréstimo ativo',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaListagemEmprestimos(
              emprestimos: [emprestimoAtivo],
              onRegistrarDevolucao: (id) async {},
            ),
          ),
        );

        expect(
          find.text('O Hobbit'),
          findsOneWidget,
        );

        expect(
          find.text('Aluno: João da Silva'),
          findsOneWidget,
        );

        expect(
          find.text('Empréstimo: 01/10/2026'),
          findsOneWidget,
        );

        expect(
          find.text('Devolução prevista: 08/10/2026'),
          findsOneWidget,
        );

        expect(
          find.text('Status: Emprestado'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.assignment_return),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'não deve registrar devolução quando confirmação for cancelada',
          (tester) async {
        String? idRecebido;

        await tester.pumpWidget(
          MaterialApp(
            home: TelaListagemEmprestimos(
              emprestimos: [emprestimoAtivo],
              onRegistrarDevolucao: (id) async {
                idRecebido = id;
              },
            ),
          ),
        );

        await tester.tap(
          find.byIcon(Icons.assignment_return),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Confirmar devolução de "O Hobbit"?',
          ),
          findsOneWidget,
        );

        await tester.tap(
          find.widgetWithText(
            TextButton,
            'Cancelar',
          ),
        );

        await tester.pumpAndSettle();

        expect(
          idRecebido,
          isNull,
        );
      },
    );

    testWidgets(
      'deve registrar devolução após confirmação',
          (tester) async {
        String? idRecebido;

        await tester.pumpWidget(
          MaterialApp(
            home: TelaListagemEmprestimos(
              emprestimos: [emprestimoAtivo],
              onRegistrarDevolucao: (id) async {
                idRecebido = id;
              },
            ),
          ),
        );

        await tester.tap(
          find.byIcon(Icons.assignment_return),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(
            TextButton,
            'Confirmar',
          ),
        );

        await tester.pumpAndSettle();

        expect(
          idRecebido,
          'emp123',
        );

        expect(
          find.text(
            'Devolução registrada com sucesso!',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'deve exibir empréstimo devolvido sem botão de devolução',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaListagemEmprestimos(
              emprestimos: [emprestimoDevolvido],
              onRegistrarDevolucao: (id) async {},
            ),
          ),
        );

        expect(
          find.text('1984'),
          findsOneWidget,
        );

        expect(
          find.text('Status: Devolvido'),
          findsOneWidget,
        );

        expect(
          find.text('Devolvido em: 07/10/2026'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.assignment_return),
          findsNothing,
        );

        expect(
          find.byIcon(Icons.check_circle_outline),
          findsOneWidget,
        );
      },
    );
  });
}