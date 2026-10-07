import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/telas/livros/tela_cadastro_livro.dart';

void main() {
  group('TelaCadastroLivro', () {
    testWidgets(
      'deve mostrar erro quando os campos obrigatórios estiverem vazios',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroLivro(
              onCadastrar: (livro) async {
                return true;
              },
            ),
          ),
        );

        await tester.tap(
          find.text('Cadastrar'),
        );

        await tester.pump();

        expect(
          find.text('Informe o título'),
          findsOneWidget,
        );

        expect(
          find.text('Informe o autor'),
          findsOneWidget,
        );

        expect(
          find.text('Informe o ISBN'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'deve rejeitar ISBN inválido',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroLivro(
              onCadastrar: (livro) async {
                return true;
              },
            ),
          ),
        );

        final campos = find.byType(TextFormField);

        await tester.enterText(
          campos.at(0),
          'Livro Teste',
        );

        await tester.enterText(
          campos.at(1),
          'Autor Teste',
        );

        await tester.enterText(
          campos.at(2),
          '123456',
        );

        await tester.enterText(
          campos.at(3),
          'Editora Teste',
        );

        await tester.tap(
          find.text('Cadastrar'),
        );

        await tester.pump();

        expect(
          find.text('Informe um ISBN válido'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'deve cadastrar livro com dados válidos',
          (tester) async {
        Livro? livroRecebido;

        await tester.pumpWidget(
          MaterialApp(
            home: TelaCadastroLivro(
              onCadastrar: (livro) async {
                livroRecebido = livro;
                return true;
              },
            ),
          ),
        );

        final campos = find.byType(TextFormField);

        await tester.enterText(
          campos.at(0),
          'O Hobbit',
        );

        await tester.enterText(
          campos.at(1),
          'J. R. R. Tolkien',
        );

        await tester.enterText(
          campos.at(2),
          '9788532511010',
        );

        await tester.enterText(
          campos.at(3),
          'HarperCollins',
        );

        await tester.tap(
          find.text('Cadastrar'),
        );

        await tester.pumpAndSettle();

        expect(
          livroRecebido,
          isNotNull,
        );

        expect(
          livroRecebido!.titulo,
          'O Hobbit',
        );

        expect(
          livroRecebido!.autor,
          'J. R. R. Tolkien',
        );

        expect(
          livroRecebido!.isbn,
          '9788532511010',
        );

        expect(
          livroRecebido!.editora,
          'HarperCollins',
        );
      },
    );
  });
}