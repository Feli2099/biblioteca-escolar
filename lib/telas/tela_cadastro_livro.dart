import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/servicos/google_books_service.dart';
import 'package:biblioteca_escolar/servicos/open_library_service.dart';
import 'package:biblioteca_escolar/telas/tela_scanner_isbn.dart';

class TelaCadastroLivro extends StatefulWidget {
  final Future<bool> Function(Livro) onCadastrar;

  const TelaCadastroLivro({
    super.key,
    required this.onCadastrar,
  });

  @override
  State<TelaCadastroLivro> createState() {
    return _TelaCadastroLivro();
  }
}

class _TelaCadastroLivro extends State<TelaCadastroLivro> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();
  String? _urlCapa;
  bool _buscandoLivro = false;

  final _formKey = GlobalKey<FormState>();

  final GoogleBooksService _googleBooksService = GoogleBooksService();
  final OpenLibraryService _openLibraryService = OpenLibraryService();

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _isbnController.dispose();
    _editoraController.dispose();

    super.dispose();
  }

  bool _isbnValido(String isbn) {
    final isbnLimpo = isbn.replaceAll(RegExp(r'[\s-]'), '');

    if (isbnLimpo.length == 10) {
      return _validarIsbn10(isbnLimpo);
    }

    if (isbnLimpo.length == 13) {
      return _validarIsbn13(isbnLimpo);
    }

    return false;
  }

  bool _validarIsbn13(String isbn) {
    if (!RegExp(r'^\d{13}$').hasMatch(isbn)) {
      return false;
    }

    int soma = 0;

    for (int i = 0; i < 12; i++) {
      final digito = int.parse(isbn[i]);

      if (i % 2 == 0) {
        soma += digito;
      } else {
        soma += digito * 3;
      }
    }

    final digitoVerificador = (10 - (soma % 10)) % 10;

    return digitoVerificador == int.parse(isbn[12]);
  }

  bool _validarIsbn10(String isbn) {
    if (!RegExp(r'^\d{9}[\dXx]$').hasMatch(isbn)) {
      return false;
    }

    int soma = 0;

    for (int i = 0; i < 9; i++) {
      final digito = int.parse(isbn[i]);
      soma += digito * (10 - i);
    }

    final ultimoCaractere = isbn[9];

    final digitoVerificador =
    ultimoCaractere.toUpperCase() == 'X'
        ? 10
        : int.parse(ultimoCaractere);

    soma += digitoVerificador;

    return soma % 11 == 0;
  }

  Future<void> _buscarLivroPorIsbn(String isbn,
      BuildContext contextTelaCadastroLivro,) async {
    if (!_isbnValido(isbn)) {
      ScaffoldMessenger.of(contextTelaCadastroLivro).showSnackBar(
        const SnackBar(
          content: Text('Informe um ISBN válido antes de buscar.'),
        ),
      );

      return;
    }

    if (_buscandoLivro) {
      return;
    }

    setState(() {
      _buscandoLivro = true;
    });

    try {
        Map<String, dynamic>? dadosGoogle;
        Map<String, dynamic>? dadosOpenLibrary;

        bool erroGoogle = false;
        bool erroOpenLibrary = false;

        try {
          dadosGoogle = await _googleBooksService.buscarPorIsbn(isbn);
        } catch (erro) {
          erroGoogle = true;
        }

        try {
          dadosOpenLibrary = await _openLibraryService.buscarPorIsbn(isbn);
        } catch (erro) {
          erroOpenLibrary = true;
        }

      if (!contextTelaCadastroLivro.mounted) {
        return;
      }

      if (dadosGoogle == null && dadosOpenLibrary == null) {
        if (erroGoogle && erroOpenLibrary) {
          ScaffoldMessenger.of(
            contextTelaCadastroLivro,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Não foi possível consultar os serviços de livros.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            contextTelaCadastroLivro,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Livro não encontrado. Preencha os dados manualmente.',
              ),
            ),
          );
        }

        return;
      }

      String? titulo;

      if (dadosGoogle != null) {
        final tituloGoogle = dadosGoogle['title'];

        if (tituloGoogle is String) {
          titulo = tituloGoogle;
        }
      }

      if (titulo == null && dadosOpenLibrary != null) {
        final tituloOpenLibrary = dadosOpenLibrary['title'];

        if (tituloOpenLibrary is String) {
          titulo = tituloOpenLibrary;
        }
      }

      String? autor;

      if (dadosGoogle != null) {
        final autoresGoogle = dadosGoogle['authors'];

        if (autoresGoogle is List && autoresGoogle.isNotEmpty) {
          autor = autoresGoogle.join(', ');
        }
      }

      if (autor == null && dadosOpenLibrary != null) {
        final autoresOpenLibrary = dadosOpenLibrary['authors'];

        if (autoresOpenLibrary is List &&
            autoresOpenLibrary.isNotEmpty) {
          final primeiroAutor = autoresOpenLibrary.first;

          if (primeiroAutor is Map<String, dynamic>) {
            final chaveAutor = primeiroAutor['key'];

            if (chaveAutor is String) {
              try {
                autor = await _openLibraryService.buscarNomeAutor(
                  chaveAutor,
                );
              } catch (erro) {
                autor = null;
              }

              if (!contextTelaCadastroLivro.mounted) {
                return;
              }
            }
          }
        }
      }

      String? editora;

      if (dadosGoogle != null) {
        final editoraGoogle = dadosGoogle['publisher'];

        if (editoraGoogle is String && editoraGoogle.isNotEmpty) {
          editora = editoraGoogle;
        }
      }

      if (editora == null && dadosOpenLibrary != null) {
        final editorasOpenLibrary = dadosOpenLibrary['publishers'];

        if (editorasOpenLibrary is List && editorasOpenLibrary.isNotEmpty) {
          final primeiraEditora = editorasOpenLibrary.first;

          if (primeiraEditora is String) {
            editora = primeiraEditora;
          }
        }
      }

      String? urlCapa;

      if (dadosGoogle != null) {
        final imageLinks = dadosGoogle['imageLinks'];

        if (imageLinks is Map<String, dynamic>) {
          final thumbnail = imageLinks['thumbnail'];

          if (thumbnail is String && thumbnail.isNotEmpty) {
            urlCapa = thumbnail;
          }
        }
      }

      if (urlCapa == null && dadosOpenLibrary != null) {
        final capasOpenLibrary = dadosOpenLibrary['covers'];

        if (capasOpenLibrary is List && capasOpenLibrary.isNotEmpty) {
          final primeiraCapa = capasOpenLibrary.first;

          if (primeiraCapa is int) {
            urlCapa = 'https://covers.openlibrary.org/b/id/$primeiraCapa-M.jpg';
          }
        }
      }

      _tituloController.text = titulo ?? '';
      _autorController.text = autor ?? '';
      _editoraController.text = editora ?? '';
      _urlCapa = urlCapa;
    } finally {
      if (mounted) {
        setState(() {
          _buscandoLivro = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext contextTelaCadastroLivro) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Livros'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                  ),

                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o título';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _autorController,
                  decoration: const InputDecoration(
                    labelText: 'Autor',
                  ),

                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o autor';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _isbnController,
                  decoration: const InputDecoration(
                    labelText: 'ISBN',
                  ),

                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o ISBN';
                    }

                    if (!_isbnValido(valor)) {
                      return 'Informe um ISBN válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: _buscandoLivro
                      ? null
                      : () async {
                    final codigo = await Navigator.push<String>(
                      contextTelaCadastroLivro,
                      MaterialPageRoute(
                        builder: (contextRotaScanner) =>
                        const TelaScannerIsbn(),
                      ),
                    );

                    if (!contextTelaCadastroLivro.mounted) {
                      return;
                    }

                    if (codigo == null) {
                      return;
                    }

                    _isbnController.text = codigo;

                    await _buscarLivroPorIsbn(
                      codigo,
                      contextTelaCadastroLivro,
                    );
                  },
                  child: Text(
                    _buscandoLivro
                        ? 'Buscando...'
                        : 'Escanear ISBN',
                  ),
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _editoraController,
                  decoration: const InputDecoration(
                    labelText: 'Editora',
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _buscandoLivro
                  ? null
                  : () async {
                      final isbn = _isbnController.text.trim();

                      await _buscarLivroPorIsbn(isbn, contextTelaCadastroLivro);
                  },
                  child: Text(
                    _buscandoLivro
                        ? 'Buscando...'
                        : 'Buscar iSBN'
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final titulo = _tituloController.text.trim();
                      final autor = _autorController.text.trim();
                      final isbn = _isbnController.text.trim();
                      final editora = _editoraController.text.trim();

                      final livro = Livro(
                        titulo: titulo,
                        autor: autor,
                        isbn: isbn,
                        editora: editora,
                        urlCapa: _urlCapa,
                      );

                      try {
                        final cadastrado = await widget.onCadastrar(livro);

                        if (!contextTelaCadastroLivro.mounted) {
                          return;
                        }

                        if (!cadastrado) {
                          ScaffoldMessenger.of(contextTelaCadastroLivro).showSnackBar(
                            const SnackBar(
                              content: Text('Já existe um livro cadastrado com esse ISBN.'),
                            ),
                          );

                          return;
                        }
                      } catch(erro) {

                        if (!contextTelaCadastroLivro.mounted) {
                          return;
                        }
                        ScaffoldMessenger.of(contextTelaCadastroLivro).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao salvar o livro no banco de dados.'),
                          ),
                        );

                        return;
                      }

                      ScaffoldMessenger.of(contextTelaCadastroLivro).showSnackBar(
                        const SnackBar(
                          content: Text('Livro cadastrado com sucesso!'),
                        ),
                      );

                      _tituloController.clear();
                      _autorController.clear();
                      _isbnController.clear();
                      _editoraController.clear();
                      setState(() {
                        _urlCapa = null;
                      });
                    }
                  },
                  child: const Text("Cadastrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}