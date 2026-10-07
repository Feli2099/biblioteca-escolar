import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'package:biblioteca_escolar/telas/alunos/tela_cadastro_aluno.dart';

void main() {
  group('TelaCadastroAluno', () {
    testWidgets(
      'deve mostrar erro quando os campos estiverem vazios',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroAluno(
              onCadastrar: (aluno) async {},
            ),
          ),
        );

        await tester.tap(
          find.text('Cadastrar'),
        );

        await tester.pump();

        expect(
          find.text('Informe o nome completo'),
          findsOneWidget,
        );

        expect(
          find.text('Informe a turma'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'deve cadastrar aluno com nome e turma preenchidos',
          (tester) async {
        Aluno? alunoRecebido;

        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroAluno(
              onCadastrar: (aluno) async {
                alunoRecebido = aluno;
              },
            ),
          ),
        );

        final campos =
        find.byType(TextFormField);

        await tester.enterText(
          campos.at(0),
          'João da Silva',
        );

        await tester.enterText(
          campos.at(1),
          '7º A',
        );

        await tester.tap(
          find.text('Cadastrar'),
        );

        await tester.pumpAndSettle();

        expect(
          alunoRecebido,
          isNotNull,
        );

        expect(
          alunoRecebido!.nomeCompleto,
          'João da Silva',
        );

        expect(
          alunoRecebido!.turma,
          '7º A',
        );

        expect(
          find.text('Aluno cadastrado com sucesso!'),
          findsOneWidget,
        );
      },
    );
  });
}