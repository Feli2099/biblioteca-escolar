import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class TelaListagemLivros extends StatefulWidget {
  final List<Livro> livros;
  final Future<void> Function(String) onExcluirLivro;

  const TelaListagemLivros({
    super.key,
    required this.livros,
    required this.onExcluirLivro,
  });

  @override
  State<TelaListagemLivros> createState() {
    return _TelaListagemLivrosState();
  }
}

class _TelaListagemLivrosState extends State<TelaListagemLivros> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros Cadastrados'),
      ),
      body: widget.livros.isEmpty
          ? const Center(
              child: Text('Nenhum livro cadastrado.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.livros.length,
              itemBuilder: (contextoItem, indice) {
                final livro = widget.livros[indice];

                return Card(
                  key: ValueKey(livro.isbn),
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
                              key: ValueKey(livro.urlCapa),
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

                        IconButton(
                          onPressed: () async {
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (contextoDialogo) {
                                return AlertDialog(
                                  title: const Text('Excluir livro'),
                                  content: Text('Deseja excluir "${livro.titulo}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          contextoDialogo,
                                          false,
                                        );
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          contextoDialogo,
                                          true
                                        );
                                      },
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmar != true) {
                              return;
                            }

                            try {
                              await widget.onExcluirLivro(
                                livro.isbn,
                              );

                              if (!mounted) {
                                return;
                              }

                              setState(() {});

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Livro excluído com sucesso!'),
                                ),
                              );
                            } catch (erro) {
                              if (!mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erro ao excluir o livro.'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.delete_outline,
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
