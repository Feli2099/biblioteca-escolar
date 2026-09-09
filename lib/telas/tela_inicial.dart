import 'package:flutter/material.dart';
import 'tela_livros.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() {
    return _TelaInicialState();
  }
}

class _TelaInicialState extends State<TelaInicial> {
  final List<Livro> _livros = [];

  bool _adicionarLivro(Livro livro) {
    final isbnNovo = _normalizarIsbn(livro.isbn);

    final isbnJaExiste = _livros.any(
      (livroExistente) =>
          _normalizarIsbn(livroExistente.isbn) == isbnNovo,
    );

    if (isbnJaExiste) {
      return false;
    }

    setState(() {
      _livros.add(livro);
    });

    print('Quantidade de livros: ${_livros.length}');

    return true;
  }

  String _normalizarIsbn(String isbn) {
    return isbn.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  }

  @override
  Widget build(BuildContext contextTelaInicial) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Escolar'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_library,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'Sistema da Biblioteca',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  contextTelaInicial,
                  MaterialPageRoute(
                    builder: (contextoRotaLivros) {
                      return TelaLivros(
                        livros: _livros,
                        onAdicionarLivro: _adicionarLivro,
                      );
                    },
                  ),
                );
              },
              child: const Text('Livros'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Alunos'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Empréstimos'),
            )
          ],
        ),
      ),
    );
  }
}