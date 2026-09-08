import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class TelaCadastroLivro extends StatefulWidget {
  final void Function(Livro) onCadastrar;

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

  final _formKey = GlobalKey<FormState>();

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

    for (int i = 0; i <12; i++) {
      final digito = int.parse(isbn[i]);

      if (i % 2 == 0) {
        soma += digito;
      } else {
        soma += digito * 3;
      }
    }

    final digitoVerificador = (10 - (soma % 10)) %10;

    return digitoVerificador == int.parse(isbn[12]);
  }

  bool _validarIsbn10(String isbn) {
    if (!RegExp(r'^\d{9}[\dXx]$').hasMatch(isbn)) {
      return false;
    }

    int soma = 0;

    for (int i = 0; i <9; i++) {
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

  @override
  Widget build(BuildContext contextTelaCadastroLivro) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Livros'),
      ),
      body: Padding(
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
                  if (valor == null || valor.isEmpty) {
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
                  if (valor == null || valor.isEmpty) {
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

              SizedBox(height: 16),

              TextFormField(
                controller: _editoraController,
                decoration: const InputDecoration(
                  labelText: 'Editora',
                ),

                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe a Editora';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final titulo = _tituloController.text;
                      final autor = _autorController.text;
                      final isbn = _isbnController.text;
                      final editora = _editoraController.text;

                      final livro = Livro(
                          titulo: titulo,
                          autor: autor,
                          isbn: isbn,
                          editora: editora,
                      );

                      widget.onCadastrar(livro);

                      print('Título: ${livro.titulo}');
                      print('Autor: ${livro.autor}');
                      print('ISBN: ${livro.isbn}');
                      print('Editora: ${livro.editora}');
                    }
                  },
                  child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      )
    );
  }
}