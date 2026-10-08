import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/telas/livros/tela_listagem_livros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const capaBase64Teste =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';

void main() {
  group('TelaListagemLivros', () {
    testWidgets(
      'deve priorizar capa manual sobre capa da API',
          (tester) async {
        final livro = Livro(
          titulo: 'Livro Teste',
          autor: 'Autor Teste',
          isbn: '9788532511010',
          editora: 'Editora Teste',
          urlCapa: 'https://exemplo.com/capa.jpg',
          capaBase64: capaBase64Teste,
          quantidadeTotal: 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: TelaListagemLivros(
              livros: [livro],
              onExcluirLivro: (isbn) async {
                return true;
              },
              onAtualizarLivro: (livro) async {
                return true;
              },
              onContarEmprestimosAtivos: (isbn) async {
                return 0;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Livro Teste'),
          findsOneWidget,
        );

        final imagemFinder = find.byType(Image);

        expect(
          imagemFinder,
          findsOneWidget,
        );

        final imagem = tester.widget<Image>(
          imagemFinder,
        );

        expect(
          imagem.image,
          isA<MemoryImage>(),
        );
      },
    );

    testWidgets(
      'deve mostrar ícone quando livro não possui capa',
          (tester) async {
        final livro = Livro(
          titulo: 'Livro sem capa',
          autor: 'Autor Teste',
          isbn: '9788532511010',
          editora: 'Editora Teste',
          quantidadeTotal: 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: TelaListagemLivros(
              livros: [livro],
              onExcluirLivro: (isbn) async {
                return true;
              },
              onAtualizarLivro: (livro) async {
                return true;
              },
              onContarEmprestimosAtivos: (isbn) async {
                return 0;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byIcon(Icons.menu_book_outlined),
          findsOneWidget,
        );
      },
    );
  });
}