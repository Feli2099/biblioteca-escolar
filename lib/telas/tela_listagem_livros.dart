import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class TelaListagemLivros extends StatelessWidget {
  final List<Livro> livros;

  const TelaListagemLivros({
    super.key,
    required this.livros,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros Cadastrados'),
      ),
      body: livros.isEmpty
          ? const Center(
              child: Text('Nenhum livro cadastrado.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: livros.length,
              itemBuilder: (contextoItem, indice) {
                final livro = livros[indice];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          livro.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text('Autor: ${livro.autor}'),
                        Text('ISBN: ${livro.isbn}'),

                        if (livro.editora.trim().isNotEmpty)
                          Text('Editora: ${livro.editora}'),
                      ],
                    ),
                  ),
                );
              },
          ),
    );
  }
}
