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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (livro.urlCapa != null)
                          Container(
                            width: 80,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              livro.urlCapa!,
                              fit: BoxFit.cover,
                              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                              errorBuilder: (
                                  contextImagem,
                                  error,
                                  stackTrace,
                                  ) {
                                return const Center(
                                  child: Icon(
                                    Icons.menu_book,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            width: 80,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.menu_book,
                              size: 40,
                            ),
                          ),

                        const SizedBox(width: 16),

                        Expanded(
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
                      ],
                    ),
                  ),
                );
              },
          ),
    );
  }
}
