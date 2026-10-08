import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/telas/livros/tela_edicao_livro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const capaBase64Teste =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';

Future<void> abrirTelaEdicao(
    WidgetTester tester,
    Livro livro,
    void Function(Livro?) aoRetornar,
    ) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              final resultado = await Navigator.push<Livro>(
                context,
                MaterialPageRoute(
                  builder: (contextTelaEdicao) {
                    return TelaEdicaoLivro(
                      livro: livro,
                    );
                  },
                ),
              );

              aoRetornar(resultado);
            },
            child: const Text('Editar'),
          );
        },
      ),
    ),
  );

  await tester.tap(
    find.text('Editar'),
  );

  await tester.pumpAndSettle();
}

Future<void> salvarAlteracoes(
    WidgetTester tester,
    ) async {
  final botaoSalvar = find.widgetWithText(
    ElevatedButton,
    'Salvar alterações',
  );

  await tester.ensureVisible(
    botaoSalvar,
  );

  await tester.pumpAndSettle();

  await tester.tap(
    botaoSalvar,
  );

  await tester.pumpAndSettle();
}

void main() {
  group('TelaEdicaoLivro', () {
    testWidgets(
      'deve preservar capa manual ao salvar sem alterar',
          (tester) async {
        Livro? livroRetornado;

        final livro = Livro(
          titulo: 'Livro Teste',
          autor: 'Autor Teste',
          isbn: '9788532511010',
          editora: 'Editora Teste',
          capaBase64: capaBase64Teste,
        );

        await abrirTelaEdicao(
          tester,
          livro,
              (resultado) {
            livroRetornado = resultado;
          },
        );

        await salvarAlteracoes(tester);

        expect(
          livroRetornado,
          isNotNull,
        );

        expect(
          livroRetornado!.capaBase64,
          capaBase64Teste,
        );
      },
    );

    testWidgets(
      'deve remover capa manual',
          (tester) async {
        Livro? livroRetornado;

        final livro = Livro(
          titulo: 'Livro Teste',
          autor: 'Autor Teste',
          isbn: '9788532511010',
          editora: 'Editora Teste',
          capaBase64: capaBase64Teste,
        );

        await abrirTelaEdicao(
          tester,
          livro,
              (resultado) {
            livroRetornado = resultado;
          },
        );

        final botaoRemover = find.widgetWithText(
          TextButton,
          'Remover capa',
        );

        await tester.ensureVisible(
          botaoRemover,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          botaoRemover,
        );

        await tester.pumpAndSettle();

        await salvarAlteracoes(tester);

        expect(
          livroRetornado,
          isNotNull,
        );

        expect(
          livroRetornado!.capaBase64,
          isNull,
        );
      },
    );
  });
}